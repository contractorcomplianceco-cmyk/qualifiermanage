# QualifierManageOS — Read/write API v1 proposal

**Status:** PROPOSAL ONLY — not applied / not wired in the UI  
**Audience:** `[INTERNAL ONLY]`  
**Sequencing:** shape yes → separate apply/wire yes (same as RLS / allowlist)  
**Depends on:** live `0001`–`0006` (schema, RLS, allowlist JWT `qmos_role`)  
**Tip baseline when drafted:** `fb9a0bbd44107e22fde65cbea2dbeba337058e8f`  
**Companion SQL (writes + audit RPCs):** `migrations/0007_api_write_rpcs_v1.sql` (PROPOSAL)

---

## Goal

Retire `import('./data.js')` so the staff UI hydrates and writes against **live Supabase under RLS + JWT `qmos_role`**.

**Hard rules for this slice**

- No AuditEngine / Docs Collect / Zoho **seams** turned on  
- **No fabricated rows** standing in for empty tables (honest empty until seed)  
- **No `service_role` in the browser** and no accidental service-role path on any staff-facing route  
- Outer **nginx basic-auth** may stay as a second door; it does **not** replace Supabase JWT for data access

---

## 1) Architecture (recommended)

```
Browser (QualifierManageOS.dc.html + coverage-map.html)
  ├─ Supabase Auth: email/password → access_token with qmos_role / qmos_staff_name
  ├─ @supabase/supabase-js (anon key ONLY + user JWT)
  │     GET  tables / views  (RLS)
  │     RPC  qmos_approve_match / qmos_set_risk  (RLS + audit)
  └─ Small adapter: snake_case DB → camelCase data.js shape
```

| Choice | Verdict |
|---|---|
| **Browser → PostgREST with user JWT** | **Yes** — RLS is the gate we already built |
| Host BFF with `service_role` for staff reads | **No** — bypasses RLS; forbidden for this slice |
| Host BFF that only forwards the **user** JWT | Optional later; not required for v1 |
| Keep `data.js` / `data.bulk.js` as runtime fallback | **No** after cutover — remove the import seam (files may remain on disk for seed authoring until seed slice) |

### Auth on every route

| Path | Auth |
|---|---|
| All table/view SELECTs | `Authorization: Bearer <user JWT>`; role `authenticated`; RLS `qmos_is_staff()` |
| Write RPCs | Same JWT; RPC checks `qmos_can_approve` / `qmos_can_edit` inside |
| Anon key alone | **Zero** table SELECT grants for `anon` (already true) → permission denied |
| `service_role` | **Never** shipped to browser; **never** used by staff UI code paths |

Client must **not** fall back to `import('./data.js')` on 401/empty. Fail closed: show auth / empty UI.

### Minimal login (required for JWT)

Allowlist auth is live, but the SPA still uses a **role picker** (no Supabase session). This API slice **includes** a minimal email/password sign-in that establishes a Supabase session before hydrate.

- Role picker **stops being authoritative** for data: UI role = JWT `qmos_role` (display only)  
- `cycleRole()` demo cycling is **removed or disabled** when live API is on (cannot mint foreign roles)  
- nginx basic-auth can remain until a later “drop basic-auth” yes

---

## 2) Full map: `data.js` export → live source

UI contract today: `state.db = { TODAY, STAFF, CITIES, QUALIFIERS, … }` from `import('./data.js')`.  
After cutover: same object shape from `qmosApi.hydrate()` (adapter). **Nothing listed here is silently dropped.**

### Reads (hydrate)

| `data.js` export | UI consumers | Live source | Notes |
|---|---|---|---|
| `QUALIFIERS` | Main app lists/detail/KPIs/map | **`v_qualifiers_public_fields`** | View returns `admin_only_notes` only when Leadership/Admin; else `NULL`. Do **not** SELECT base `qualifiers.admin_only_notes`. |
| `LICENSES` | License register, KPIs, map | `licenses` | |
| `AVAILABILITY` | Availability, map | `availability` | |
| `DOCUMENTS` | Docs register / detail | `documents` | `internal_notes` visible to all staff roles in v1 (matches prototype; revisit later if needed) |
| `NEEDS` | Needs, match context, map | `needs` | |
| `MATCHES` | Match Center (`effMatches`) | `matches` | No client `matchOverrides` after cutover |
| `PLACEMENTS` | Placements, dashboard, map | `placements` | Adapter may still hide `internalPlacementNotes` from Sales Viewer in UI (column is granted to staff; optional UI filter — not an RLS change in this slice) |
| `REVIEWS` | Qualifier Reviews tab | `reviews` | RLS already hides `admin_only = true` rows from non-admins |
| `RISKS` | Risk Review (`effRisks`) | **`v_risks_public_fields`** | View nulls `resolution_notes` for non-admins |
| `STAFF` | Reports leaderboard role map | `staff` | Columns: `name`, `role` (+ `email`/`active` unused by UI for now) |
| `CITIES` | Inline map + `coverage-map.html` | `cities` | DB rows `(city,lng,lat)` → adapter builds `{ [city]: [lng,lat] }` |
| `COVERAGE_GAPS` | Nav badge, map, KPIs | `coverage_gaps` | DB has `id uuid`; UI shape omits id — adapter drops or keeps harmlessly |
| `TODAY` | Prototype hardcodes dates in places | **Client local date** `YYYY-MM-DD` (or single `qmos_today()` RPC later) | Not a table; **do not** invent business dates from seed |

**Hydrate transport:** `Promise.all` of Supabase `.from(…).select(*)` (and the two views), then one adapter pass → `state.db`.  
No single DEFINER “give me everything” RPC (avoids a new fail-open surface).

**Consumers that must switch**

| File | Today | After |
|---|---|---|
| `QualifierManageOS.dc.html` | `import('./data.js')` in `componentDidMount` | `await qmosApi.hydrate()` after session |
| `coverage-map.html` | `import('./data.js')` | Same client hydrate **or** receive collections from parent — must not keep seed import |

### Writes (replace localStorage)

| Prototype API | UI gate today | Live endpoint | Server gate | Audit |
|---|---|---|---|---|
| `approveMatch(id, status)` | `canAdmin` (client) | **RPC `qmos_approve_match(p_id, p_status)`** | `qmos_can_approve()`; fail-closed `COALESCE` | INSERT `decision_audit_log` (`approve_match`) |
| `setRisk(id, status)` | `canEditRisk` (client) | **RPC `qmos_set_risk(p_id, p_status)`** | `qmos_can_edit()`; fail-closed | INSERT `decision_audit_log` (`set_risk`) |

**RLS note (ask-back):** `0002` limited `decision_audit_log` INSERT to `qmos_can_approve()` only. That would block Placement Coordinator / Fulfillment from completing `qmos_set_risk` (update succeeds, audit INSERT fails). `0007` proposes widening audit INSERT to `can_approve OR can_edit` (SELECT unchanged). Match approve remains Admin/Leadership inside the RPC.

- Persist `admin_approval_status` / `risk_status` on the row; set `reviewed_by` / `reviewed_date` from JWT `qmos_staff_name` + `now()`  
- Delete use of `localStorage` key `qmos.prototype.overrides.v1` and `matchOverrides` / `riskOverrides`  
- Toast copy: drop “prototype session”; say decision recorded (audit log)

### Honest stubs (unchanged — **no fake success API**)

These stay **toast-only** in v1 (no routes that pretend to write):

| UI action | Behavior |
|---|---|
| Add qualifier / Add need | Toast only |
| Export | Toast only |
| License verify / portal / flag | Toast only |
| Document remind | Toast only |
| Reports finance placeholders | Labeled placeholders — not API-backed |

---

## 3) Admin-notes RPCs — wire or not?

| Mechanism | Role in API v1 |
|---|---|
| `v_qualifiers_public_fields` / `v_risks_public_fields` | **Wired into hydrate** — primary read path for notes (null unless Leadership/Admin) |
| `qmos_get_qualifier_admin_notes` / `qmos_get_risk_resolution_notes` | **Not required for hydrate** (views cover read). Keep granted for authenticated; optional detail refresh |
| `qmos_set_qualifier_admin_notes` / `qmos_set_risk_resolution_notes` | **Not wired in UI v1** — prototype does not edit notes (display only). Stay available for a later notes-edit slice |

So: **reads via views in the hydrate map; set_* RPCs stay server-ready but UI-unwired.**

---

## 4) Authenticated but not allowlisted

RLS already returns empty sets when JWT lacks `qmos_role`. API layer must not turn that into a 500.

| Signal | API / client behavior |
|---|---|
| Sign-in succeeds, JWT has **no** `qmos_role` | Treat as **not authorized for QMOS** — show clear screen: “You’re signed in but not on the QualifierManageOS staff allowlist.” **Do not hydrate.** |
| Hydrate somehow runs without claim | Supabase returns `[]` / 200 — client should still detect missing claim **before** hydrate and refuse, so empty tables are not confused with “not allowlisted” |
| Anon / missing session | Redirect / gate to sign-in — no data calls |
| PostgREST `42501` / permission denied | Map to **401/403** UI copy, not generic 500 |
| Write RPC raises `forbidden: …` | Surface **403** with the exception message (sanitized), not 500 |

---

## 5) Honest-empty behavior (pre-seed)

Until the seed slice lands, tables are empty. That is **correct**.

| Case | Response |
|---|---|
| Staff allowlisted, tables empty | Hydrate succeeds → all collections **`[]`**, `CITIES` **`{}`**, KPIs **0**, maps empty — **legitimate empty command center** |
| Errors | Only for auth/network/permission failures — **not** for “zero rows” |
| Forbidden | Filling empty arrays from `data.js` / `data.bulk.js` “so preview looks full” |

Live preview may look sparse; that is intentional until seed.

---

## 6) CamelCase adapter (contract)

DB is snake_case; UI expects camelCase (`fullName`, `adminApprovalStatus`, …).  

Propose one module `qmos-api.js` (name flexible) that:

1. Requires a session with `qmos_role`  
2. Hydrates via parallel selects  
3. Maps rows → `data.js` field names 1:1 with `DATA_MODEL.md`  
4. Exposes `approveMatch` / `setRisk` calling RPCs  

`readiness` parts are **derived** in DATA_MODEL — v1 may expose `readiness_score` only (or `{ score, parts: [] }`) until a derive slice; **do not invent parts**.

---

## 7) SQL to apply with this slice (after shape yes)

`0007_api_write_rpcs_v1.sql` (draft alongside this proposal):

- `qmos_approve_match(text, text)` — VOLATILE, INVOKER, fail-closed role check, update match + audit insert  
- `qmos_set_risk(text, text)` — same for risk status  
- `REVOKE ALL … FROM PUBLIC, anon, authenticated` then `GRANT EXECUTE … TO authenticated` only (0004 hygiene)  
- Allowed status vocabularies match DATA_MODEL enums used by the UI today  

No seed. No seam tables. No service_role grants.

---

## 8) Apply / wire plan (after separate yes)

1. Apply `0007` to live DB; journal check  
2. Add `qmos-api.js` + minimal sign-in UI; point `QualifierManageOS.dc.html` + `coverage-map.html` at hydrate  
3. Remove runtime `import('./data.js')`  
4. Env on host (names only in git): `SUPABASE_URL`, `SUPABASE_ANON_KEY` — **never** service_role in frontend  
5. Soft redeploy staff preview; smoke:  
   - allowlisted Admin → empty hydrate OK; approve/setRisk forbidden until seed rows exist (clean error if id missing)  
   - non-allowlisted → not-authorized screen  
   - anon key alone → no data  
6. Confirm no `data.bulk` / fabricated fill

---

## 9) Out of scope (held)

- Seed load / retiring `data.bulk.js` as a data product  
- Notes **edit** UI + set_* RPC wiring  
- Dropping nginx basic-auth  
- Clerk satellite  
- Sync seams  
- Add-qualifier / export real writes  
- Fabricating demo rows in the API

---

## 10) Ask-backs (defaults if Rose agrees)

1. Browser Supabase JS + user JWT (no service_role BFF) — **Y/N**  
2. Minimal email/password login in this slice (role picker no longer authoritative) — **Y/N**  
3. Hydrate via views for qualifiers/risks; set_* notes RPCs **unwired** in UI — **Y/N**  
4. Honest empty until seed — **Y/N**  
5. Apply `0007` write RPCs with the wire yes (not before) — **Y/N**  
6. Widen `decision_audit_log` INSERT to `can_approve OR can_edit` so `set_risk` audits for non-admins — **Y/N** (recommended Y)
