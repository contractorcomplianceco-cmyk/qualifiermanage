-- QualifierManageOS — 0006 Hotfix: allowlist hook must see staff under FORCE RLS
-- Why: live pg_roles shows supabase_auth_admin.rolbypassrls = false.
--   INVOKER hook therefore hit staff RLS (qmos_is_staff) → 0 rows → no qmos_role.
--   Separately: STABLE + UPDATE is illegal → would error once a row matched.
-- Fix: keep INVOKER; add staff policies for supabase_auth_admin; mark hook VOLATILE.
-- Tip: apply after 0005 on same day as Rose apply-yes.

CREATE OR REPLACE FUNCTION qmos_custom_access_token_hook(event jsonb)
RETURNS jsonb
LANGUAGE plpgsql
VOLATILE
SET search_path = public
AS $$
DECLARE
  claims jsonb;
  uid uuid;
  claim_email text;
  staff_role text;
  staff_name text;
  staff_auth uuid;
BEGIN
  claims := COALESCE(event->'claims', '{}'::jsonb);
  uid := NULLIF(event->>'user_id', '')::uuid;
  claim_email := lower(NULLIF(claims->>'email', ''));

  SELECT s.role, s.name, s.auth_user_id
    INTO staff_role, staff_name, staff_auth
  FROM staff s
  WHERE s.active = true
    AND s.email IS NOT NULL
    AND (
      (uid IS NOT NULL AND s.auth_user_id = uid)
      OR (claim_email IS NOT NULL AND lower(s.email) = claim_email)
    )
  ORDER BY CASE WHEN s.auth_user_id = uid THEN 0 ELSE 1 END
  LIMIT 1;

  IF staff_role IS NOT NULL THEN
    claims := jsonb_set(claims, '{qmos_role}', to_jsonb(staff_role), true);
    claims := jsonb_set(claims, '{qmos_staff_name}', to_jsonb(staff_name), true);

    IF uid IS NOT NULL AND staff_auth IS NULL THEN
      UPDATE staff
         SET auth_user_id = uid,
             updated_at = now()
       WHERE name = staff_name
         AND auth_user_id IS NULL
         AND active = true;
    END IF;
  END IF;

  event := jsonb_set(event, '{claims}', claims, true);
  RETURN event;
END;
$$;

COMMENT ON FUNCTION qmos_custom_access_token_hook(jsonb) IS
  'QMOS v1: mint qmos_role + qmos_staff_name from staff allowlist (VOLATILE; INVOKER as supabase_auth_admin).';

-- Re-assert execute hygiene (CREATE OR REPLACE preserves ACLs, but be explicit)
REVOKE ALL ON FUNCTION qmos_custom_access_token_hook(jsonb) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION qmos_custom_access_token_hook(jsonb) TO supabase_auth_admin;
GRANT USAGE ON SCHEMA public TO supabase_auth_admin;

-- Auth hook runner is subject to FORCE RLS — allow read/stamp only
DROP POLICY IF EXISTS qmos_auth_admin_staff_select ON staff;
DROP POLICY IF EXISTS qmos_auth_admin_staff_update ON staff;

CREATE POLICY qmos_auth_admin_staff_select ON staff
  FOR SELECT TO supabase_auth_admin
  USING (true);

CREATE POLICY qmos_auth_admin_staff_update ON staff
  FOR UPDATE TO supabase_auth_admin
  USING (true)
  WITH CHECK (true);

INSERT INTO qmos_schema_migrations (id, notes)
VALUES (
  '0006_allowlist_hook_force_rls_fix',
  'INVOKER hook: staff policies for supabase_auth_admin (no BYPASSRLS); VOLATILE for auth_user_id stamp'
)
ON CONFLICT (id) DO NOTHING;
