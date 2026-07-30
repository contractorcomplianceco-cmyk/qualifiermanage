# QualifierManageOS — RLS v1 proposal (0002)

**Status:** PROPOSAL ONLY — not applied  
**Audience:** `[INTERNAL ONLY]`  
**SoT tip at draft:** `18ccbbe24865d28b42ec55e3a2d71773c026f380`  
**Migration file:** `migrations/0002_qmos_rls_v1.sql`  
**Auth model:** v1 simple allowlist → authenticated JWT claims `qmos_role` + optional `qmos_staff_name`  
**Hard rule:** **no anon access** to any of the 14 tables

## Why this is urgent

Live grants today give **anon** full SELECT/INSERT/UPDATE/DELETE/TRUNCATE on all 14 tables. RLS is off. Any leak of the anon key = full table access. This migration REVOKEs anon and FORCE-enables RLS.

## Role matrix (DATA_MODEL staff roles)

| Role | SELECT (ops data) | INSERT/UPDATE general | Match approve / risk status | See admin-only fields |
|---|---|---|---|---|
| Leadership | Y | Y | Y | Y |
| Admin | Y | Y | Y | Y |
| Placement Coordinator | Y | Y | N (approve) | N |
| Fulfillment | Y | Y | N (approve) | N |
| Sales Viewer | Y | N | N | N |
| anon | **N** | **N** | **N** | **N** |
| service_role (server API) | bypasses RLS | bypasses RLS | app-enforced | app-enforced |

Helpers in SQL: `qmos_is_staff()`, `qmos_can_edit()`, `qmos_can_approve()`, `qmos_can_see_admin_fields()`.

## Per-table privileges (authenticated + RLS)

| Table | SELECT | INSERT | UPDATE | DELETE | Notes |
|---|---|---|---|---|---|
| `staff` | staff | Admin/Leadership | Admin/Leadership | Admin/Leadership | Directory |
| `qualifiers` | staff | editors | editors | editors | `admin_only_notes` → view (see below) |
| `licenses` | staff | editors | editors | editors | |
| `availability` | staff | editors | editors | editors | |
| `documents` | staff | editors | editors | editors | |
| `needs` | staff | editors | editors | editors | |
| `matches` | staff | editors | **approve only** | **approve only** | Human decision path |
| `placements` | staff | editors | editors | editors | |
| `reviews` | staff, but `admin_only=true` rows → Admin/Leadership only | editors | editors | editors | Narrower row policy |
| `risks` | staff | editors | editors or approvers | approvers | `resolution_notes` → view |
| `cities` | staff | editors | editors | editors | Map helper |
| `coverage_gaps` | staff | editors | editors | editors | Map helper |
| `decision_audit_log` | staff | **staff INSERT** | **none** | **none** | Trigger still blocks UPDATE/DELETE |
| `qmos_schema_migrations` | staff | none | none | none | Apply as postgres/service_role only |

editors = Leadership / Admin / Placement Coordinator / Fulfillment  
approve = Leadership / Admin  

## Narrower than “any staff row”

1. **`reviews.admin_only = true`** — SELECT policy requires `qmos_can_see_admin_fields()` (Admin/Leadership). Sales Viewer / coordinators do not see those rows.
2. **`qualifiers.admin_only_notes`** and **`risks.resolution_notes`** — RLS cannot hide columns. Proposal adds views:
   - `v_qualifiers_public_fields` — nulls `admin_only_notes` unless Admin/Leadership
   - `v_risks_public_fields` — nulls `resolution_notes` unless Admin/Leadership  
   API for Sales Viewer should read these views (or strip in app when using `service_role`).
3. **`matches` approval** — UPDATE/DELETE restricted to Admin/Leadership (not all editors).

## `decision_audit_log`

- GRANT: SELECT + INSERT only (no UPDATE/DELETE grant)
- RLS: SELECT if staff; INSERT if staff; **no** UPDATE/DELETE policies
- Existing `decision_audit_log_no_update` trigger remains the hard append-only stop
- Recommended writers: same actors as `approveMatch` / `setRisk` (Admin/Leadership); INSERT allowed for any staff so coordinators can log deferred actions later if needed — **ask Rose if INSERT should be `qmos_can_approve()` only**

## service_role / API note

Supabase `service_role` **bypasses RLS**. v1 server API (when built) must:
1. Never expose `SUPABASE_SERVICE_ROLE_KEY` or anon key to the browser
2. Enforce the same role matrix in application code when using service_role
3. Prefer user JWT + `authenticated` for PostgREST paths once allowlist auth issues claims

## Out of scope (still need separate Rose yes)

- Creating `staff_users` / invite / password tables
- Issuing JWTs with `qmos_role`
- Applying this migration to live Supabase
- Read API / seed / sync seams

## Apply gate

1. Rose yes on this proposal / SQL shape  
2. Separate Rose yes to **apply** `0002_qmos_rls_v1.sql`  
3. Confirm: anon grants gone · `relrowsecurity` true on 14 · journal row `0002_qmos_rls_v1`
