-- QualifierManageOS — 0010 Hotfix: qmos_set_risk must not return ungranted columns
-- Why: RETURNS risks includes resolution_notes, which authenticated cannot SELECT.
--   PostgREST then fails with permission denied on table risks after a successful UPDATE path.
--   Return jsonb of non-sensitive columns only (notes stay on view/RPC get path).
-- Applied with seed verify (Rose apply-yes on 0009).

DROP FUNCTION IF EXISTS qmos_set_risk(text, text);

CREATE OR REPLACE FUNCTION qmos_set_risk(p_id text, p_status text)
RETURNS jsonb
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

  -- Omit resolution_notes (not GRANTed to authenticated on base table)
  RETURN jsonb_build_object(
    'id', row_out.id,
    'related_qualifier_id', row_out.related_qualifier_id,
    'related_placement_need_id', row_out.related_placement_need_id,
    'related_active_placement_id', row_out.related_active_placement_id,
    'risk_type', row_out.risk_type,
    'risk_level', row_out.risk_level,
    'risk_status', row_out.risk_status,
    'owner', row_out.owner,
    'due_date', row_out.due_date,
    'auditengine_id', row_out.auditengine_id,
    'created_at', row_out.created_at,
    'updated_at', row_out.updated_at
  );
END;
$$;

COMMENT ON FUNCTION qmos_set_risk(text, text) IS
  'QMOS API v1: set risk_status + audit; returns jsonb without resolution_notes.';

-- Recreate changes return type → must re-assert EXECUTE hygiene
REVOKE ALL ON FUNCTION qmos_set_risk(text, text) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION qmos_set_risk(text, text) TO authenticated;

INSERT INTO qmos_schema_migrations (id, notes)
VALUES (
  '0010_set_risk_return_jsonb',
  'qmos_set_risk RETURNS jsonb without resolution_notes (column grant safe)'
)
ON CONFLICT (id) DO NOTHING;
