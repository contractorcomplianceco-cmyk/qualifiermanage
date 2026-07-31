-- QualifierManageOS — 0008 View staff filter (API wire companion)
-- Why: v_qualifiers_public_fields / v_risks_public_fields are security_invoker=false
--   (needed to read admin note columns). Without a row filter, any Auth user with
--   GRANT SELECT on the view could read all non-note columns even when JWT has no
--   qmos_role. Add WHERE qmos_is_staff() so non-allowlisted → empty (like base RLS).
-- Applied with API v1 wire (Rose apply+wire yes on 0007); required for honest empty / no-leak.

CREATE OR REPLACE VIEW v_qualifiers_public_fields
AS
SELECT
  id, full_name, preferred_name, email, phone, city, state_of_residence, timezone,
  status, verification_status, background_check_status, credit_check_status,
  available_for_placement, preferred_placement_types, minimum_monthly_compensation,
  open_to_negotiation, internal_owner, last_reviewed_date, next_review_due,
  readiness_score, auditengine_id, created_at, updated_at,
  CASE WHEN qmos_can_see_admin_fields() THEN admin_only_notes ELSE NULL END AS admin_only_notes
FROM qualifiers
WHERE qmos_is_staff();

CREATE OR REPLACE VIEW v_risks_public_fields
AS
SELECT
  id, related_qualifier_id, related_placement_need_id, related_active_placement_id,
  risk_type, risk_level, risk_status, owner, due_date,
  CASE WHEN qmos_can_see_admin_fields() THEN resolution_notes ELSE NULL END AS resolution_notes,
  auditengine_id, created_at, updated_at
FROM risks
WHERE qmos_is_staff();

ALTER VIEW v_qualifiers_public_fields SET (security_invoker = false);
ALTER VIEW v_risks_public_fields SET (security_invoker = false);

GRANT SELECT ON v_qualifiers_public_fields TO authenticated;
GRANT SELECT ON v_risks_public_fields TO authenticated;

INSERT INTO qmos_schema_migrations (id, notes)
VALUES (
  '0008_view_staff_filter',
  'DEFINER admin views: WHERE qmos_is_staff() so non-allowlisted authenticated get empty rows'
)
ON CONFLICT (id) DO NOTHING;
