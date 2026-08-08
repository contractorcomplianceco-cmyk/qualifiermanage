# QualifierManageOS — migrations

**Audience:** `[INTERNAL ONLY]`  
**DB home:** Supabase project `cca-qualifiermanageos` (separate from ComplianceConnect)  
**Live journal tip:** `0012_seed_bulk_v1` (applied 2026-08-01)  
**Branch tip for this folder:** see PR #1 / `fixes/p0-p1-cleanup`

## Files

| File | Purpose | Live status |
|---|---|---|
| `0001_qmos_schema_v1.sql` | Schema v1 — core tables + Option A `auditengine_id` + append-only `decision_audit_log` | **Applied** |
| `0002_qmos_rls_v1.sql` | RLS v1 — revoke anon, FORCE RLS, staff JWT policies | **Applied** |
| `RLS_V1_PROPOSAL.md` | Human-readable RLS matrix (historical proposal; now applied) | Applied |
| `0003_rls_grant_hygiene.sql` | Post-0002 grant hygiene | **Applied** |
| `0004_p0_admin_rpc_anon_execute.sql` | P0 — revoke anon EXECUTE on admin DEFINER RPCs; fail-closed guards | **Applied** |
| `AUTH_ALLOWLIST_V1_PROPOSAL.md` | Staff allowlist auth proposal (historical; now applied) | Applied |
| `0005_staff_allowlist_auth_v1.sql` | Staff allowlist + Custom Access Token hook | **Applied** |
| `0006_allowlist_hook_force_rls_fix.sql` | Hotfix — auth_admin staff policies + VOLATILE hook | **Applied** |
| `API_V1_PROPOSAL.md` | Read/write API proposal (historical; wired) | Applied / wired |
| `AUTH_PROVISIONING.md` | How staff Auth accounts are created (service_role / Dashboard; signup off) | Live process |
| `0007_api_write_rpcs_v1.sql` | API write RPCs (`approve_match` / `set_risk` + audit INSERT widen) | **Applied** |
| `0008_view_staff_filter.sql` | DEFINER views: `WHERE qmos_is_staff()` | **Applied** |
| `SEED_V1_PROPOSAL.md` | Base seed proposal | Applied |
| `0009_seed_base_v1.sql` | Base seed from `data.base.js` | **Applied** |
| `0010_set_risk_return_jsonb.sql` | Hotfix: set_risk returns jsonb without resolution_notes | **Applied** |
| `0011_set_risk_no_returning_star.sql` | Hotfix: set_risk RETURNING only granted columns | **Applied** |
| `SEED_BULK_V1_PROPOSAL.md` | Bulk volume seed proposal | Applied |
| `0012_seed_bulk_v1.sql` | Bulk seed from data.js | **Applied** |
| `SYNC_INTEGRATIONS_V1_PROPOSAL.md` | Sync integrations — systems / direction / triggers | Proposal; **Slice A approved to author** (2026-08-07) |
| `0013_qualifier_profile_alignment_v1.sql.PROPOSED` | Profile field safe-subset (issue #4) | **PROPOSED — not applied** |
| `0014_integration_events_slice_a_v1.sql.PROPOSED` | Slice A `integration_events` append-only (issue #3) | **PROPOSED — not applied** |

## Held (need separate Rose yes)

- Apply of `0013` / `0014` (shape yes + separate apply yes)
- Sync Slice B (gated on ID-001) / seams ON
- Client / partner share / public go-live (approval lanes still blank = NO)
- Staff deploy push-yes (`scripts/deploy-internal.sh` still idle)

## Rules

- Append-only migrations. Never edit an applied `000N_…` file’s logic in place; add `000N+1_…`.
- No secrets in this folder (names only).
- `DATA_MODEL.md` Option A (`auditengine_id`) is no-touch — do not relitigate shape without Rose yes.
