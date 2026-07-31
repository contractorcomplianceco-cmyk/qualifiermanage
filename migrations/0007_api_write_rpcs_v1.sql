-- QualifierManageOS — 0007 API write RPCs v1
-- STATUS: PROPOSAL ONLY — do not apply until Rose yes on API shape, then separate yes to apply.
-- Companion: migrations/API_V1_PROPOSAL.md
-- Tip baseline when drafted: fb9a0bbd44107e22fde65cbea2dbeba337058e8f
--
-- Goals:
--   1) Replace prototype approveMatch / setRisk (localStorage) with audited RPCs.
--   2) Fail-closed role checks (COALESCE); 0004-style EXECUTE revoke hygiene.
--   3) INVOKER under RLS — no SECURITY DEFINER, no service_role.
--   4) No seed, no seams.

-- ---------------------------------------------------------------------------
-- qmos_approve_match — Leadership / Admin only
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION qmos_approve_match(p_id text, p_status text)
RETURNS matches
LANGUAGE plpgsql
VOLATILE
SET search_path = public
AS $$
DECLARE
  actor text;
  actor_email text;
  old_status text;
  row_out matches;
BEGIN
  IF NOT COALESCE(qmos_can_approve(), false) THEN
    RAISE EXCEPTION 'forbidden: approve_match requires Leadership/Admin'
      USING ERRCODE = '42501';
  END IF;

  IF p_status IS NULL OR p_status NOT IN (
    'Pending', 'Approved', 'Rejected', 'Hold', 'Needs More Info'
  ) THEN
    RAISE EXCEPTION 'invalid admin_approval_status: %', p_status
      USING ERRCODE = '22023';
  END IF;

  actor := NULLIF(auth.jwt() ->> 'qmos_staff_name', '');
  actor_email := NULLIF(auth.jwt() ->> 'email', '');

  SELECT m.admin_approval_status INTO old_status
  FROM matches m WHERE m.id = p_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'match not found: %', p_id
      USING ERRCODE = 'P0002';
  END IF;

  UPDATE matches m
     SET admin_approval_status = p_status,
         reviewed_by = actor,
         reviewed_date = CURRENT_DATE,
         updated_at = now()
   WHERE m.id = p_id
   RETURNING m.* INTO row_out;

  INSERT INTO decision_audit_log (
    actor_name, actor_email, action, entity_type, entity_id, from_value, to_value
  ) VALUES (
    actor,
    actor_email,
    'approve_match',
    'match',
    p_id,
    jsonb_build_object('admin_approval_status', old_status),
    jsonb_build_object(
      'admin_approval_status', p_status,
      'reviewed_by', actor,
      'reviewed_date', CURRENT_DATE
    )
  );

  RETURN row_out;
END;
$$;

COMMENT ON FUNCTION qmos_approve_match(text, text) IS
  'QMOS API v1: set match admin_approval_status + append decision_audit_log.';

-- ---------------------------------------------------------------------------
-- qmos_set_risk — staff except Sales Viewer
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION qmos_set_risk(p_id text, p_status text)
RETURNS risks
LANGUAGE plpgsql
VOLATILE
SET search_path = public
AS $$
DECLARE
  actor text;
  actor_email text;
  old_status text;
  row_out risks;
BEGIN
  IF NOT COALESCE(qmos_can_edit(), false) THEN
    RAISE EXCEPTION 'forbidden: set_risk requires an editable staff role'
      USING ERRCODE = '42501';
  END IF;

  IF p_status IS NULL OR p_status NOT IN (
    'Open', 'In Review', 'Resolved', 'Dismissed', 'Escalated'
  ) THEN
    RAISE EXCEPTION 'invalid risk_status: %', p_status
      USING ERRCODE = '22023';
  END IF;

  actor := NULLIF(auth.jwt() ->> 'qmos_staff_name', '');
  actor_email := NULLIF(auth.jwt() ->> 'email', '');

  SELECT r.risk_status INTO old_status
  FROM risks r WHERE r.id = p_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'risk not found: %', p_id
      USING ERRCODE = 'P0002';
  END IF;

  UPDATE risks r
     SET risk_status = p_status,
         updated_at = now()
   WHERE r.id = p_id
   RETURNING r.* INTO row_out;

  INSERT INTO decision_audit_log (
    actor_name, actor_email, action, entity_type, entity_id, from_value, to_value
  ) VALUES (
    actor,
    actor_email,
    'set_risk',
    'risk',
    p_id,
    jsonb_build_object('risk_status', old_status),
    jsonb_build_object('risk_status', p_status)
  );

  RETURN row_out;
END;
$$;

COMMENT ON FUNCTION qmos_set_risk(text, text) IS
  'QMOS API v1: set risk_status + append decision_audit_log.';

-- ---------------------------------------------------------------------------
-- Audit INSERT was Admin/Leadership-only (0002). set_risk is allowed for
-- Placement Coordinator / Fulfillment too — widen INSERT so their audited
-- writes do not fail CLOSED on the audit row. SELECT unchanged (any staff).
-- Approve still gated inside qmos_approve_match via qmos_can_approve().
-- ---------------------------------------------------------------------------
DROP POLICY IF EXISTS qmos_audit_insert ON decision_audit_log;
CREATE POLICY qmos_audit_insert ON decision_audit_log
  FOR INSERT TO authenticated
  WITH CHECK (COALESCE(qmos_can_approve(), false) OR COALESCE(qmos_can_edit(), false));

-- ---------------------------------------------------------------------------
-- EXECUTE hygiene (PUBLIC + anon + authenticated revoke, then authenticated only)
-- ---------------------------------------------------------------------------
REVOKE ALL ON FUNCTION qmos_approve_match(text, text) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION qmos_set_risk(text, text) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION qmos_approve_match(text, text) TO authenticated;
GRANT EXECUTE ON FUNCTION qmos_set_risk(text, text) TO authenticated;

-- Journal (only when actually applied)
INSERT INTO qmos_schema_migrations (id, notes)
VALUES (
  '0007_api_write_rpcs_v1',
  'API v1 write RPCs: qmos_approve_match + qmos_set_risk; audit INSERT = can_approve OR can_edit'
)
ON CONFLICT (id) DO NOTHING;
