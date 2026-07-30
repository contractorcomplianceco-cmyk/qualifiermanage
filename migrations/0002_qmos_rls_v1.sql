-- QualifierManageOS — 0002 RLS v1 (PROPOSAL — do not apply until Rose yes)
-- Pairs with tip baseline after 0001: 18ccbbe24865d28b42ec55e3a2d71773c026f380
-- Target: Supabase Postgres (cca-qualifiermanageos)
--
-- Goals:
--   1) Kill anon exposure (today anon has full DML on all 14 tables).
--   2) Staff-only access via allowlist JWT claims (v1 auth model).
--   3) decision_audit_log: staff INSERT + SELECT only; no UPDATE/DELETE via RLS
--      (append-only trigger remains the hard stop).
--   4) Narrower row rules for admin-only review rows; column redaction for
--      admin_only_notes / resolution_notes documented via views (RLS is row-level).
--
-- JWT claims the future allowlist login must set on authenticated tokens:
--   qmos_role        = Leadership | Admin | Placement Coordinator | Fulfillment | Sales Viewer
--   qmos_staff_name  = staff.name (optional; for audit actor stamping)
--
-- service_role: continues to bypass RLS (server API only — never ship to browser).
-- Until allowlist auth issues JWTs, authenticated also cannot usefully read data
-- after REVOKE + RLS (safe default).

-- ---------------------------------------------------------------------------
-- Helpers (SECURITY DEFINER not required — read JWT only)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION qmos_jwt_role()
RETURNS text
LANGUAGE sql
STABLE
AS $$
  SELECT NULLIF(auth.jwt() ->> 'qmos_role', '');
$$;

CREATE OR REPLACE FUNCTION qmos_is_staff()
RETURNS boolean
LANGUAGE sql
STABLE
AS $$
  SELECT qmos_jwt_role() IN (
    'Leadership',
    'Admin',
    'Placement Coordinator',
    'Fulfillment',
    'Sales Viewer'
  );
$$;

CREATE OR REPLACE FUNCTION qmos_can_approve()
RETURNS boolean
LANGUAGE sql
STABLE
AS $$
  -- DATA_MODEL: Leadership / Admin may approve matches & change risk status
  SELECT qmos_jwt_role() IN ('Leadership', 'Admin');
$$;

CREATE OR REPLACE FUNCTION qmos_can_edit()
RETURNS boolean
LANGUAGE sql
STABLE
AS $$
  -- Writers (not Sales Viewer)
  SELECT qmos_jwt_role() IN (
    'Leadership',
    'Admin',
    'Placement Coordinator',
    'Fulfillment'
  );
$$;

CREATE OR REPLACE FUNCTION qmos_can_see_admin_fields()
RETURNS boolean
LANGUAGE sql
STABLE
AS $$
  SELECT qmos_jwt_role() IN ('Leadership', 'Admin');
$$;

COMMENT ON FUNCTION qmos_jwt_role() IS
  'QMOS v1: role from JWT claim qmos_role (set by allowlist auth).';
COMMENT ON FUNCTION qmos_is_staff() IS
  'QMOS v1: true when JWT carries a known staff role.';
COMMENT ON FUNCTION qmos_can_approve() IS
  'QMOS v1: Leadership/Admin — match approval + risk status writes.';
COMMENT ON FUNCTION qmos_can_edit() IS
  'QMOS v1: staff except Sales Viewer — general writes.';
COMMENT ON FUNCTION qmos_can_see_admin_fields() IS
  'QMOS v1: Leadership/Admin — admin-only notes / admin-only reviews.';

-- ---------------------------------------------------------------------------
-- Lock down grants: anon gets nothing; authenticated gets table DML that RLS
-- then filters; service_role unchanged (Supabase server key).
-- ---------------------------------------------------------------------------
DO $$
DECLARE
  t text;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'staff',
    'qualifiers',
    'licenses',
    'availability',
    'documents',
    'needs',
    'matches',
    'placements',
    'reviews',
    'risks',
    'cities',
    'coverage_gaps',
    'decision_audit_log',
    'qmos_schema_migrations'
  ]
  LOOP
    EXECUTE format('REVOKE ALL ON TABLE %I FROM anon, authenticated', t);
  END LOOP;
END $$;

-- Re-grant authenticated only what policies will allow (no anon grants)
GRANT SELECT ON TABLE
  staff, qualifiers, licenses, availability, documents, needs, matches,
  placements, reviews, risks, cities, coverage_gaps, decision_audit_log
TO authenticated;

GRANT INSERT, UPDATE, DELETE ON TABLE
  staff, qualifiers, licenses, availability, documents, needs, matches,
  placements, reviews, risks, cities, coverage_gaps
TO authenticated;

-- Audit log: INSERT + SELECT only (no UPDATE/DELETE grant)
GRANT SELECT, INSERT ON TABLE decision_audit_log TO authenticated;

-- Schema journal: staff read-only (migrations applied as postgres/service_role)
GRANT SELECT ON TABLE qmos_schema_migrations TO authenticated;

-- ---------------------------------------------------------------------------
-- Enable + FORCE RLS on all 14 (FORCE closes owner bypass edge cases)
-- ---------------------------------------------------------------------------
ALTER TABLE staff ENABLE ROW LEVEL SECURITY;
ALTER TABLE staff FORCE ROW LEVEL SECURITY;
ALTER TABLE qualifiers ENABLE ROW LEVEL SECURITY;
ALTER TABLE qualifiers FORCE ROW LEVEL SECURITY;
ALTER TABLE licenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE licenses FORCE ROW LEVEL SECURITY;
ALTER TABLE availability ENABLE ROW LEVEL SECURITY;
ALTER TABLE availability FORCE ROW LEVEL SECURITY;
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE documents FORCE ROW LEVEL SECURITY;
ALTER TABLE needs ENABLE ROW LEVEL SECURITY;
ALTER TABLE needs FORCE ROW LEVEL SECURITY;
ALTER TABLE matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE matches FORCE ROW LEVEL SECURITY;
ALTER TABLE placements ENABLE ROW LEVEL SECURITY;
ALTER TABLE placements FORCE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews FORCE ROW LEVEL SECURITY;
ALTER TABLE risks ENABLE ROW LEVEL SECURITY;
ALTER TABLE risks FORCE ROW LEVEL SECURITY;
ALTER TABLE cities ENABLE ROW LEVEL SECURITY;
ALTER TABLE cities FORCE ROW LEVEL SECURITY;
ALTER TABLE coverage_gaps ENABLE ROW LEVEL SECURITY;
ALTER TABLE coverage_gaps FORCE ROW LEVEL SECURITY;
ALTER TABLE decision_audit_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE decision_audit_log FORCE ROW LEVEL SECURITY;
ALTER TABLE qmos_schema_migrations ENABLE ROW LEVEL SECURITY;
ALTER TABLE qmos_schema_migrations FORCE ROW LEVEL SECURITY;

-- ---------------------------------------------------------------------------
-- Policies — drop if re-runnable in staging
-- ---------------------------------------------------------------------------
-- staff
DROP POLICY IF EXISTS qmos_staff_select ON staff;
DROP POLICY IF EXISTS qmos_staff_write ON staff;
CREATE POLICY qmos_staff_select ON staff
  FOR SELECT TO authenticated
  USING (qmos_is_staff());
CREATE POLICY qmos_staff_write ON staff
  FOR ALL TO authenticated
  USING (qmos_can_approve())
  WITH CHECK (qmos_can_approve());

-- qualifiers (row access: all staff SELECT; writers edit; Sales Viewer no write)
DROP POLICY IF EXISTS qmos_qualifiers_select ON qualifiers;
DROP POLICY IF EXISTS qmos_qualifiers_write ON qualifiers;
CREATE POLICY qmos_qualifiers_select ON qualifiers
  FOR SELECT TO authenticated
  USING (qmos_is_staff());
CREATE POLICY qmos_qualifiers_write ON qualifiers
  FOR ALL TO authenticated
  USING (qmos_can_edit())
  WITH CHECK (qmos_can_edit());
-- NOTE: admin_only_notes is COLUMN-sensitive. RLS cannot hide columns.
-- See view v_qualifiers_for_role below for Sales Viewer-safe projection.

-- licenses
DROP POLICY IF EXISTS qmos_licenses_select ON licenses;
DROP POLICY IF EXISTS qmos_licenses_write ON licenses;
CREATE POLICY qmos_licenses_select ON licenses
  FOR SELECT TO authenticated
  USING (qmos_is_staff());
CREATE POLICY qmos_licenses_write ON licenses
  FOR ALL TO authenticated
  USING (qmos_can_edit())
  WITH CHECK (qmos_can_edit());

-- availability
DROP POLICY IF EXISTS qmos_availability_select ON availability;
DROP POLICY IF EXISTS qmos_availability_write ON availability;
CREATE POLICY qmos_availability_select ON availability
  FOR SELECT TO authenticated
  USING (qmos_is_staff());
CREATE POLICY qmos_availability_write ON availability
  FOR ALL TO authenticated
  USING (qmos_can_edit())
  WITH CHECK (qmos_can_edit());

-- documents
DROP POLICY IF EXISTS qmos_documents_select ON documents;
DROP POLICY IF EXISTS qmos_documents_write ON documents;
CREATE POLICY qmos_documents_select ON documents
  FOR SELECT TO authenticated
  USING (qmos_is_staff());
CREATE POLICY qmos_documents_write ON documents
  FOR ALL TO authenticated
  USING (qmos_can_edit())
  WITH CHECK (qmos_can_edit());

-- needs
DROP POLICY IF EXISTS qmos_needs_select ON needs;
DROP POLICY IF EXISTS qmos_needs_write ON needs;
CREATE POLICY qmos_needs_select ON needs
  FOR SELECT TO authenticated
  USING (qmos_is_staff());
CREATE POLICY qmos_needs_write ON needs
  FOR ALL TO authenticated
  USING (qmos_can_edit())
  WITH CHECK (qmos_can_edit());

-- matches: all staff read; only Leadership/Admin update approval fields path
-- (writers who are coordinators may INSERT suggested matches; approval = can_approve)
DROP POLICY IF EXISTS qmos_matches_select ON matches;
DROP POLICY IF EXISTS qmos_matches_insert ON matches;
DROP POLICY IF EXISTS qmos_matches_update ON matches;
DROP POLICY IF EXISTS qmos_matches_delete ON matches;
CREATE POLICY qmos_matches_select ON matches
  FOR SELECT TO authenticated
  USING (qmos_is_staff());
CREATE POLICY qmos_matches_insert ON matches
  FOR INSERT TO authenticated
  WITH CHECK (qmos_can_edit());
CREATE POLICY qmos_matches_update ON matches
  FOR UPDATE TO authenticated
  USING (qmos_can_approve())
  WITH CHECK (qmos_can_approve());
CREATE POLICY qmos_matches_delete ON matches
  FOR DELETE TO authenticated
  USING (qmos_can_approve());

-- placements
DROP POLICY IF EXISTS qmos_placements_select ON placements;
DROP POLICY IF EXISTS qmos_placements_write ON placements;
CREATE POLICY qmos_placements_select ON placements
  FOR SELECT TO authenticated
  USING (qmos_is_staff());
CREATE POLICY qmos_placements_write ON placements
  FOR ALL TO authenticated
  USING (qmos_can_edit())
  WITH CHECK (qmos_can_edit());

-- reviews: Sales Viewer / non-admin cannot see admin_only = true rows
DROP POLICY IF EXISTS qmos_reviews_select ON reviews;
DROP POLICY IF EXISTS qmos_reviews_write ON reviews;
CREATE POLICY qmos_reviews_select ON reviews
  FOR SELECT TO authenticated
  USING (
    qmos_is_staff()
    AND (admin_only = false OR qmos_can_see_admin_fields())
  );
CREATE POLICY qmos_reviews_write ON reviews
  FOR ALL TO authenticated
  USING (qmos_can_edit())
  WITH CHECK (qmos_can_edit());

-- risks: all staff read rows; status writes = can_approve; general edits = can_edit
DROP POLICY IF EXISTS qmos_risks_select ON risks;
DROP POLICY IF EXISTS qmos_risks_insert ON risks;
DROP POLICY IF EXISTS qmos_risks_update ON risks;
DROP POLICY IF EXISTS qmos_risks_delete ON risks;
CREATE POLICY qmos_risks_select ON risks
  FOR SELECT TO authenticated
  USING (qmos_is_staff());
CREATE POLICY qmos_risks_insert ON risks
  FOR INSERT TO authenticated
  WITH CHECK (qmos_can_edit());
CREATE POLICY qmos_risks_update ON risks
  FOR UPDATE TO authenticated
  USING (qmos_can_approve() OR qmos_can_edit())
  WITH CHECK (qmos_can_approve() OR qmos_can_edit());
CREATE POLICY qmos_risks_delete ON risks
  FOR DELETE TO authenticated
  USING (qmos_can_approve());
-- NOTE: resolution_notes column redaction → view below (RLS cannot hide columns).

-- cities / coverage_gaps (map helpers)
DROP POLICY IF EXISTS qmos_cities_select ON cities;
DROP POLICY IF EXISTS qmos_cities_write ON cities;
CREATE POLICY qmos_cities_select ON cities
  FOR SELECT TO authenticated
  USING (qmos_is_staff());
CREATE POLICY qmos_cities_write ON cities
  FOR ALL TO authenticated
  USING (qmos_can_edit())
  WITH CHECK (qmos_can_edit());

DROP POLICY IF EXISTS qmos_coverage_gaps_select ON coverage_gaps;
DROP POLICY IF EXISTS qmos_coverage_gaps_write ON coverage_gaps;
CREATE POLICY qmos_coverage_gaps_select ON coverage_gaps
  FOR SELECT TO authenticated
  USING (qmos_is_staff());
CREATE POLICY qmos_coverage_gaps_write ON coverage_gaps
  FOR ALL TO authenticated
  USING (qmos_can_edit())
  WITH CHECK (qmos_can_edit());

-- decision_audit_log: INSERT + SELECT for staff; no UPDATE/DELETE policies
DROP POLICY IF EXISTS qmos_audit_select ON decision_audit_log;
DROP POLICY IF EXISTS qmos_audit_insert ON decision_audit_log;
CREATE POLICY qmos_audit_select ON decision_audit_log
  FOR SELECT TO authenticated
  USING (qmos_is_staff());
CREATE POLICY qmos_audit_insert ON decision_audit_log
  FOR INSERT TO authenticated
  WITH CHECK (qmos_is_staff());
-- Intentionally no UPDATE/DELETE policies (+ no GRANTs) + existing append trigger

-- qmos_schema_migrations: SELECT for staff only
DROP POLICY IF EXISTS qmos_migrations_select ON qmos_schema_migrations;
CREATE POLICY qmos_migrations_select ON qmos_schema_migrations
  FOR SELECT TO authenticated
  USING (qmos_is_staff());

-- ---------------------------------------------------------------------------
-- Column-sensitivity views (Sales Viewer / non-admin safe projections)
-- API should prefer these when qmos_role = 'Sales Viewer'
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_qualifiers_public_fields
WITH (security_invoker = true)
AS
SELECT
  id, full_name, preferred_name, email, phone, city, state_of_residence, timezone,
  status, verification_status, background_check_status, credit_check_status,
  available_for_placement, preferred_placement_types, minimum_monthly_compensation,
  open_to_negotiation, internal_owner, last_reviewed_date, next_review_due,
  -- admin_only_notes omitted
  readiness_score, auditengine_id, created_at, updated_at,
  CASE WHEN qmos_can_see_admin_fields() THEN admin_only_notes ELSE NULL END AS admin_only_notes
FROM qualifiers;

CREATE OR REPLACE VIEW v_risks_public_fields
WITH (security_invoker = true)
AS
SELECT
  id, related_qualifier_id, related_placement_need_id, related_active_placement_id,
  risk_type, risk_level, risk_status, owner, due_date,
  CASE WHEN qmos_can_see_admin_fields() THEN resolution_notes ELSE NULL END AS resolution_notes,
  auditengine_id, created_at, updated_at
FROM risks;

GRANT SELECT ON v_qualifiers_public_fields TO authenticated;
GRANT SELECT ON v_risks_public_fields TO authenticated;

-- ---------------------------------------------------------------------------
-- Journal
-- ---------------------------------------------------------------------------
INSERT INTO qmos_schema_migrations (id, notes)
VALUES (
  '0002_qmos_rls_v1',
  'RLS v1: REVOKE anon; FORCE RLS on 14 tables; staff JWT claim policies; audit INSERT/SELECT only; admin-field views'
)
ON CONFLICT (id) DO NOTHING;
