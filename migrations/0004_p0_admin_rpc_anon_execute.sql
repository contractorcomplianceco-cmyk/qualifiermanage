-- QualifierManageOS — 0004 P0 emergency: admin RPC anon EXECUTE + fail-closed guards
-- Severity: anon could call DEFINER RPCs and read/write admin_only_notes / resolution_notes
-- Root cause: Supabase grants EXECUTE to anon/authenticated directly on new functions;
--   REVOKE FROM PUBLIC alone does not remove those grants. Also IF NOT <NULL> fails open.
-- Rose 2026-07-30: apply ASAP; no separate approval cycle.

-- ---------------------------------------------------------------------------
-- 1) Recreate four DEFINER RPCs with fail-closed COALESCE guards
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION qmos_get_qualifier_admin_notes(p_id text)
RETURNS text
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT COALESCE(qmos_can_see_admin_fields(), false) THEN
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
  IF NOT COALESCE(qmos_can_see_admin_fields(), false) THEN
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
  IF NOT COALESCE(qmos_can_see_admin_fields(), false) THEN
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
  IF NOT COALESCE(qmos_can_see_admin_fields(), false) THEN
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

-- ---------------------------------------------------------------------------
-- 2) Explicit REVOKE from PUBLIC + anon + authenticated, then GRANT authenticated
--    (Supabase default REST exposure grants anon/authenticated directly)
-- ---------------------------------------------------------------------------
REVOKE ALL ON FUNCTION qmos_get_qualifier_admin_notes(text) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION qmos_set_qualifier_admin_notes(text, text) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION qmos_get_risk_resolution_notes(text) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION qmos_set_risk_resolution_notes(text, text) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION qmos_get_qualifier_admin_notes(text) TO authenticated;
GRANT EXECUTE ON FUNCTION qmos_set_qualifier_admin_notes(text, text) TO authenticated;
GRANT EXECUTE ON FUNCTION qmos_get_risk_resolution_notes(text) TO authenticated;
GRANT EXECUTE ON FUNCTION qmos_set_risk_resolution_notes(text, text) TO authenticated;

-- ---------------------------------------------------------------------------
-- 3) Hygiene: other qmos_* helpers are not DEFINER but were also EXECUTE-able by anon
--    via REST. Revoke anon; keep authenticated for RLS/policy use. Trigger fn: no API grant.
-- ---------------------------------------------------------------------------
REVOKE ALL ON FUNCTION qmos_jwt_role() FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION qmos_is_staff() FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION qmos_can_approve() FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION qmos_can_edit() FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION qmos_can_see_admin_fields() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION qmos_jwt_role() TO authenticated;
GRANT EXECUTE ON FUNCTION qmos_is_staff() TO authenticated;
GRANT EXECUTE ON FUNCTION qmos_can_approve() TO authenticated;
GRANT EXECUTE ON FUNCTION qmos_can_edit() TO authenticated;
GRANT EXECUTE ON FUNCTION qmos_can_see_admin_fields() TO authenticated;

-- Trigger function must not be exposed via REST
REVOKE ALL ON FUNCTION qmos_forbid_audit_mutation() FROM PUBLIC, anon, authenticated;

INSERT INTO qmos_schema_migrations (id, notes)
VALUES (
  '0004_p0_admin_rpc_anon_execute',
  'P0: REVOKE anon EXECUTE on admin DEFINER RPCs; fail-closed COALESCE guards; revoke anon on qmos helpers'
)
ON CONFLICT (id) DO NOTHING;
