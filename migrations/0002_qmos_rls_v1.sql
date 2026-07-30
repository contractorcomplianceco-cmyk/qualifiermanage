-- QualifierManageOS — 0002 RLS v1 (PROPOSAL — do not apply until Rose yes)
-- Tip at this revision: pushed after Rose gap-fix feedback (admin columns + reviews write + audit INSERT)
-- Target: Supabase Postgres (cca-qualifiermanageos)
--
-- Goals:
--   1) Kill anon exposure (REVOKE ALL from anon).
--   2) Staff-only via allowlist JWT claims qmos_role / qmos_staff_name.
--   3) decision_audit_log: Admin/Leadership INSERT + staff SELECT; no UPDATE/DELETE
--      (append-only trigger remains the hard stop).
--   4) admin_only_notes / resolution_notes: NOT granted on base tables to authenticated.
--      Non-admins cannot SELECT those columns. Admins read/write via SECURITY DEFINER
--      RPCs + security_barrier views (views are not merely "recommended").
--   5) reviews write: same admin_only gate as SELECT (no blind UPDATE of hidden rows).
--
-- service_role bypasses RLS (server API only — never ship to browser).

-- ---------------------------------------------------------------------------
-- Helpers
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
  SELECT qmos_jwt_role() IN ('Leadership', 'Admin');
$$;

CREATE OR REPLACE FUNCTION qmos_can_edit()
RETURNS boolean
LANGUAGE sql
STABLE
AS $$
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
  'QMOS v1: Leadership/Admin — match approval, risk status, audit INSERT.';
COMMENT ON FUNCTION qmos_can_edit() IS
  'QMOS v1: staff except Sales Viewer — general writes.';
COMMENT ON FUNCTION qmos_can_see_admin_fields() IS
  'QMOS v1: Leadership/Admin — admin-only notes / admin-only reviews.';

-- ---------------------------------------------------------------------------
-- Lock down grants
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

-- Full-table SELECT where no sensitive columns
GRANT SELECT ON TABLE
  staff, licenses, availability, documents, needs, matches,
  placements, reviews, cities, coverage_gaps, decision_audit_log,
  qmos_schema_migrations
TO authenticated;

-- qualifiers / risks: column-level SELECT — sensitive columns NOT granted
GRANT SELECT (
  id, full_name, preferred_name, email, phone, city, state_of_residence, timezone,
  status, verification_status, background_check_status, credit_check_status,
  available_for_placement, preferred_placement_types, minimum_monthly_compensation,
  open_to_negotiation, internal_owner, last_reviewed_date, next_review_due,
  readiness_score, auditengine_id, created_at, updated_at
) ON qualifiers TO authenticated;
-- admin_only_notes intentionally omitted from GRANT SELECT

GRANT SELECT (
  id, related_qualifier_id, related_placement_need_id, related_active_placement_id,
  risk_type, risk_level, risk_status, owner, due_date,
  auditengine_id, created_at, updated_at
) ON risks TO authenticated;
-- resolution_notes intentionally omitted from GRANT SELECT

-- Writes (table-level); sensitive columns revoked from INSERT/UPDATE below
GRANT INSERT, UPDATE, DELETE ON TABLE
  staff, licenses, availability, documents, needs, matches,
  placements, reviews, cities, coverage_gaps
TO authenticated;

GRANT INSERT, UPDATE, DELETE ON TABLE qualifiers TO authenticated;
GRANT INSERT, UPDATE, DELETE ON TABLE risks TO authenticated;

-- Strip sensitive columns from INSERT/UPDATE for authenticated (all JWT roles share this DB role)
REVOKE INSERT (admin_only_notes) ON qualifiers FROM authenticated;
REVOKE UPDATE (admin_only_notes) ON qualifiers FROM authenticated;
REVOKE INSERT (resolution_notes) ON risks FROM authenticated;
REVOKE UPDATE (resolution_notes) ON risks FROM authenticated;

-- Audit log: SELECT for staff; INSERT only via policy for Admin/Leadership (grant INSERT required for policy)
GRANT SELECT, INSERT ON TABLE decision_audit_log TO authenticated;
-- no UPDATE/DELETE grant

-- ---------------------------------------------------------------------------
-- Enable + FORCE RLS on all 14
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
-- Policies
-- ---------------------------------------------------------------------------
DROP POLICY IF EXISTS qmos_staff_select ON staff;
DROP POLICY IF EXISTS qmos_staff_write ON staff;
CREATE POLICY qmos_staff_select ON staff
  FOR SELECT TO authenticated
  USING (qmos_is_staff());
CREATE POLICY qmos_staff_write ON staff
  FOR ALL TO authenticated
  USING (qmos_can_approve())
  WITH CHECK (qmos_can_approve());

DROP POLICY IF EXISTS qmos_qualifiers_select ON qualifiers;
DROP POLICY IF EXISTS qmos_qualifiers_insert ON qualifiers;
DROP POLICY IF EXISTS qmos_qualifiers_update ON qualifiers;
DROP POLICY IF EXISTS qmos_qualifiers_delete ON qualifiers;
DROP POLICY IF EXISTS qmos_qualifiers_write ON qualifiers;
CREATE POLICY qmos_qualifiers_select ON qualifiers
  FOR SELECT TO authenticated
  USING (qmos_is_staff());
CREATE POLICY qmos_qualifiers_insert ON qualifiers
  FOR INSERT TO authenticated
  WITH CHECK (qmos_can_edit());
CREATE POLICY qmos_qualifiers_update ON qualifiers
  FOR UPDATE TO authenticated
  USING (qmos_can_edit())
  WITH CHECK (qmos_can_edit());
CREATE POLICY qmos_qualifiers_delete ON qualifiers
  FOR DELETE TO authenticated
  USING (qmos_can_edit());

DROP POLICY IF EXISTS qmos_licenses_select ON licenses;
DROP POLICY IF EXISTS qmos_licenses_write ON licenses;
CREATE POLICY qmos_licenses_select ON licenses
  FOR SELECT TO authenticated
  USING (qmos_is_staff());
CREATE POLICY qmos_licenses_write ON licenses
  FOR ALL TO authenticated
  USING (qmos_can_edit())
  WITH CHECK (qmos_can_edit());

DROP POLICY IF EXISTS qmos_availability_select ON availability;
DROP POLICY IF EXISTS qmos_availability_write ON availability;
CREATE POLICY qmos_availability_select ON availability
  FOR SELECT TO authenticated
  USING (qmos_is_staff());
CREATE POLICY qmos_availability_write ON availability
  FOR ALL TO authenticated
  USING (qmos_can_edit())
  WITH CHECK (qmos_can_edit());

DROP POLICY IF EXISTS qmos_documents_select ON documents;
DROP POLICY IF EXISTS qmos_documents_write ON documents;
CREATE POLICY qmos_documents_select ON documents
  FOR SELECT TO authenticated
  USING (qmos_is_staff());
CREATE POLICY qmos_documents_write ON documents
  FOR ALL TO authenticated
  USING (qmos_can_edit())
  WITH CHECK (qmos_can_edit());

DROP POLICY IF EXISTS qmos_needs_select ON needs;
DROP POLICY IF EXISTS qmos_needs_write ON needs;
CREATE POLICY qmos_needs_select ON needs
  FOR SELECT TO authenticated
  USING (qmos_is_staff());
CREATE POLICY qmos_needs_write ON needs
  FOR ALL TO authenticated
  USING (qmos_can_edit())
  WITH CHECK (qmos_can_edit());

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

DROP POLICY IF EXISTS qmos_placements_select ON placements;
DROP POLICY IF EXISTS qmos_placements_write ON placements;
CREATE POLICY qmos_placements_select ON placements
  FOR SELECT TO authenticated
  USING (qmos_is_staff());
CREATE POLICY qmos_placements_write ON placements
  FOR ALL TO authenticated
  USING (qmos_can_edit())
  WITH CHECK (qmos_can_edit());

-- reviews: SELECT + WRITE both gate admin_only rows
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
  USING (
    qmos_can_edit()
    AND (admin_only = false OR qmos_can_see_admin_fields())
  )
  WITH CHECK (
    qmos_can_edit()
    AND (admin_only = false OR qmos_can_see_admin_fields())
  );

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

-- decision_audit_log: SELECT staff; INSERT Admin/Leadership only; no UPDATE/DELETE
DROP POLICY IF EXISTS qmos_audit_select ON decision_audit_log;
DROP POLICY IF EXISTS qmos_audit_insert ON decision_audit_log;
CREATE POLICY qmos_audit_select ON decision_audit_log
  FOR SELECT TO authenticated
  USING (qmos_is_staff());
CREATE POLICY qmos_audit_insert ON decision_audit_log
  FOR INSERT TO authenticated
  WITH CHECK (qmos_can_approve());

DROP POLICY IF EXISTS qmos_migrations_select ON qmos_schema_migrations;
CREATE POLICY qmos_migrations_select ON qmos_schema_migrations
  FOR SELECT TO authenticated
  USING (qmos_is_staff());

-- ---------------------------------------------------------------------------
-- Admin-field access: SECURITY DEFINER RPCs (only path to read/write
-- admin_only_notes / resolution_notes for authenticated)
-- Owner = migration role (table owner); runs with owner rights to touch columns
-- that authenticated cannot GRANT-select.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION qmos_get_qualifier_admin_notes(p_id text)
RETURNS text
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT qmos_can_see_admin_fields() THEN
    RAISE EXCEPTION 'forbidden: admin_only_notes requires Leadership/Admin';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM qualifiers q WHERE q.id = p_id) THEN
    RETURN NULL;
  END IF;
  RETURN (SELECT q.admin_only_notes FROM qualifiers q WHERE q.id = p_id);
END;
$$;

CREATE OR REPLACE FUNCTION qmos_set_qualifier_admin_notes(p_id text, p_notes text)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT qmos_can_see_admin_fields() THEN
    RAISE EXCEPTION 'forbidden: admin_only_notes requires Leadership/Admin';
  END IF;
  UPDATE qualifiers
     SET admin_only_notes = p_notes,
         updated_at = now()
   WHERE id = p_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'qualifier not found: %', p_id;
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION qmos_get_risk_resolution_notes(p_id text)
RETURNS text
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT qmos_can_see_admin_fields() THEN
    RAISE EXCEPTION 'forbidden: resolution_notes requires Leadership/Admin';
  END IF;
  RETURN (SELECT r.resolution_notes FROM risks r WHERE r.id = p_id);
END;
$$;

CREATE OR REPLACE FUNCTION qmos_set_risk_resolution_notes(p_id text, p_notes text)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT qmos_can_see_admin_fields() THEN
    RAISE EXCEPTION 'forbidden: resolution_notes requires Leadership/Admin';
  END IF;
  UPDATE risks
     SET resolution_notes = p_notes,
         updated_at = now()
   WHERE id = p_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'risk not found: %', p_id;
  END IF;
END;
$$;

REVOKE ALL ON FUNCTION qmos_get_qualifier_admin_notes(text) FROM PUBLIC;
REVOKE ALL ON FUNCTION qmos_set_qualifier_admin_notes(text, text) FROM PUBLIC;
REVOKE ALL ON FUNCTION qmos_get_risk_resolution_notes(text) FROM PUBLIC;
REVOKE ALL ON FUNCTION qmos_set_risk_resolution_notes(text, text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION qmos_get_qualifier_admin_notes(text) TO authenticated;
GRANT EXECUTE ON FUNCTION qmos_set_qualifier_admin_notes(text, text) TO authenticated;
GRANT EXECUTE ON FUNCTION qmos_get_risk_resolution_notes(text) TO authenticated;
GRANT EXECUTE ON FUNCTION qmos_set_risk_resolution_notes(text, text) TO authenticated;

-- Convenience views: SECURITY DEFINER so they can read sensitive columns the
-- caller cannot GRANT-select; expose notes only when qmos_can_see_admin_fields().
-- Callers SELECT the view — they still cannot SELECT admin_only_notes on base table.
CREATE OR REPLACE VIEW v_qualifiers_public_fields
AS
SELECT
  id, full_name, preferred_name, email, phone, city, state_of_residence, timezone,
  status, verification_status, background_check_status, credit_check_status,
  available_for_placement, preferred_placement_types, minimum_monthly_compensation,
  open_to_negotiation, internal_owner, last_reviewed_date, next_review_due,
  readiness_score, auditengine_id, created_at, updated_at,
  CASE WHEN qmos_can_see_admin_fields() THEN admin_only_notes ELSE NULL END AS admin_only_notes
FROM qualifiers;

CREATE OR REPLACE VIEW v_risks_public_fields
AS
SELECT
  id, related_qualifier_id, related_placement_need_id, related_active_placement_id,
  risk_type, risk_level, risk_status, owner, due_date,
  CASE WHEN qmos_can_see_admin_fields() THEN resolution_notes ELSE NULL END AS resolution_notes,
  auditengine_id, created_at, updated_at
FROM risks;

-- Ensure views run as owner (default for views without security_invoker)
ALTER VIEW v_qualifiers_public_fields SET (security_invoker = false);
ALTER VIEW v_risks_public_fields SET (security_invoker = false);

GRANT SELECT ON v_qualifiers_public_fields TO authenticated;
GRANT SELECT ON v_risks_public_fields TO authenticated;

-- ---------------------------------------------------------------------------
-- Journal
-- ---------------------------------------------------------------------------
INSERT INTO qmos_schema_migrations (id, notes)
VALUES (
  '0002_qmos_rls_v1',
  'RLS v1: REVOKE anon; FORCE RLS; column grants omit admin notes; DEFINER RPCs/views for admin fields; reviews write gates admin_only; audit INSERT = can_approve'
)
ON CONFLICT (id) DO NOTHING;
