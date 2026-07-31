# QualifierManageOS — migrations

**Audience:** `[INTERNAL ONLY]`  
**DB home (Rose 2026-07-29):** Supabase  
**SoT tip at Schema v1 draft:** `acd552971b63b558d56536c80c4433bcd9f1165a` (+ this migrations commit when Rose approves push)

## Files

| File | Purpose |
|---|---|
| `0001_qmos_schema_v1.sql` | Schema v1 — core tables + Option A `auditengine_id` + append-only `decision_audit_log` |
| `0002_qmos_rls_v1.sql` | RLS v1 — **proposal / not applied until Rose yes** — revoke anon, FORCE RLS, staff JWT policies |
| `RLS_V1_PROPOSAL.md` | Human-readable matrix + decisions for Rose review |
| `0003_rls_grant_hygiene.sql` | Post-0002 grant hygiene (anon zero; column INSERT/UPDATE; views SELECT-only) |
| `0004_p0_admin_rpc_anon_execute.sql` | **P0** — revoke anon EXECUTE on admin DEFINER RPCs; fail-closed guards |
| `AUTH_ALLOWLIST_V1_PROPOSAL.md` | Staff allowlist auth v1 — human proposal for Rose (shape review) |
| `0005_staff_allowlist_auth_v1.sql` | Staff allowlist auth v1 — **proposal / not applied until Rose yes** |
| `0006_allowlist_hook_force_rls_fix.sql` | Hotfix after 0005 apply — auth_admin staff policies + VOLATILE hook |
| `API_V1_PROPOSAL.md` | Read/write API v1 — human proposal for Rose (shape review) |
| `AUTH_PROVISIONING.md` | How staff Auth accounts are created (service_role / Dashboard; signup off) |
| `0007_api_write_rpcs_v1.sql` | API write RPCs (approve_match / set_risk + audit INSERT widen) |
| `0008_view_staff_filter.sql` | DEFINER views: WHERE qmos_is_staff() for non-allowlisted empty |
| `SEED_V1_PROPOSAL.md` | Base seed v1 — human proposal for Rose (shape review) |
| `0009_seed_base_v1.sql` | Base seed from `data.base.js` (applied) |
| `0010_set_risk_return_jsonb.sql` | Hotfix: set_risk returns jsonb without resolution_notes |
| `0011_set_risk_no_returning_star.sql` | Hotfix: set_risk RETURNING only granted columns |

## Apply (when Rose says yes — env NAMES only)

1. Create a dedicated Supabase project for QualifierManageOS (do not reuse ComplianceConnect prod DB).
2. Set host secrets via Supabase dashboard / vault — never commit values:
   - `DATABASE_URL` / pooler URL
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_ROLE_KEY` (server only)
3. Apply `0001_qmos_schema_v1.sql` via Supabase SQL editor **or** `supabase db push` / `psql "$DATABASE_URL" -f migrations/0001_qmos_schema_v1.sql`.
4. Confirm journal row: `SELECT * FROM qmos_schema_migrations WHERE id = '0001_qmos_schema_v1';`

## Out of scope for 0001 (next slices — need Rose yes)

- RLS policies → see `0002_qmos_rls_v1.sql` + `RLS_V1_PROPOSAL.md` (propose first; apply only after separate yes)
- Staff email/password allowlist auth → see `0005_staff_allowlist_auth_v1.sql` + `AUTH_ALLOWLIST_V1_PROPOSAL.md` (propose first; apply only after separate yes)
- Read/write API replacing `import('./data.js')` → see `API_V1_PROPOSAL.md` + `0007_api_write_rpcs_v1.sql` (propose first; apply/wire only after separate yes)
- Seed load / retiring `data.bulk.js` → see `SEED_V1_PROPOSAL.md` + `0009_seed_base_v1.sql` (base-only first; bulk follow-on)
- AuditEngine / DocumentCollection sync seams (stay OFF)

## Rules

- Append-only migrations. Never edit `0001_…` after it has been applied anywhere; add `0002_…`.
- No secrets in this folder.
- `DATA_MODEL.md` §6 Option A is no-touch — do not relitigate `auditengine_id` shape without Rose yes.
