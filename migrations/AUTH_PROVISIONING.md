# Staff Auth account provisioning (QMOS)

**Audience:** `[INTERNAL ONLY]`  
**Public signup:** OFF (`disable_signup=true`)

## How a staff person gets their first Supabase Auth account

Same pattern as the Admin bootstrap — **not** self-serve signup.

1. **Admin / Leadership** (or Carmen via service_role / Dashboard) creates the Auth user:
   - Supabase Dashboard → Authentication → Users → Add user, **or**
   - `POST /auth/v1/admin/users` with **service_role** (server/ops only — never in the browser)
2. Matching **`staff` allowlist row**: `email` (same address), `role`, `active=true`
3. Staff signs in on https://qualifiers.cagteam.net with email + password  
   → Custom Access Token hook mints `qmos_role` / `qmos_staff_name`

Deactivate: set `staff.active=false` (soft-remove). Do not rely on deleting Auth user alone for RLS deny on next token refresh.

Invite email UX / password-reset polish = later slice.
