# QualifierManageOS — Base seed v1 proposal (0009)

**Status:** PROPOSAL ONLY — not applied  
**Audience:** `[INTERNAL ONLY]`  
**Sequencing:** shape yes → separate apply yes  
**Depends on:** live `0001`–`0008` (schema, RLS, allowlist, API)  
**Tip baseline when drafted:** `135b19a1e9e8585e0f667be968428886978db3d5`  
**SQL:** `migrations/0009_seed_base_v1.sql`  
**Source of truth for rows:** `data.base.js` (Phase-1 reviewed) — **not** `data.bulk.js`

---

## Steer locked (Rose 2026-07-30)

| Decision | Choice |
|---|---|
| Volume | **Base-only** first; bulk (~1k) = fast follow-on after E2E confirm |
| Staff | Fictional demo staff **and** real Auth allowlist rows — **separate / additive** |
| Demo emails | `@example.com` only (never a real domain) so the allowlist hook cannot match a real login |

---

## What gets seeded

| Table | Rows | Notes |
|---|---:|---|
| `staff` (demo) | 5 | Rose / Dana / Carmen Delgado / Marcus / Kim — `demo.<slug>@example.com`, `active=true`, **no** `auth_user_id` |
| `qualifiers` | 10 | Q-001…Q-010 — statuses span Active / Verified / Under Review / DNP / Intake / Paused |
| `licenses` | 15 | Health spans Verified Current → DNP / Missing Verification / Expiring Soon / etc. |
| `availability` | 10 | 1:1 with qualifiers |
| `documents` | 12 | Includes Requested / Needs Update / Expired / status-only vault link |
| `needs` | 6 | N-201…N-206 |
| `matches` | 8 | Admin approval: Pending / Approved / Rejected / Hold / Needs More Info |
| `placements` | 4 | Active / Ending Soon / At Risk |
| `reviews` | 5 | 3 `admin_only=true` (Sales Viewer must not see) |
| `risks` | 8 + **2 additive** | Base Open/In Review/Escalated; **R-609 Resolved**, **R-610 Dismissed** for UI filter branches |
| `cities` | 10 | Cities used by base qualifiers (+ Brooklyn map pin) |
| `coverage_gaps` | 1 | Brooklyn / N-206 only (other prototype gaps reference non-base needs — omitted) |

**Not seeded:** `data.js` “more*” rows (Q-011+), `data.bulk.js`, AuditEngine IDs, fabricated finance figures.

**Untouched:** existing real allowlist row(s) e.g. `Carmen Bootstrap` + live `auth_user_id`. Demo `INSERT … ON CONFLICT (name) DO NOTHING` so a name collision cannot overwrite a real allowlist row.

---

## Staff / allowlist separation (explicit)

```
DEMO (seed):     name = 'Dana Whitfield', email = 'demo.dana.whitfield@example.com'
REAL (ops):      name = 'Carmen Bootstrap', email = 'carmen.qmos@…', auth_user_id = <uuid>
```

- Demo staff exist so `reviewed_by` / `owner` / `internal_owner` FKs resolve and the UI shows familiar names.  
- Signing in as a real user never matches `@example.com`.  
- SQL comments mark every demo staff insert as **DEMO-ONLY**.

---

## Apply behavior

- Single transaction (`BEGIN` … `COMMIT`)  
- Idempotent upserts on entity PKs (`ON CONFLICT DO UPDATE`)  
- Journal: `0009_seed_base_v1`  
- No runtime change to `data.js` files (remain on disk for bulk follow-on / reference); live UI already hydrates from Supabase  

**Dry-run:** SQL validated against live DB inside a transaction that **ROLLBACK**’d — zero lasting rows; journal still ends at `0008`.

---

## Post-apply verify plan

1. Journal row `0009_seed_base_v1`  
2. Counts match table above (`qualifiers=10`, `matches=8`, `risks=10`, demo staff=5 + existing real allowlist ≥1)  
3. Allowlisted Admin hydrate: non-empty KPIs; Match Center shows Pending; Risk Review shows open + Resolved/Dismissed  
4. Sales Viewer (when provisioned): no `admin_only` reviews; admin notes null via views  
5. `approveMatch` / `setRisk` on a Pending match / Open risk succeed + audit row  
6. Demo staff emails still `@example.com`; real allowlist row unchanged  
7. No bulk license flood (`licenses` ≈ 15, not ~1000)

---

## Out of scope (held)

- Bulk-volume seed (`data.bulk.js`)  
- Retiring/deleting `data.js` from the repo  
- Merging real Auth users into fictional staff names  
- Sync seams / partner go-live  

---

## Ask-backs

Defaults if you agree:

1. Base-only from `data.base.js` + R-609/R-610 additive — **Y/N**  
2. Demo staff `@example.com`, real allowlist untouched — **Y/N**  
3. Coverage gaps = N-206 only (skip non-base need refs) — **Y/N**  
4. Apply only after separate yes — **Y/N**
