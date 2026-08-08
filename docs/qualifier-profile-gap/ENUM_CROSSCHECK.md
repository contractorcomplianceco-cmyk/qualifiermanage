# Issue #4 — Enum picklist cross-check (present fields)

**Status:** PROPOSAL ONLY  
**Spec source:** Ch. 2 AGENT RECOMMENDATION PDF (PR #6)  
**QMOS source:** `DATA_MODEL.md` § Enum vocabularies + seed values observed in `data.base.js` / `data.js`  
**Baseline:** schema text columns are mostly unconstrained (`text NOT NULL` without CHECK) except `staff.role`, `coverage_gaps.severity`, `decision_audit_log.action`.

For each ✅ Present field: QMOS current vocabulary, spec picklist (if any), diff, proposed reconciliation.

| # | Field | QMOS current (DATA_MODEL / data) | Spec picklist | Diff | Proposed reconciliation |
|---|---|---|---|---|---|
| 7 | Preferred Name | free text (`preferred_name`) | N/A | — | No CHECK. |
| 9 | Primary Email | free text (`email` NOT NULL) | N/A | — | No CHECK (format at app layer). |
| 25 | Identity Verification Status | Not Started · In Progress · Verified · Needs More Info · Failed Review · Human Review Required | Not Started; Pending; In Progress; Verified; Verified with Exception; Failed; Unable to Verify; Expired / Reverification Needed; Waived; Unknown / Needs Confirmation | **Drift:** QMOS missing Pending / Verified with Exception / Failed / Unable to Verify / Expired… / Waived / Unknown…; has Needs More Info / Failed Review / Human Review Required not in spec | **Widen CHECK to union** for one release (accept both vocabularies), then Rose picks retire list. Do **not** rewrite seed rows in this proposal. |
| 28 | Background Check Status | Not Started · Pending · Clear · Review Required (credit same) | Not Required; Not Started; Pending Consent; In Progress; Clear; Review Required; Adverse Result; Expired; Unable to Complete; Unknown / Needs Confirmation | **Drift:** spec adds Not Required / Pending Consent / In Progress / Adverse Result / Expired / Unable to Complete / Unknown…; QMOS “Pending” ≠ “Pending Consent” | Union CHECK; map `Pending` → keep until staff remap yes. |
| 30 | License Records | related `licenses` | N/A related list | — | No column CHECK. |
| 37 | Availability Status | Available Now · Available Soon · Limited Availability · Not Available · Paused | Available Now; Available on Future Date; Limited Availability; Temporarily Unavailable; Not Available; Pending Confirmation; Unknown / Needs Confirmation | **Drift:** QMOS `Available Soon` / `Paused` vs spec `Available on Future Date` / `Temporarily Unavailable` / extras | Union CHECK; alias view labels later — no silent rename of seed data. |
| 38 | Available From Date | date | N/A | — | No CHECK. |
| 39 | Preferred States | text[] (US names in seed) | Full US + territories + Nationwide / Other / Unknown… | Partial overlap | Optional array element CHECK deferred (large); document target picklist only in this pass. |
| 41 | Placement Status | Pending Activation · Active · Ending Soon · Renewed · Replaced · Ended · At Risk | Not Placed; Candidate Review; Client Review; Pending Agreement; Placed; Active Placement; Placement Ending; Placement Ended; On Hold; Cancelled; Unknown / Needs Confirmation | **Major drift** — different lifecycle language | **Do not force-replace** live QMOS placement vocabulary in safe subset. Add CHECK for **current QMOS** values only; open question to Rose whether portal spec should mirror QMOS or vice versa. |
| 42 | Current Placement Company | `placements.company_name` text | Lookup to Company Profile | Shape differs (text vs Core company) | Keep text until company modeling / D-1. |
| 43–44 | Placement Start/End | dates on `placements` | N/A | — | No CHECK. |
| 50 | Documents | related `documents` | N/A | — | No column CHECK. |
| 53–54 | Last / Next Review | dates | N/A | — | No CHECK. |
| 55 | Review Owner | `internal_owner` → `staff(name)` | Staff lookup | — | FK already enforces. |

### Additional unconstrained enum-like columns (DATA_MODEL) included in migration CHECKs

Rose asked to tighten “17 present … text NOT NULL with no CHECK”. Exact membership of that 17 is ambiguous vs the ✅ list (includes dates/related lists). Migration adds CHECKs for the **clearly enum present fields above** plus sibling DATA_MODEL enums that are already staff-critical and unconstrained: `qualifiers.status`, `credit_check_status`, `licenses.license_status`, `licenses.license_health_status`, `documents.document_status`, `needs.need_status`, `needs.urgency_level`, `needs.admin_review_status`, `matches.match_status`, `matches.admin_approval_status`, `risks.risk_level`, `risks.risk_status` — using **current DATA_MODEL vocabularies** (not portal-spec replacement) so apply cannot break seed. Spec-union widening for #25/#28/#37 only.

### Open enum decisions for Rose

1. Verification / background / availability: accept **union** vocab then retire QMOS-only labels — Y/N?  
2. Placement status: portal picklist vs QMOS DATA_MODEL — which is SoT for staff OS?  
3. Confirm whether “17 fields” means the 17 ✅ rows or 17 specific `text NOT NULL` columns — list if different.
