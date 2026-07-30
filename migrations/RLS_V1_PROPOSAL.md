# QualifierManageOS — RLS v1 proposal (0002)

**Status:** PROPOSAL ONLY — not applied  
**Audience:** `[INTERNAL ONLY]`  
**Revision:** gap-fix after Rose review (admin columns + reviews write + audit INSERT = B)

## Fixes vs prior draft

| Gap Rose flagged | Fix |
|---|---|
| Sales Viewer could `SELECT` `qualifiers` / `risks` and read sensitive columns, bypassing views | **Column privileges:** `admin_only_notes` / `resolution_notes` are **not** GRANTed to `authenticated` on base tables (SELECT/INSERT/UPDATE). Non-admins **cannot** read those columns from the base table. Admins use **SECURITY DEFINER** RPCs + **security_invoker=false** views. |
| `reviews` write could blind-UPDATE `admin_only` rows | Write policy now requires `(admin_only = false OR qmos_can_see_admin_fields())` on USING **and** WITH CHECK (same as SELECT). |
| Audit INSERT too broad | INSERT policy = **`qmos_can_approve()` only** (Admin/Leadership) — matches approve_match / set_risk. |

## Role matrix

| Role | SELECT ops | General write | Match approve / audit INSERT | Admin columns / admin_only reviews |
|---|---|---|---|---|
| Leadership | Y | Y | Y | Y (via RPC/view) |
| Admin | Y | Y | Y | Y (via RPC/view) |
| Placement Coordinator | Y | Y | N | N |
| Fulfillment | Y | Y | N | N |
| Sales Viewer | Y | N | N | N |
| anon | **N** | **N** | **N** | **N** |

## Admin column enforcement (not “please use the view”)

1. `REVOKE` / omit GRANT of `qualifiers.admin_only_notes` and `risks.resolution_notes` for `authenticated`
2. Base-table `SELECT *` / selecting those columns as Sales Viewer → **permission denied**
3. Only paths that can return/set the values for authenticated:
   - `qmos_get_qualifier_admin_notes` / `qmos_set_qualifier_admin_notes` (DEFINER, checks Admin/Leadership)
   - `qmos_get_risk_resolution_notes` / `qmos_set_risk_resolution_notes` (same)
   - `v_qualifiers_public_fields` / `v_risks_public_fields` (DEFINER views; notes null unless Admin/Leadership)

## `decision_audit_log`

- SELECT: any staff  
- INSERT: **Admin/Leadership only** (`qmos_can_approve()`)  
- UPDATE/DELETE: no GRANT, no policy, existing append trigger  

## Still not applied

Live journal remains `0001` only until Rose yes on shape **and** separate yes to apply.
