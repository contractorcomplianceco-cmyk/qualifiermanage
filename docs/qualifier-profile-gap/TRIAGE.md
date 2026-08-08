# Issue #4 — Field-gap triage (35 gaps)

**Status:** PROPOSAL ONLY · `[INTERNAL ONLY]`  
**Sources:** Issue #4 audit table (2026-08-08) · Ch. 2 AGENT RECOMMENDATION PDF (PR #6) · AE Contracts `634151a` (Registry §4a / Hole-Filling)  
**QMOS baseline:** `main` @ `fd45815` / `migrations/0001_qmos_schema_v1.sql`  
**Safe-subset migration:** `migrations/0013_qualifier_profile_alignment_v1.sql.PROPOSED`

**Count note:** Audit comment states 17 ✅ / 9 🟡 / 26 🔴 = 52. The attached audit table lists rows `#1–#59` (Portal fields appear as `#56–#59`; Rose’s original OUT list said `#57–#60`). Triage below covers **every Partial + Missing row in the audit table** (gaps). Where Rose’s “35 gaps” and the table diverge, see Open Questions.

Buckets: `QMOS-owned` · `ComplianceConnect-owned` · `QualifierConnect-future` · `Blocked by D-1` · `Reject / spec is wrong` · `Design conversation` (Rose-flagged hold, not a bucket rename)

| # | Spec field | Audit | Bucket | Rationale |
|---|---|---|---|---|
| 1 | Qualifier ID (UUID) | Partial | Blocked by D-1 | Friendly `Q-###` PK is live Option A; UUID PK / Core-shaped id held under Registry §4a until ID-001. |
| 2 | CCA Qualifier Number | Missing | Reject / spec is wrong | `Q-###` already is the staff-facing number; a second auto-number duplicates identity without Core. Keep PK; do not add parallel number. |
| 3 | First Name | Partial | QMOS-owned | Safe-subset name decomposition; keep `full_name` generated/compat. |
| 4 | Middle Name | Missing | QMOS-owned | Safe-subset name decomposition. |
| 5 | Last Name | Partial | QMOS-owned | Safe-subset name decomposition. |
| 6 | Suffix | Missing | QMOS-owned | Safe-subset; CHECK to spec picklist. |
| 8 | Date of Birth | Missing | Reject / spec is wrong (for QMOS v1) | Public/staff PII minimization: intake design excludes DOB at stage 0; QMOS staff command center should not become DOB SoT. Collect only if counsel/Rose later require for verification — separate yes. |
| 10 | Mobile Phone | Partial | QMOS-owned | Rename/split: `phone` → `mobile_phone` (+ keep `phone` as generated alias or migrate). |
| 11 | Alternate Phone | Missing | QMOS-owned | Safe-subset contact depth. |
| 12 | Mailing Address | Partial | QMOS-owned | Add `street_1`, `street_2`, `postal_code`; keep `city` / `state_of_residence`. |
| 13 | Preferred Contact Method | Missing | QMOS-owned | Safe-subset enum. |
| 14 | Preferred Language | Missing | QMOS-owned | Safe-subset enum. |
| 15 | Time Zone | Partial | QMOS-owned | Enum tighten to spec picklist (companion CHECK). |
| 16 | Primary Company | Missing | Blocked by D-1 | Company modeling; Core-minted companies — QMOS reflects later. Separate proposal. |
| 17 | Company Relationships | Missing | Blocked by D-1 | Needs relationship table + Core company ids. |
| 18 | Qualifier Relationship Type | Missing | Blocked by D-1 | Company relationship attribute. |
| 19 | Employment Status | Missing | Blocked by D-1 | Company/employment model. |
| 20 | Relationship Start Date | Missing | Blocked by D-1 | Company relationship attribute. |
| 21 | Relationship End Date | Missing | Blocked by D-1 | Company relationship attribute. |
| 22 | Ownership Percentage | Missing | Blocked by D-1 | Company relationship attribute. |
| 23 | Primary Contractor Trade | Partial | Design conversation | Trades live on `licenses` today; stored vs derived vs both — Rose hold. |
| 24 | Contractor Trades (multi) | Partial | Design conversation | `preferred_placement_types` ≠ licensed trades; needs design yes. |
| 26 | Identity Verified Date | Missing | QMOS-owned | Safe-subset verification event. |
| 27 | Identity Verified By | Missing | QMOS-owned | FK → `staff(name)`. |
| 29 | Verification Notes | Partial | QMOS-owned | New `verification_notes` (not `admin_only_notes`). Rule 7 LLM watch if ever LLM-written. |
| 31 | Active License Count | Missing | QMOS-owned | **View only** — no stored rollup. |
| 32 | Licenses Expiring Soon | Missing | QMOS-owned | View only. |
| 33 | Expired License Count | Missing | QMOS-owned | View only. |
| 34 | Restricted License Count | Missing | QMOS-owned | View only (from `licenses.restrictions`). |
| 35 | Next License Expiration Date | Missing | QMOS-owned | View only. |
| 36 | Overall License Health | Partial | QMOS-owned | View only from license enums — **no scoring formula** (Rule 8). |
| 40 | Travel Willingness | Partial | ComplianceConnect-owned | Spec portal concept; QMOS has `remote_ok` / `in_person_required` for placement logistics — do not invent a parallel portal travel enum on QMOS now. |
| 45 | Restriction Flag | Partial | QMOS-owned | `has_active_restriction` derived in view (or trigger-maintained). |
| 46 | Restriction Summary | Partial | QMOS-owned | Nullable admin-editable `restriction_summary` on qualifiers. Rule 7 LLM watch if LLM-written. |
| 47 | Disciplinary Flag | Missing | QMOS-owned (deferred) | Meaningful, but not in Rose’s safe-subset cut — propose in follow-on (may derive from `risks`). **Not in 0013.PROPOSED.** |
| 48 | Internal Risk Level | Partial | QMOS-owned (deferred) | Exists on `risks.risk_level`; qualifier rollup needs design — not in safe subset. |
| 49 | Monitoring Status | Missing | Reject / spec is wrong (for QMOS) | No monitoring subsystem in QMOS; field belongs to a monitoring product, not staff placement OS. |
| 51 | Document Completeness Status | Missing | QMOS-owned (deferred) | Qualifier-level rollup from `documents` — view later; not in Rose safe-subset cut. |
| 52 | Review Frequency | Missing | QMOS-owned | Safe-subset enum. |
| 56 | Portal Account Status | Missing | QualifierConnect-future | PR #2 §8; QMOS is staff-only. |
| 57 | Profile Confirmation Status | Missing | QualifierConnect-future | Portal confirmation lifecycle. |
| 58 | Profile Last Confirmed Date | Missing | QualifierConnect-future | Portal confirmation lifecycle. |
| 59 | Profile Confirmed By | Missing | QualifierConnect-future | Portal confirmation lifecycle. |

### Present (✅) — not gaps; enum cross-check applies

| # | Spec field | Notes |
|---|---|---|
| 7 | Preferred Name | Keep |
| 9 | Primary Email | Keep (`email`) |
| 25 | Identity Verification Status | CHECK tighten — see enum table |
| 28 | Background Check Status | CHECK tighten — see enum table |
| 30 | License Records | `licenses` related list |
| 37 | Availability Status | On `availability` — CHECK tighten |
| 38 | Available From Date | `available_start_date` |
| 39 | Preferred States | `preferred_states` |
| 41 | Placement Status | On `placements` — CHECK tighten |
| 42 | Current Placement Company | Via join |
| 43 | Placement Start Date | Via join |
| 44 | Placement End Date | Via join |
| 50 | Documents | `documents` related list |
| 53 | Last Review Date | `last_reviewed_date` |
| 54 | Next Review Date | `next_review_due` |
| 55 | Review Owner | `internal_owner` |

*(If the audit’s “17 present” includes one more row than listed here after numbering reconcile, call it out in Open Questions.)*

### Safe-subset coverage map (Rose cut → this proposal)

| Rose cut | Spec #s | In `0013…PROPOSED` |
|---|---|---|
| Name decomposition | 3–6 | Yes |
| Contact depth | 10–15 | Yes |
| Verification event | 26, 27, 29 | Yes |
| Review cadence | 52 (+ 53/54 exist) | Yes |
| License rollups as views | 31–36 | Yes (`v_qualifier_license_rollups`) |
| Restriction convenience | 45–46 | Yes |
| Enum tightening (present) | 25, 28, 37, 41 + related DATA_MODEL enums | Yes (companion section in same file) |
| Explicitly OUT | 16–22, 23–24, 49, 56–59, Core id | Excluded |
