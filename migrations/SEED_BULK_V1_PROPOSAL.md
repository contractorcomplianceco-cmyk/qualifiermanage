# QualifierManageOS — Bulk volume seed v1 proposal (0012)

**Status:** PROPOSAL ONLY — not applied  
**Audience:** `[INTERNAL ONLY]`  
**Sequencing:** shape yes → separate apply yes  
**Depends on:** live `0009` base seed (+ `0010`/`0011` set_risk fixes); client debounce shipped (`0efb682`)  
**Tip baseline when drafted:** `0efb68243a3e91f7848b5849cc89926980962d01`  
**SQL:** `migrations/0012_seed_bulk_v1.sql` (~2.1 MB, generated from `data.js`)  
**Source:** full `data.js` composition = base (already live) + hand `more*` + `data.bulk.js`

---

## Collision fix (required before shape yes)

`data.js` more* previously reused **R-609 / R-610**, which collide with 0009’s additive Resolved/Dismissed demo rows. Those more* rows are now **R-613 / R-614** in both `data.js` and `0012`. This file **does not** `INSERT`/`UPDATE` R-609 or R-610, so the live Resolved/Dismissed branches survive apply.

## Why now

Base seed proved API/RLS/allowlist/end-to-end. Bulk adds production-scale license/qualifier volume for Coverage Map density, Licenses register scrolling, and leaderboard realism — still `[INTERNAL ONLY]`, still no seams.

Debounce on approve/setRisk landed first so bulk volume does not multiply double-audit rows.

---

## What gets added (target totals after apply)

| Table | After 0009 | After 0012 (target) | Delta |
|---|---:|---:|---:|
| `staff` (demo `@example.com`) | 5 | **7** | +Nina Cole, Leo Park |
| `qualifiers` | 10 | **289** | +12 more* + 267 bulk |
| `licenses` | 15 | **1039** | +~1024 |
| `availability` | 10 | **289** | |
| `documents` | 12 | **234** | |
| `needs` | 6 | **12** | +N-207…N-212 |
| `matches` | 8 | **11** | |
| `placements` | 4 | **10** | |
| `reviews` | 5 | **10** | |
| `risks` | 10 (incl. R-609/R-610) | **14** | data.js risks use **R-613/R-614** (not 609/610); **0009 R-609/R-610 untouched** |
| `cities` | 10 | **26** | |
| `coverage_gaps` | 1 | **5** | all need_ids exist in needs |

Real Auth allowlist rows (`Carmen Bootstrap`, `Sales Viewer Test`, …) **untouched** — staff inserts are `ON CONFLICT (name) DO NOTHING` with `@example.com` only.

---

## Rules carried forward

- Demo staff emails: `demo.<slug>@example.com` only  
- No bulk Auth accounts  
- `auditengine_id` stays NULL (staff-only column; FYI for any future client surface)  
- No fabricated finance beyond what `data.js` already holds for placements  
- Does **not** truncate `decision_audit_log`  
- Idempotent upserts — safe re-run  

---

## Apply / verify plan (after separate yes)

1. Apply `0012` via pooler (`RESET ROLE` first — never leave pooler as `authenticated`)  
2. Journal `0012_seed_bulk_v1`  
3. Counts match table above  
4. Admin hydrate: licenses ≈ 1039; coverage map pins denser; gaps = 5  
5. Sales Viewer still sees no admin-only reviews / null notes  
6. Single approve/setRisk → **one** audit row (debounce)  
7. Demo staff still `@example.com`; real allowlist unchanged  

**Dry-run:** optional `ROLLBACK` validate before apply yes (same as 0009).

---

## Out of scope

- Clearing/rebuilding base from scratch  
- Merging real Auth emails into demo staff names  
- Client-facing exposure / renaming `auditengine_id`  
- Retiring `data.js` files from the repo (still useful as generators)  

---

## Ask-backs

1. Full `data.js` composition (more* + bulk), not bulk-arrays-only — **Y/N**  
2. Keep 0009 R-609/R-610 (Resolved/Dismissed); more* risks as R-613/R-614 — **Y/N** (fixed in SQL)  
3. Apply only after separate yes — **Y/N**
