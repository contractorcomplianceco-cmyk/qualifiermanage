# QualifierManageOS

**CCA internal command center** for managing qualified individuals ("qualifiers") CCA places into
company license/compliance roles — across **licensing, compliance, availability, matching, active
placements, documents, and risk**. Phase-1 prototype, built to map cleanly onto a real backend.

> Part of the CCA ecosystem (Contractor Compliance Authority / Compliance Authority Group).
> This is the qualifier-management surface — adjacent to QualifierConnect, DocumentCollection,
> and the AuditEngine / Rose OS compliance engine.

---

## What's in this repo

| Path | What it is |
|---|---|
| `QualifierManageOS.dc.html` | The entire app — one self-contained UI component (markup + logic). 13 sections. |
| `coverage-map.html` | Standalone iframe mounted inside the app's Coverage Map view. Renders a live SVG US map (density shading + available-bench pins + coverage-gap dots) driven off `data.js`. |
| `data.js` | **The data layer.** ES module that composes `data.base.js` + `data.bulk.js` and exports the seed database as 11 collections. This is the contract to wire to a real backend. |
| `data.base.js` | Reviewed Phase-1 base seed (roles, roster, roles' first placements/needs/risks). |
| `data.bulk.js` | Procedurally generates ~1,000 licenses + qualifiers + docs at module load time so the Licenses register carries production-scale volume. Deterministic (seeded), same shape as `data.base.js`. |
| `support.js` | Runtime that renders the `.dc.html` file in a browser. Generated — do not edit. |
| `assets/` | Logo lockup + emblem (navy/teal). |
| `_ds/cca-design-system-.../` | The bound **CCA Design System** (tokens + component bundle). Provides `var(--*)` tokens and styling. |
| `DATA_MODEL.md` | **Read this for connections.** Every entity, field, enum, foreign key, and where each should connect to a real source. |

---

## How to run it

It uses ES-module dynamic `import()` and loads stylesheet/asset files, so it must be **served over
HTTP** (not opened as a `file://` path):

```bash
npx serve .        # or:  python3 -m http.server
# then open the printed URL and navigate to QualifierManageOS.dc.html
```

No build step, no npm install. It's plain HTML + a runtime script.

---

## The one thing to know for wiring connections

**All data enters the UI at a single seam.** In `QualifierManageOS.dc.html`, the logic class does:

```js
componentDidMount() {
  import('./data.js').then(m => this.setState({ db: m }));
}
```

`data.js` is explicitly shaped to **map 1:1 onto a Postgres/Supabase schema**. To go live, replace
that import with real fetches that return the **same shape** (`{ QUALIFIERS, LICENSES, AVAILABILITY,
DOCUMENTS, NEEDS, MATCHES, PLACEMENTS, REVIEWS, RISKS, STAFF, TODAY }`) — **the UI needs no other
changes**. See `DATA_MODEL.md` for the full contract and recommended source system for each entity.

**Writes** are only two actions, held in component state (`matchOverrides`, `riskOverrides`) and
mirrored into `localStorage` under key `qmos.prototype.overrides.v1` so decisions survive reload
within a browser session. These are the mutations to point at the backend:
- **Match approval** — `approveMatch(id, status)` sets `adminApprovalStatus` + reviewer + date.
- **Risk status change** — `setRisk(id, status)` updates `riskStatus`.

The prototype's decision toasts are honestly scoped: they say *"Decision recorded (prototype session
— backend audit log lands with Phase 1 wiring)"* rather than claiming a durable audit trail. Phase
1 wiring replaces the `localStorage` mirror with real POSTs + a server-side audit log.

---

## Fidelity

**Hi-fi.** Final colors, typography, spacing, and interactions come from the CCA Design System
(navy `#13233F` + teal `#0B8E8E`, Sora/Inter/IBM Plex Mono). Recreate pixel-for-pixel in the target
stack (React + TypeScript + Tailwind v4 + Supabase, per CCA's stack) using its existing components.

## Governance invariants (must survive any rebuild)

1. **Nothing auto-approves.** Every match and placement requires a named human (Admin/Leadership)
   approval before external use. Match scores are *decision support only*.
2. **Do-Not-Place holds are absolute** — a qualifier under review cannot be matched out.
3. **Screening is status-only.** Background/credit checks store a *status* (Clear / Pending /
   Review Required) — **never reports or sensitive personal information.**
4. **Role-based visibility.** Admin-only notes and resolution notes are hidden from the Sales Viewer
   role. Approvals are gated to Admin & Leadership.

## Honest prototype stubs (not yet wired)

- **Export** and **Add qualifier** buttons are no-ops (toast only).
- **Reports** timing/revenue figures are placeholders — labeled in-app "until finance wiring lands."
- **Match approvals** and **risk status changes** persist to `localStorage` only — real audit log lands with Phase 1 backend wiring. Toast copy is scoped to say so.
- All figures are computed live from `data.js` seed data.
