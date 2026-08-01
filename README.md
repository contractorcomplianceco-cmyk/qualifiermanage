# QualifierManageOS

**CCA internal command center** for managing qualified individuals ("qualifiers") CCA places into
company license/compliance roles — across **licensing, compliance, availability, matching, active
placements, documents, and risk**.

Staff-only app (`[INTERNAL ONLY]`) with a live Supabase backend (schema → RLS → allowlist auth →
hydrate/API → base + bulk seed). Sync integrations and client/partner go-live remain **held**.

> Part of the CCA ecosystem (Contractor Compliance Authority / Compliance Authority Group).
> Adjacent to QualifierConnect, DocumentCollection, and the AuditEngine / Rose OS compliance engine.

---

## What's in this repo

| Path | What it is |
|---|---|
| `QualifierManageOS.dc.html` | The staff UI (markup + logic). Login + hydrate from Supabase. |
| `coverage-map.html` | Coverage Map iframe — SVG US map (density, bench pins, gap dots) fed by hydrate payload. |
| `qmos-api.js` | **Live data seam.** Supabase client: login, `hydrate()`, `approveMatch`, `setRisk`. |
| `qmos-config.js` | Supabase URL + anon key (public client config only — never service_role). |
| `data.js` / `data.base.js` / `data.bulk.js` | Seed generators / reference shape used to build migrations `0009`/`0012`. Not the runtime source. |
| `migrations/` | Append-only SQL + proposals. Live journal tip: `0012_seed_bulk_v1`. |
| `support.js` | Runtime that renders the `.dc.html` file. Generated — do not edit. |
| `assets/` | Logo lockup + emblem (navy/teal). |
| `_ds/cca-design-system-.../` | Bound **CCA Design System** tokens + components. |
| `DATA_MODEL.md` | Entity/field/FK contract and connection points. |
| `RDC_LOG_qualifiermanageos.md` | Rose-Directed Changes log (empty until Rose rows land). |

---

## How to run it

Must be **served over HTTP** (ES modules + assets):

```bash
npx serve .
# open QualifierManageOS.dc.html
# staff preview (when deployed): https://qualifiers.cagteam.net
```

Sign in with a provisioned staff Auth account (public signup is off). See
`migrations/AUTH_PROVISIONING.md`.

---

## Data seam (live)

```js
import * as api from './qmos-api.js';
// login → api.hydrate() returns:
// { TODAY, STAFF, CITIES, QUALIFIERS, LICENSES, AVAILABILITY, DOCUMENTS,
//   NEEDS, MATCHES, PLACEMENTS, REVIEWS, RISKS, COVERAGE_GAPS }
```

**Writes (audited RPCs):**
- `approveMatch(id, status)` → `qmos_approve_match` + `decision_audit_log`
- `setRisk(id, status)` → `qmos_set_risk` + `decision_audit_log`

Client debounce prevents double-submit audit rows. Nothing auto-approves.

---

## Governance invariants

1. **Nothing auto-approves.** Match scores are decision support only.
2. **Do-Not-Place holds are absolute.**
3. **Screening is status-only** — never reports or sensitive PII.
4. **Role-based visibility.** Admin-only notes / resolution notes / admin_only reviews hidden from Sales Viewer.

## Honest stubs (still toast-only)

- Export / Add qualifier / remind / portal actions — not wired.
- Reports finance figures — placeholders until finance wiring.
- Sync seams (AuditEngine / Docs Collect / Zoho) — **OFF** (proposal only).

## Approval lanes

| Lane | Status |
|---|---|
| Staff preview | YES |
| Client / partner share | **NO** |
| Public / DNS go-live | **NO** |
