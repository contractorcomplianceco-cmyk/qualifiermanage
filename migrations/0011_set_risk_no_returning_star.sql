-- QualifierManageOS — 0011 Hotfix: set_risk without RETURNING * / risks rowtype
-- Why: INVOKER UPDATE … RETURNING r.* still requires SELECT on every column including
--   resolution_notes (not granted). Build jsonb from explicit RETURNING column list.
-- Follows 0010 (return type already jsonb).

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
  new_id text;
  new_related_qualifier_id text;
  new_related_placement_need_id text;
  new_related_active_placement_id text;
  new_risk_type text;
  new_risk_level text;
  new_risk_status text;
  new_owner text;
  new_due_date date;
  new_auditengine_id uuid;
  new_created_at timestamptz;
  new_updated_at timestamptz;
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
   RETURNING
     r.id,
     r.related_qualifier_id,
     r.related_placement_need_id,
     r.related_active_placement_id,
     r.risk_type,
     r.risk_level,
     r.risk_status,
     r.owner,
     r.due_date,
     r.auditengine_id,
     r.created_at,
     r.updated_at
   INTO
     new_id,
     new_related_qualifier_id,
     new_related_placement_need_id,
     new_related_active_placement_id,
     new_risk_type,
     new_risk_level,
     new_risk_status,
     new_owner,
     new_due_date,
     new_auditengine_id,
     new_created_at,
     new_updated_at;

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

  RETURN jsonb_build_object(
    'id', new_id,
    'related_qualifier_id', new_related_qualifier_id,
    'related_placement_need_id', new_related_placement_need_id,
    'related_active_placement_id', new_related_active_placement_id,
    'risk_type', new_risk_type,
    'risk_level', new_risk_level,
    'risk_status', new_risk_status,
    'owner', new_owner,
    'due_date', new_due_date,
    'auditengine_id', new_auditengine_id,
    'created_at', new_created_at,
    'updated_at', new_updated_at
  );
END;
$$;

COMMENT ON FUNCTION qmos_set_risk(text, text) IS
  'QMOS API v1: set risk_status + audit; jsonb return; no resolution_notes touch.';

REVOKE ALL ON FUNCTION qmos_set_risk(text, text) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION qmos_set_risk(text, text) TO authenticated;

INSERT INTO qmos_schema_migrations (id, notes)
VALUES (
  '0011_set_risk_no_returning_star',
  'set_risk: RETURNING only granted columns into scalars (not risks rowtype)'
)
ON CONFLICT (id) DO NOTHING;
