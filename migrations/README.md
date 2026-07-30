# QualifierManageOS — migrations

**Audience:** `[INTERNAL ONLY]`  
**DB home (Rose 2026-07-29):** Supabase  
**SoT tip at Schema v1 draft:** `acd552971b63b558d56536c80c4433bcd9f1165a` (+ this migrations commit when Rose approves push)

## Files

| File | Purpose |
|---|---|
| `0001_qmos_schema_v1.sql` | Schema v1 — core tables + Option A `auditengine_id` + append-only `decision_audit_log` |

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

- RLS policies
- Staff email/password allowlist auth tables + invite flow
- Read/write API replacing `import('./data.js')`
- Seed load / retiring `data.bulk.js`
- AuditEngine / DocumentCollection sync seams (stay OFF)
- DNS / `qualifiers.cagteam.net`

## Rules

- Append-only migrations. Never edit `0001_…` after it has been applied anywhere; add `0002_…`.
- No secrets in this folder.
- `DATA_MODEL.md` §6 Option A is no-touch — do not relitigate `auditengine_id` shape without Rose yes.
