# QualifierManageOS — Data Model & Connection Points

The complete data contract for wiring QualifierManageOS to a real backend and to the rest of the
CCA ecosystem. Everything the UI reads comes from `data.js`, which is **shaped to map 1:1 onto a
Postgres/Supabase schema**. Swap the `import('./data.js')` seam for real queries returning the same
shape and the UI needs no other changes.

All IDs are string keys with a per-entity prefix. All dates are `YYYY-MM-DD` strings. Day-countdowns
(expiry, "due in N days") are computed relative to the exported **`TODAY`** constant — replace with
`now()` when live.

---

## Entities (11 exports)

| Export | Prefix | Rows | Purpose |
|---|---|---|---|
| `QUALIFIERS` | `Q-` | 10 | The people CCA can place. Identity, screening status, comp, readiness. |
| `LICENSES` | `L-` | 15 | Licenses held by qualifiers; verification recency & placement usability. |
| `AVAILABILITY` | `A-` | 10 | 1:1 with qualifier — capacity, preferred states/trades, work mode. |
| `DOCUMENTS` | `D-` | 12 | Doc records (ID, license copy, insurance, agreement…) + status. |
| `NEEDS` | `N-` | 6 | Company demand — a role a company needs a qualifier for. |
| `MATCHES` | `M-` | 8 | Candidate ↔ need pairings with fit score & **human approval** state. |
| `PLACEMENTS` | `P-` | 4 | Active/ongoing engagements + the CCA fee split. |
| `REVIEWS` | `V-` | 5 | Performance reviews of qualifiers on placements. |
| `RISKS` | `R-` | 8 | Risk register across qualifiers, needs, and placements. |
| `STAFF` | — | 5 | Internal user directory + role (the auth/role source). |
| `TODAY` | — | — | Reference "now" (`'2026-07-24'`) for all relative date math. |

---

## Relationships (foreign keys)

```
STAFF.name ──────────┐ (internalOwner / placementOwner / owner / reviewedBy)
                     │
QUALIFIERS (Q) ◄─────┼── LICENSES.qualifierId          (1 : many)
     ▲   ▲   ▲       ├── AVAILABILITY.qualifierId       (1 : 1)
     │   │   │       ├── DOCUMENTS.qualifierId          (1 : many)
     │   │   │       │        └─ DOCUMENTS.relatedLicenseId → LICENSES.id (nullable)
     │   │   │       ├── MATCHES.qualifierId
     │   │   │       ├── PLACEMENTS.qualifierId
     │   │   │       ├── REVIEWS.qualifierId
     │   │   │       └── RISKS.relatedQualifierId       (nullable)
     │   │   │
NEEDS (N) ◄──────────┼── MATCHES.placementNeedId
     ▲               ├── PLACEMENTS.placementNeedId     (nullable)
     │               └── RISKS.relatedPlacementNeedId   (nullable)
     │
MATCHES.qualifierLicenseId → LICENSES.id (nullable)
PLACEMENTS (P) ◄─────┬── REVIEWS.relatedPlacementId     (nullable)
                     └── RISKS.relatedActivePlacementId (nullable)
PLACEMENTS.placementMatchId → MATCHES.id (nullable)
```

A **RISK** attaches to exactly one subject via whichever of `relatedQualifierId` /
`relatedActivePlacementId` / `relatedPlacementNeedId` is non-null.

---

## Field reference

### QUALIFIERS (`Q-`)
`id` · `fullName` · `preferredName` · `email` · `phone` · `city` · `stateOfResidence` · `timezone`
· `status` *(enum)* · `verificationStatus` *(enum)* · `backgroundCheckStatus` *(enum)* ·
`creditCheckStatus` *(enum)* · `availableForPlacement` *(bool)* · `preferredPlacementTypes` *(string[])*
· `minimumMonthlyCompensation` *(int $)* · `openToNegotiation` *(bool)* · `internalOwner` *(→STAFF.name)*
· `lastReviewedDate` · `nextReviewDue` · `adminOnlyNotes` *(**sensitive** — hide from Sales Viewer)* ·
`readiness` *({ score:int, parts:[{k,pts,tone,note}] } — derived; recompute server-side)*

### LICENSES (`L-`)
`id` · `qualifierId` *(→Q)* · `state` · `licenseNumber` · `licenseType` · `tradeClassification` ·
`licenseStatus` *(enum)* · `issueDate` · `expirationDate` · `lastVerifiedDate` · `verificationSource`
*(e.g. "FL DBPR portal", "TDLR lookup", "CSLB lookup")* · `restrictions` *(nullable)* ·
`canBeUsedForPlacement` *(bool)* · `licenseHealthStatus` *(enum — derived from status + verify recency)*

### AVAILABILITY (`A-`)
`id` · `qualifierId` *(→Q, 1:1)* · `availabilityStatus` *(enum)* · `availableStartDate` *(nullable)* ·
`availableEndDate` *(nullable)* · `preferredStates` *(string[])* · `preferredTrades` *(string[])* ·
`maxActivePlacements` *(int)* · `currentPlacementCount` *(int)* · `remoteOk` *(bool)* ·
`inPersonRequired` *(bool)* · `notes`

### DOCUMENTS (`D-`)
`id` · `qualifierId` *(→Q)* · `relatedLicenseId` *(→L, nullable)* · `documentType` *(ID / License Copy
/ Insurance / Agreement / Resume / Background Check / Experience Proof / Bonding)* · `documentStatus`
*(enum)* · `expirationDate` *(nullable)* · `fileLink` *(`vault://…` scheme; screening = `vault://status-only`;
`null` when not yet received)* · `internalNotes` *(nullable)*

### NEEDS (`N-`)
`id` · `companyName` · `contactName` · `neededState` · `neededTradeClassification` · `needStatus`
*(enum)* · `targetStartDate` · `expectedDuration` · `monthlyOfferAmount` *(int $)* · `setupSigningAmount`
*(int $)* · `urgencyLevel` *(enum)* · `requiredDocuments` *(string[])* · `placementOwner` *(→STAFF.name)*
· `adminReviewStatus` *(enum)*

### MATCHES (`M-`)
`id` · `placementNeedId` *(→N)* · `qualifierId` *(→Q)* · `qualifierLicenseId` *(→L, nullable)* ·
`matchStatus` *(enum)* · `fitScore` *(int 0–100 — decision support only)* · `adminApprovalStatus`
*(enum — **the human decision**)* · `reviewedBy` *(→STAFF, nullable)* · `reviewedDate` *(nullable)* ·
`matchReason` *(nullable)* · `ineligibilityReason` *(nullable)* · `factors` *([{k,tone,v}] explainability rows)*

### PLACEMENTS (`P-`)
`id` · `companyName` · `qualifierId` *(→Q)* · `placementNeedId` *(→N, nullable)* · `placementMatchId`
*(→M, nullable)* · `placementStatus` *(enum)* · `startDate` · `expectedEndDate` · `actualEndDate`
*(nullable)* · `monthlyFee` *(int $)* · `qualifierMonthlyCompensation` *(int $)* · `ccaMonthlyFee`
*(int $ — margin)* · `backupQualifierNeeded` *(bool)* · `backupQualifierIdentified` *(bool)* ·
`renewalReviewDate` · `internalPlacementNotes`

### REVIEWS (`V-`)
`id` · `qualifierId` *(→Q)* · `relatedPlacementId` *(→P, nullable)* · `reviewType` · `reliabilityRating`
*(1–5)* · `communicationRating` *(1–5)* · `documentReadinessRating` *(1–5)* · `reviewNotes` · `adminOnly`
*(bool — hide from Sales Viewer)* · `reviewedBy` *(→STAFF)* · `reviewDate`

### RISKS (`R-`)
`id` · `relatedQualifierId` *(→Q, nullable)* · `relatedPlacementNeedId` *(→N, nullable)* ·
`relatedActivePlacementId` *(→P, nullable)* · `riskType` · `riskLevel` *(enum)* · `riskStatus` *(enum)*
· `owner` *(→STAFF.name)* · `dueDate` · `resolutionNotes` *(internal — hide from Sales Viewer)*

### STAFF & roles
`{ name, role }`. Roles (drive UI gating — **enforce server-side too**):
`Leadership` · `Admin` · `Placement Coordinator` · `Fulfillment` · `Sales Viewer`.
`Leadership`/`Admin` may approve; `Sales Viewer` cannot see admin-only notes, resolution notes, or approve.

---

## Enum vocabularies

| Field | Allowed values |
|---|---|
| Qualifier `status` | Active · Verified · New · Intake Started · Documents Requested · Under Review · Paused · Do Not Place Pending Review · Inactive |
| `verificationStatus` | Not Started · In Progress · Verified · Needs More Info · Failed Review · Human Review Required |
| `backgroundCheckStatus` / `creditCheckStatus` | Not Started · Pending · Clear · Review Required |
| `licenseStatus` | Active · Pending · Renewal Window · Expiring Soon · Expired · Suspended · Inactive · Unknown · Human Review Required |
| `licenseHealthStatus` | Verified Current · Renewal Window · Expiring Soon · Expired · Missing Verification · Human Review Required · Do Not Place Pending Review |
| `availabilityStatus` | Available Now · Available Soon · Limited Availability · Not Available · Paused |
| `documentStatus` | Requested · Received · In Review · Approved · Rejected · Expired · Needs Update |
| `needStatus` | Draft · Open · Under Review · Match Proposed · Match Approved · Documents Pending · Active · Ending Soon · Closed · At Risk |
| `urgencyLevel` | Low · Normal · High · Emergency |
| `adminReviewStatus` (need) | Not Reviewed · In Review · Approved to Match · Hold · Rejected · Needs More Info |
| `matchStatus` | Suggested · Possible Fit · Best Fit · Not Recommended · Pending Review · Approved · Rejected · Backup Only |
| `adminApprovalStatus` (match) | Pending · Approved · Rejected · Needs More Info · Hold |
| `placementStatus` | Pending Activation · Active · Ending Soon · Renewed · Replaced · Ended · At Risk |
| `riskLevel` | Low · Medium · High · Critical |
| `riskStatus` | Open · In Review · Resolved · Dismissed · Escalated |

---

## Recommended connection points

Direct swaps first, then cross-system wiring. Items marked **(confirm)** are questions to resolve
with the AuditEngine / ecosystem review — stated as recommendations, not assumptions.

| Entity | Live source | Notes |
|---|---|---|
| QUALIFIERS | Supabase `qualifiers` + CRM (Zoho) contact link | `email`/`phone` are PII → behind RLS. `readiness` is **derived** — compute in a view/function, don't store the parts. |
| LICENSES | Supabase `licenses`, **verification fed by state boards** | `verificationSource` + `lastVerifiedDate` should come from the licensing-domain monitor (FL DBPR, TX TDLR, CA CSLB, AZ ROC, GA/NC/NY boards…) via Rose OS / AuditEngine. `licenseHealthStatus` is derived from status + expiry + verify recency. |
| AVAILABILITY | Supabase `availability` (1:1) | `currentPlacementCount` should be derived from active PLACEMENTS, not hand-set. |
| DOCUMENTS | **DocumentCollection** system | `fileLink` uses a `vault://` scheme → resolve against the governed document vault. Screening docs are **status-only** (`vault://status-only`) — never store reports/PII. QMOS should be a read/status **consumer** of DocumentCollection. **(confirm)** field mapping. |
| NEEDS | CRM / intake pipeline | Company demand. `adminReviewStatus` gates whether a need is eligible to match. |
| MATCHES | Matching engine → QMOS records the **human decision** | The engine (Rose OS / matching logic) supplies candidates + `fitScore` + `factors`; QMOS owns `adminApprovalStatus`/`reviewedBy`/`reviewedDate`. **Never auto-approve.** |
| PLACEMENTS | Supabase `placements` + finance/invoicing | `monthlyFee` / `ccaMonthlyFee` / `qualifierMonthlyCompensation` feed the Reports revenue figures (currently placeholders). |
| REVIEWS | Supabase `reviews` | Performance history; feeds `readiness` "review record". |
| RISKS | Risk register — **align with AuditEngine risk model** | `riskType` / `riskLevel` should reconcile with AuditEngine's taxonomy. **(confirm)** whether these are QMOS-native or mirrored from AuditEngine. |
| STAFF / roles | Auth (Supabase RLS / SSO) | UI role gating must be mirrored by row-level security server-side. |

### Cross-system ID mapping (decided — 2026-07-29)

DocumentCollection is described as *keyed on the universal matrix identifiers* and a *read-only
consumer of AuditEngine*. QMOS currently uses its own `Q-`/`L-`/`N-`/… keys.

**Decision: QMOS keeps its friendly IDs as stable primary keys. AuditEngine / universal matrix
identifiers live in nullable `external_id` columns on the synced tables.** Concretely:

| QMOS table | PK (unchanged) | New nullable column | Populated when |
|---|---|---|---|
| `qualifiers` | `id` = `Q-###` | `auditengine_id` (uuid, unique, nullable) | Row is first synced to AuditEngine |
| `licenses` | `id` = `L-###` | `auditengine_id` (uuid, unique, nullable) | Row is first synced to AuditEngine |
| `placements` | `id` = `P-###` | `auditengine_id` (uuid, unique, nullable) | Row is first synced to AuditEngine |
| `needs` | `id` = `N-###` | `auditengine_id` (uuid, unique, nullable) | Row is first synced to AuditEngine |
| `risks` | `id` = `R-###` | `auditengine_id` (uuid, unique, nullable) | If risk mirrors an AuditEngine risk |

**Why this shape.**

1. **QMOS keys are already threaded through every screen** — URLs, tooltips, exports, admin notes,
   internal reports. Swapping them out for UUIDs would break the UI's IA and every staff shortcut.
2. **QMOS is the downstream consumer.** AuditEngine and DocumentCollection are the systems of
   record for compliance events; QMOS mirrors what it needs. A nullable `external_id` on the
   downstream table is the standard shape for that relationship.
3. **One-to-one until proven otherwise.** Every qualifier in QMOS corresponds to at most one
   AuditEngine contractor record. Same for licenses, placements, needs. If we ever hit a
   many-to-many case (e.g., a QMOS placement spanning two AuditEngine engagements), we add a
   mapping table then — not now.
4. **Reversible.** Nullable columns cost nothing while empty. If we later decide to adopt the
   universal matrix ID as PK, the migration is: backfill `external_id`, then swap.

**Rules.**

- Every sync-eligible write to `qualifiers` / `licenses` / `placements` / `needs` publishes a
  sync event; the sync worker attaches `auditengine_id` on first success and never mutates it
  afterward.
- QMOS never accepts an AuditEngine ID as a URL parameter or lookup key from the UI. Staff work
  in QMOS keys; the mapping is server-side.
- Read paths from AuditEngine / DocumentCollection resolve to QMOS keys via the `external_id`
  index before hydrating the UI.
- `external_id` is nullable so QMOS records can exist before (or without) an AuditEngine
  counterpart — e.g., intake-stage qualifiers.

**Deferred to a follow-up decision** (not blocking Phase 1 wiring):

- Whether `matches` needs an `external_id` — depends on whether AuditEngine tracks candidate
  proposals or only approved placements.
- Whether `documents` mirrors DocumentCollection IDs directly or resolves via the qualifier's
  `external_id`. Current lean: resolve via qualifier, since DocumentCollection is the read-only
  source and QMOS holds statuses only.

### Write paths to wire (currently local state)
- `approveMatch(id, status)` → update `MATCHES.adminApprovalStatus` + `reviewedBy` + `reviewedDate` (audit-logged).
- `setRisk(id, status)` → update `RISKS.riskStatus` (audit-logged).

Both must write to an **append-only audit trail** — the UI already states every decision is logged
and requires human review before external use.
