-- QualifierManageOS — 0005 Staff allowlist auth v1
-- STATUS: APPLIED (Rose shape+apply yes; journal 0005_staff_allowlist_auth_v1). Follow-on: 0006.
-- Tip baseline when drafted: 85acdf75e35e8d96bb62deb2c41d9af5e2a0a4b8
-- Companion: migrations/AUTH_ALLOWLIST_V1_PROPOSAL.md
--
-- Goals:
--   1) Extend staff with email / auth_user_id / active (allowlist = active + email).
--   2) Custom Access Token Hook mints JWT claims qmos_role + qmos_staff_name.
--   3) Non-allowlisted authenticated users get no claims → RLS denies like anon (no RAISE).
--   4) Hook executable only by supabase_auth_admin (0004-style revoke hygiene).
--
-- Ops after apply (not in this file):
--   Dashboard → Authentication → Hooks → Custom Access Token → qmos_custom_access_token_hook
--   Authentication → Providers → disable public signup

-- ---------------------------------------------------------------------------
-- 1) Extend staff (directory + allowlist in one table)
-- ---------------------------------------------------------------------------
ALTER TABLE staff
  ADD COLUMN IF NOT EXISTS email text,
  ADD COLUMN IF NOT EXISTS auth_user_id uuid,
  ADD COLUMN IF NOT EXISTS active boolean NOT NULL DEFAULT true;

-- Unique email when present (allow multiple NULLs until seed fills emails)
CREATE UNIQUE INDEX IF NOT EXISTS staff_email_lower_uidx
  ON staff (lower(email))
  WHERE email IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS staff_auth_user_id_uidx
  ON staff (auth_user_id)
  WHERE auth_user_id IS NOT NULL;

-- Link to Auth users when present (SET NULL on delete so soft-disable stays)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'staff_auth_user_id_fkey'
  ) THEN
    ALTER TABLE staff
      ADD CONSTRAINT staff_auth_user_id_fkey
      FOREIGN KEY (auth_user_id) REFERENCES auth.users(id) ON DELETE SET NULL;
  END IF;
END $$;

COMMENT ON COLUMN staff.email IS
  'Allowlist identity — matched to Auth email (case-insensitive). Required when active.';
COMMENT ON COLUMN staff.auth_user_id IS
  'Stable Auth user link; stamped on first successful allowlisted token mint.';
COMMENT ON COLUMN staff.active IS
  'Soft allowlist flag. false = no JWT qmos_role (behaves like anon for RLS).';

-- ---------------------------------------------------------------------------
-- 2) Custom Access Token Hook
-- ---------------------------------------------------------------------------
-- INVOKER (not DEFINER): GoTrue calls this as supabase_auth_admin, which
-- bypasses FORCE RLS. DEFINER-as-owner under FORCE RLS would see zero staff
-- rows and silently mint tokens without qmos_role.
CREATE OR REPLACE FUNCTION qmos_custom_access_token_hook(event jsonb)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
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

  -- Prefer stable auth_user_id match; fall back to email.
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

    -- Stamp auth_user_id on first match (best-effort; ignore races)
    IF uid IS NOT NULL AND staff_auth IS NULL THEN
      UPDATE staff
         SET auth_user_id = uid,
             updated_at = now()
       WHERE name = staff_name
         AND auth_user_id IS NULL
         AND active = true;
    END IF;
  END IF;
  -- Not on allowlist: leave claims without qmos_role — RLS denies like anon. Do not RAISE.

  event := jsonb_set(event, '{claims}', claims, true);
  RETURN event;
END;
$$;

COMMENT ON FUNCTION qmos_custom_access_token_hook(jsonb) IS
  'QMOS v1: mint qmos_role + qmos_staff_name from staff allowlist. Enable as Custom Access Token hook.';

-- Auth admin only — never anon / authenticated (same class of bug as 0004)
REVOKE ALL ON FUNCTION qmos_custom_access_token_hook(jsonb) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION qmos_custom_access_token_hook(jsonb) TO supabase_auth_admin;

-- Hook runner needs table privileges (role bypasses RLS but not GRANT)
GRANT SELECT (
  name, role, email, auth_user_id, active
) ON TABLE staff TO supabase_auth_admin;

GRANT UPDATE (auth_user_id, updated_at) ON TABLE staff TO supabase_auth_admin;

-- ---------------------------------------------------------------------------
-- 3) Journal (only when actually applied — leave commented in proposal reviews
--    or include once Rose gives apply yes; kept here for the apply path)
-- ---------------------------------------------------------------------------
INSERT INTO qmos_schema_migrations (id, notes)
VALUES (
  '0005_staff_allowlist_auth_v1',
  'Extend staff email/auth_user_id/active; Custom Access Token hook mints qmos_role'
)
ON CONFLICT (id) DO NOTHING;
