-- QualifierManageOS — 0003 RLS grant hygiene
-- Applied live immediately after 0002 (2026-07-30) to match approved intent:
--   * anon has zero grants (including views created mid-0002)
--   * qualifiers/risks INSERT/UPDATE are column-lists omitting sensitive cols
--   * admin views are SELECT-only for authenticated
-- Safe to run after 0002; idempotent REVOKE/GRANT pattern.

REVOKE ALL ON TABLE v_qualifiers_public_fields, v_risks_public_fields FROM anon, authenticated;
GRANT SELECT ON TABLE v_qualifiers_public_fields, v_risks_public_fields TO authenticated;

REVOKE INSERT, UPDATE ON TABLE qualifiers FROM authenticated;
REVOKE INSERT, UPDATE ON TABLE risks FROM authenticated;

GRANT INSERT (
  id, full_name, preferred_name, email, phone, city, state_of_residence, timezone,
  status, verification_status, background_check_status, credit_check_status,
  available_for_placement, preferred_placement_types, minimum_monthly_compensation,
  open_to_negotiation, internal_owner, last_reviewed_date, next_review_due,
  readiness_score, auditengine_id, created_at, updated_at
) ON qualifiers TO authenticated;

GRANT UPDATE (
  full_name, preferred_name, email, phone, city, state_of_residence, timezone,
  status, verification_status, background_check_status, credit_check_status,
  available_for_placement, preferred_placement_types, minimum_monthly_compensation,
  open_to_negotiation, internal_owner, last_reviewed_date, next_review_due,
  readiness_score, auditengine_id, updated_at
) ON qualifiers TO authenticated;

GRANT INSERT (
  id, related_qualifier_id, related_placement_need_id, related_active_placement_id,
  risk_type, risk_level, risk_status, owner, due_date,
  auditengine_id, created_at, updated_at
) ON risks TO authenticated;

GRANT UPDATE (
  related_qualifier_id, related_placement_need_id, related_active_placement_id,
  risk_type, risk_level, risk_status, owner, due_date,
  auditengine_id, updated_at
) ON risks TO authenticated;

GRANT DELETE ON TABLE qualifiers, risks TO authenticated;

INSERT INTO qmos_schema_migrations (id, notes)
VALUES (
  '0003_rls_grant_hygiene',
  'Post-0002 grant hygiene: anon zero grants; column-level INSERT/UPDATE omit admin notes; admin views SELECT-only'
)
ON CONFLICT (id) DO NOTHING;
