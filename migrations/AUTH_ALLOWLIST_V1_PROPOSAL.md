# QualifierManageOS — Staff allowlist auth v1 proposal (0005)

**Status:** PROPOSAL ONLY — not applied  
**Audience:** `[INTERNAL ONLY]`  
**Sequencing:** shape yes → separate apply yes (same as RLS)  
**Depends on:** live `0001`–`0004` (RLS helpers already read JWT `qmos_role`)  
**Tip baseline when drafted:** `85acdf75e35e8d96bb62deb2c41d9af5e2a0a4b8`

## Why this slice

Live RLS admits staff only when `auth.jwt() ->> 'qmos_role'` is one of the five DATA_MODEL roles. Nothing today mints that claim. This proposal wires **who may sign in as staff** and **how `qmos_role` lands in the JWT**.

---

## 1) Where the allowlist lives

### Confirm vs Rose’s guess

**Partly right.** Existing `staff` already owns the **role** (and is the FK directory the UI / seed use). Live shape today:

| Column | Present? |
|---|---|
| `name` (PK) | yes |
| `role` | yes (`Leadership` / `Admin` / `Placement Coordinator` / `Fulfillment` / `Sales Viewer`) |
| `email` | **no** |
| link to Auth user | **no** |
| active / disabled | **no** |

So: **extend `staff` — do not invent a parallel allowlist table.** One row = one staff person = one allowlist entry.

### Proposed columns on `staff`

| Column | Type | Purpose |
|---|---|---|
| `email` | `text` UNIQUE, case-folded via unique index on `lower(email)` | Auth identity match |
| `auth_user_id` | `uuid` UNIQUE NULL, → `auth.users(id)` ON DELETE SET NULL | Stable link after first login |
| `active` | `boolean NOT NULL DEFAULT true` | Soft remove from allowlist without breaking FKs on `name` |

**Allowlisted** = `active = true` AND `email IS NOT NULL`.

Prefer soft-disable (`active = false`) over `DELETE` — `staff.name` is referenced across qualifiers, needs, matches, reviews, risks, audit log.

No separate `staff_allowlist` table for v1 (avoids dual SoT for role).

---

## 2) How `qmos_role` gets into the JWT

**Mechanism: Supabase Custom Access Token Auth Hook** (Postgres function), not client-set claims and not a browser-only role picker.

### Flow

```
Staff signs in (email + password)
        ↓
GoTrue mints access token
        ↓
Calls public.qmos_custom_access_token_hook(event jsonb)
  as role supabase_auth_admin
        ↓
Hook looks up staff by:
  1) auth_user_id = event.user_id, else
  2) lower(email) = lower(event.claims.email)
  AND active = true
        ↓
If found:
  claims.qmos_role       := staff.role
  claims.qmos_staff_name := staff.name
  (optional) stamp staff.auth_user_id on first match
If not found:
  do NOT set qmos_role / qmos_staff_name
  (leave claims unchanged — no raise)
        ↓
JWT issued → PostgREST RLS uses auth.jwt() ->> 'qmos_role'
  via existing qmos_jwt_role() / qmos_is_staff() / …
```

### Why this (not alternatives)

| Approach | Verdict |
|---|---|
| **Custom Access Token Hook** | Correct — claim is server-minted, matches how `0002` already reads JWT |
| Client writes `user_metadata.role` | Reject — forgeable |
| `app_metadata` via Admin API only | Possible backup, but hook keeps role SoT on `staff` and refreshes on every token issue/refresh |
| Edge Function hook | Extra hop; Postgres hook stays in-project and can read `staff` under `supabase_auth_admin` |

### Ops step (not SQL alone)

After apply: Dashboard → **Authentication → Hooks → Custom Access Token** → select `qmos_custom_access_token_hook`.  
Until that toggle is on, JWTs will not carry `qmos_role` even if the function exists.

### Grants the hook needs

- `GRANT EXECUTE ON FUNCTION qmos_custom_access_token_hook(jsonb) TO supabase_auth_admin`
- `REVOKE ALL … FROM PUBLIC, anon, authenticated` (same hygiene lesson as 0004)
- `GRANT SELECT` (and limited `UPDATE` for `auth_user_id` stamp) on `staff` **to `supabase_auth_admin`** so the hook can read/update the allowlist  
- Hook is **INVOKER** (not `SECURITY DEFINER`). GoTrue runs it as `supabase_auth_admin`.
  - **Correction (live 0006):** on this project `supabase_auth_admin.rolbypassrls = false`, so FORCE RLS still applies. `0006` adds `staff` policies for `supabase_auth_admin` SELECT/UPDATE so the hook can read/stamp the allowlist without switching to DEFINER.
  - Hook is **VOLATILE** (not STABLE) because it may `UPDATE staff.auth_user_id` on first match.

### Role change latency

Changing `staff.role` or `active` takes effect on the **next** access-token issue/refresh, not mid-token. Document: after demote/deactivate, force sign-out or wait for refresh. Acceptable for internal v1.

---

## 3) Who can add / remove someone

| Action | Who | How |
|---|---|---|
| Add / edit allowlist row (`email`, `role`, `active`) | **Leadership / Admin only** | Existing `staff` write policy: `qmos_can_approve()` |
| Soft-remove | Leadership / Admin | `UPDATE staff SET active = false` |
| Hard-delete staff row | Avoid in v1 | Breaks FKs; not required |
| Create Auth login (password / invite) | **Admin path only** | Supabase Auth: **disable public signup**. Invite / create user via service_role (server or dashboard). Matching `staff.email` required for claims. |
| Bootstrap first Admin | Carmen / SQL with **service_role** | Chicken-egg: no JWT yet → seed first Leadership/Admin row + Auth user via dashboard/service_role |

Sales Viewer / Placement / Fulfillment: **cannot** mutate `staff` (already true under live RLS).

---

## 4) Authenticated but not on the allowlist

**Behave like anon for RLS — do not error.**

| Caller | JWT `qmos_role` | `qmos_is_staff()` | Table SELECT |
|---|---|---|---|
| `anon` | absent | false / null → deny | empty / permission as today |
| `authenticated`, not on allowlist / `active=false` | **absent** (hook sets nothing) | false | **same deny** — empty rows, no exception |
| Allowlisted staff | set | true | policies apply by role |

Hook must **not** `RAISE` when no staff row matches. Sign-in succeeds; data access fails closed via missing claim (same as today for any JWT without `qmos_role`).

Optional later (UI only, not DB): show “not authorized for QualifierManageOS” after login when claim missing — still no data leak.

---

## 5) Out of scope for 0005 (held)

- SPA login UI replacing nginx basic-auth (can land in a follow-on UI slice)
- Invite email copy / Linda training
- Read/write API + seed load
- Clerk satellite (not replacing allowlist)
- Open signup or magic-link for arbitrary emails

---

## 6) Verify plan (after apply + hook enabled)

1. Journal row `0005_staff_allowlist_auth_v1`
2. `\d staff` shows `email`, `auth_user_id`, `active`
3. `has_function_privilege('anon', 'qmos_custom_access_token_hook(jsonb)', 'EXECUTE')` = false  
   `…('authenticated', …)` = false  
   `…('supabase_auth_admin', …)` = true
4. Dashboard Custom Access Token hook points at the function
5. Allowlisted user: decode access token → `qmos_role` + `qmos_staff_name` present; can `SELECT` under RLS
6. Auth user **not** on `staff` (or `active=false`): token has **no** `qmos_role`; `SELECT` returns 0 rows (not a data leak / not a thrown RPC error on table read)
7. Public signup remains **disabled**

---

## 7) Ask-backs (only if Rose disagrees)

Defaulting these unless you say otherwise:

1. **Extend `staff`** (not a new allowlist table) — Y/N  
2. Soft-remove via **`active=false`** — Y/N  
3. Hook **does not raise** for unknown users — Y/N  
4. Public Auth signup **off** — Y/N  
5. First Admin bootstrap via **service_role / dashboard** — Y/N  

SQL draft: `migrations/0005_staff_allowlist_auth_v1.sql` (PROPOSAL — do not apply until shape yes + apply yes).
