# CCA Design System

The design system for **Contractor Compliance Authority (CCA)** — the first, live vertical of
**Compliance Authority Group, Inc. (CAG)**. CCA is a full-spectrum contractor compliance
platform that monitors **licensing, DOT/FMCSA, OSHA, DOR (state tax), SOS (entity), and
government contracting** for contractors across all 50 states — *"powered by AI, executed by
experts."*

> **CCA promise:** *Your License. Our Expertise. Your Success.*
> **CCA positioning:** *Setting the Standard for Contractor Compliance.*
> **Headline voice:** *Contractor compliance, handled.* · *Stay licensed. Stay protected. Grow your business.*
> **Parent (CAG):** *One Standard. Every Industry. Total Compliance.*

---

## 1 · Company & product context

**Compliance Authority Group, Inc. (CAG)** is the **parent company** — *"One Standard. Every
Industry. Total Compliance."* CAG owns the shared technology, the compliance engine (Rose OS),
and the brand architecture, and licenses them to a family of industry-specific
**"…Compliance Authority"** verticals. **CCA proves the model; every other vertical inherits it.**

CCA's wedge: the contractor-compliance market is **$2.8B (2025), growing 9.4%/yr to a projected
$6.2B by 2034**, with **3.8M+ U.S. contractor businesses** — and *no single platform monitors all
six risk domains together.* CCA is built to own that white space: the only platform that watches
Licensing + DOT + OSHA + DOR + SOS + Gov-Contracting simultaneously, with human expert oversight.

### The CAG vertical family
Each vertical reuses the same shield + `[X]CA` lockup grammar and the **navy + teal** system;
only the industry word changes. Status per the partner briefing:

| Vertical | Industry | Status |
|---|---|---|
| **CCA — Contractor Compliance Authority** | Contractor licensing & full-spectrum compliance | **LIVE** (first vertical) |
| **PCA — Provider Compliance Authority** | Healthcare credentialing | **NEXT** (2027) |
| **Transportation Compliance Authority** | Trucking / DOT | Roadmap (2028+) |
| **Cannabis Compliance Authority** | Cannabis | Roadmap (2028+) |
| **Global Compliance Authority** | Immigration | Roadmap (2028+) |

> All verticals share one technology stack, one compliance engine, and one brand system.
> This design system is authored **CCA-first**; reskinning to another vertical is a matter of
> swapping the industry word in the lockup (the accent stays teal unless a vertical defines its own).

### The CCA product ecosystem
Every product feeds the next — clients don't buy a service, they enter a compliance
infrastructure. The methodology runs **DISCOVER → MANAGE → VERIFY**:

| Phase | Product | What it is |
|---|---|---|
| **DISCOVER** | **CCA Compliance Risk Audit™** | Core entry service. Full-spectrum audit across all 6 domains; delivers a **CCA Compliance Risk Score**. Starts with a free *Preliminary Compliance Exposure Review*. |
| **MANAGE** | **CCA ComplianceConnect** | The flagship **SaaS portal** — live compliance intelligence: deadline tracking, renewal alerts, multi-state filing, DOT/OSHA/DOR/SOS monitoring, registered-agent services. Core ARR driver. |
| **VERIFY** | **Contractor Trust Score** | CCA's contractor-facing verification metric + third-party trust badge; ISNetworld/Avetta credentialing, gov-contracting readiness, MBE/WBE/VOBE. |
| (CRM) | **CCA ContractorConnect** | Contractor-facing client portal — status tracking, document management, communication. |
| (Marketplace) | **CCA BuildConnect** | Licensed-contractor **marketplace** connecting GCs/owners with verified, compliant contractors (transaction + listing fees). |
| (Network) | **CCA QualifierConnect** | Two-sided **marketplace** connecting companies with verified, background-checked **qualifying agents**. |
| (AI tool) | **CCA BidIntelligenceOS** | Bid-intelligence platform surfacing government-contracting opportunities matched to a contractor's compliance profile. |
| (Engine) | **Rose OS** | Proprietary AI **compliance knowledge engine** powering all of the above — *AI-powered, reviewed by humans.* 24/7 regulatory monitoring, the risk-scoring algorithm, URGENT/WATCH/OK alert prioritization, multi-state sync. |

### The six compliance domains (the core data model)
Everything CCA scores, tracks, and renders pivots on these six domains. Each gets a 0–100 risk
score and an URGENT / WATCH / OK status:

1. **Licensing Boards** — renewals, CE, exams, reciprocity, enforcement (all 50 states)
2. **DOT / FMCSA** — HOS, CDL, drug & alcohol, operating authority, IFTA, inspections
3. **OSHA** — construction & general-industry standards, 300/300A, citations, penalties
4. **DOR / State Tax** — sales-tax nexus, payroll, entity obligations, subcontractor withholding
5. **SOS / Entity** — annual reports, registered agent, entity standing, revocation risk
6. **Government Contracting** — SAM.gov, 8(a)/HUBZone, Davis-Bacon prevailing wage, MBE/WBE/VOBE

### Tech stack (build UI kits to match)
Per the briefing, the product is a modern React SaaS — recreations should feel native to it:
**React + TypeScript + Tailwind CSS v4**, **Supabase** (Postgres + RLS), **Vercel** edge hosting,
**Zoho CRM**, **GA4**, and the **Rose OS** AI engine (+ Perplexity API for data intelligence).

### Traction & headline numbers (for realistic mock data)
10,000+ contractors served · 98% client success rate · 15+ years in compliance · 50 states.
Market context: 3.8M+ contractors · $2.8B market · 9.4% CAGR · $201M OSHA fines (FY2025) ·
$16,550 per OSHA violation. Priority states: **FL** (home market), **TX**, **CA**, **GA**,
**NC**, **NY**. Example dashboard reading: *Score 74 · 3 Alerts · 12 States* with domain bars
*Licensing 72 · DOT 88 · OSHA 91 · DOR 55 · SOS 67 · Gov't 82.*

### Sources provided
- **`assets/brand/cca-brand-awareness.pdf`** — the canonical CAG/CCA partner briefing (this is
  the authority for product names, domains, methodology, stack, and traction above).
- **`assets/brand/cca-brand-inspiration.pdf`** — competitive/brand-strategy analysis (Harbor,
  NCL, API Processing, Northwest) with the color/type/voice recommendations CCA adopted
  (navy + teal, 100% sans-serif, Inter/Sora, problem-contrast headlines, anti-promise copy).
- **`assets/logos/*`** — the 2026 flat-vector + metallic CCA logo suite (navy + teal).
- **`assets/brand/cag-brand-family.png`**, `roseos-brand-board.png` — earlier brand boards.
- Live site referenced in the briefing: **contractor-compliance-authority.com** (not fetched here).

> ⚠️ Earlier source uploads included a divergent **pink "RoseOS Collab"** mock and a
> *"Pricing/Quote/Proposal"* internal tool — neither appears in the canonical briefing. They are
> treated as **off-brand / superseded**. The real engine is **Rose OS** (navy + teal); the real
> SaaS surface is **ComplianceConnect**.

---

## 2 · Content fundamentals

**Voice:** authoritative expert — *confident, calm, contractor-specific.* CCA speaks like a
trusted advisor who happens to be the regulator-grade expert. Never hype, never legalistic.
The throughline is **trust through accuracy**, and the differentiator is *full-service AND
software, exclusively for contractors.*

- **Person:** addresses the contractor as **"you / your"**; CCA is **"we / CCA."**
  *"CCA manages every license, deadline, and filing — so you never lose work to a lapse."*
- **Own the word "only / exclusively."** CCA's category claim is ownership: *"the only platform
  that monitors all six compliance domains, for every contractor, in every state."*
- **Problem-contrast headlines.** Name the tension, resolve it in one breath:
  *"Contractor compliance, handled."* · *"Non-compliance has a cost. We make sure you never pay it."*
- **The benefit triad** (rule of three, hard stops): **Stay Licensed · Avoid Penalties · Grow Confidently.**
  Also *Discover · Manage · Verify* and CAG's *One Standard. Every Industry. Total Compliance.*
- **Anti-promises** (define the brand by what it refuses to do): *"No compliance surprises — we
  track every deadline before you do." · "No abandoned applications — we stay until you're approved."
  · "No generic checklists — we handle your specific state requirements."*
- **Proprietary, trademarked language.** Capitalize the system names: **CCA Compliance Risk
  Audit™**, **Contractor Trust Score**, **Rose OS**, **CCA ComplianceConnect**, **BuildConnect**,
  **QualifierConnect**, **BidIntelligenceOS**, **Preliminary Compliance Exposure Review**.
- **Casing:**
  - **ALL-CAPS, letter-spaced eyebrows** label every section (`THE PROBLEM`, `MARKET OPPORTUNITY`,
    `THE PLATFORM`, `COMPETITIVE MOAT`). This is a signature device — use `--tracking-widest`.
  - **Title Case** for headings, nav, product names.
  - **Sentence case** for body and helper text.
- **Numbers carry weight.** Scores, %, dollars, state counts and domain bars are first-class —
  shown big, in the display face, often as a ring or KPI tile. Risk status is **URGENT / WATCH / OK**.
- **Compliance honesty.** The free entry point is a *Preliminary Exposure Review*; the audit is
  paid. State limits plainly; trust is built by precision, not promises of guaranteed outcomes.
- **Emoji:** **none.** Status is shown with iconography (shields, checks, status dots), not emoji.
- **Vibe:** institutional authority fused with modern SaaS clarity — the Harbor Compliance of
  the contractor market, but warmer and contractor-exclusive.

---

## 3 · Visual foundations

**Overall feel:** institutional authority meets modern compliance console. A classical **pillar**
(rule of law) stands inside a **shield** (protection) struck through by a **teal checkmark**
(verification). Two render modes coexist:

- **Light mode** (default) — clean React/Tailwind SaaS: near-white `--surface-page`, white cards,
  deep-navy text, crisp low-spread shadows, teal accents. The product + marketing default.
- **Dark "console" mode** — deep navy (`--navy-950` #08101c) with teal glows and luminous ring
  charts. Used for hero/pitch surfaces and data-dense dashboards. Toggle via `[data-theme="dark"]`.

### Color (navy + teal)
- **Deep Navy `#13233F`** — primary brand & headings; structure, text, the anchor of every surface.
- **CCA Teal `#0B8E8E`** — primary accent: the checkmark, links, active states, data, focus rings.
  *(Teal differentiates CCA from the navy+orange/red that Harbor, API, and NCL all use — it reads
  SaaS-adjacent and "compliance + growth," exactly the recommended position.)*
- **Steel Slate `#5B6675`** — neutral text/secondary; root of the gray scale.
- **Chrome / silver gradient** — the **metallic 3-D logo crest only**; not a UI fill.
- **Semantic:** success green `#1F9D55` (OK / verified / on-track), warning amber `#E8A33D`
  (WATCH / pending), danger red `#E23B2E` (URGENT / overdue / risk).
- **Authority Red `#C8102E`** — sparing emphasis only; teal is the primary action color.
- **Imagery color vibe:** the brand guidance steers **away from hard-hat stock photography**
  (every competitor uses it — it's invisible) toward **product-UI screenshots + illustrated state
  maps / data-viz**. When photography is used, keep it cool, corporate, architectural — navy/teal
  graded, never warm or grainy.

### Logo
- **Primary lockups** (flat vector, `assets/logos/`): `cca-lockup-horizontal.png`,
  `cca-lockup-vertical.png`, `cca-wordmark.png` (CCA with the teal check finishing the **A**),
  `cca-shield.png` (flat navy/teal/white shield), `cca-badge.png` (circular badge).
- **Metallic / 3-D crests** (hero & print only): `cca-crest-metallic.png`, `cca-crest-stacked.png`,
  `cca-horizontal-metallic.png` — chrome-silver with teal; for covers/awards, never a small UI mark.
- The mark = **navy shield + classical pillar + teal swoosh checkmark.** Tagline lockup:
  *YOUR LICENSE.  OUR EXPERTISE.  YOUR SUCCESS.* (letter-spaced caps).

### Type
- **Sora** — display / headings / hero / big stat numerals (geometric sans, heavy weights 700–800).
- **Inter** — body & product UI (the React + Tailwind v4 working face; weights 400–700).
- **IBM Plex Mono** — scores, risk codes, deadlines, IDs, data labels.
- Eyebrows/labels are ALL-CAPS at `--tracking-widest`; headings are tight (`--tracking-tight`),
  heavy weight. Hierarchy comes from **weight contrast within one family**, not font variety.
- *Per brand guidance:* the system is **100% sans-serif**, heavy headlines. Headlines may also be
  set in **Inter 800** (the documented primary); **Sora** is used here as the more distinctive
  display option. *Substitution note: the logo's custom condensed face is approximated by these
  Google Fonts — provide the real display face to replace.*

### Spacing, radii, borders
- **4px grid** (`--space-*`). Generous card padding (20–24px).
- **Restrained radii:** KPI tiles & cards `--radius-lg` (12px), controls `--radius-md` (8px),
  pills/chips full, score rings & avatars circular. Nothing over-rounded.
- **Borders** hairline (`--gray-100/200` light; translucent white on dark). Cards lean on shadow
  in light mode, on subtle borders + teal glow in dark mode.

### Backgrounds & texture
- Light: flat near-white / soft teal-tinted insets (`--teal-50`). No gradients on content.
- Dark: deep navy with faint architectural blueprint/wireframe line art and radial **teal glows**
  behind hero panels; diagonal navy facets on covers and cards.
- **No** purple gradients, no emoji cards, no rainbow. Restrained, corporate, precise.

### Elevation, shadow & glow
- **Light:** crisp, low-spread navy-tinted shadows (`--shadow-sm` resting, `--shadow-md` hover).
- **Dark:** `--glow-teal` halos on active/important panels; `--shadow-dark` for layering.
- **Score rings** (Compliance Risk Score, Contractor Trust Score) are a signature motif — a
  circular progress arc colored by status (teal/green OK → amber WATCH → red URGENT) with the
  number centered in the display face. **Domain bars** (six 0–100 rows) are the other signature.

### Motion, hover & press
- **Motion:** precise and confident — short (120–280ms), eased (`--ease-standard`), **no bounce**.
  Fades and small translateY reveals; nothing playful.
- **Hover:** buttons darken one accent step (teal-500 → teal-600); cards lift to `--shadow-md`
  (light) or gain a teal glow (dark); links brighten.
- **Press:** subtle `scale(0.98)` + one step darker. Focus is always a visible `--ring-focus`
  (3px teal at 35%).

### Cards
- Light card: white, `--radius-lg`, `--border-subtle`, `--shadow-sm`; header row with a small
  navy/teal line icon + Title-Case title, often a right-aligned "View all →" link.
- Dark card: navy fill (`--surface-card` dark), translucent border, optional teal glow when active.
- KPI / domain tile: caps label (muted) → big number (display) → status line (URGENT/WATCH/OK or ↑/↓ delta).

---

## 4 · Iconography

- **Style:** clean **line (outline) icons**, ~1.75–2px stroke, rounded joins, 24px grid — matching
  the stroke weight across the CCA UIs (shield-check, document-check, gauge/score, calendar/deadline,
  truck (DOT), hard-hat (OSHA), building/bank (SOS), receipt (DOR), file-badge (gov contracting)).
- **Brand glyphs:** the **shield + pillar + checkmark** crest is the hero mark; a standalone
  **shield-check** is the recurring trust/verification glyph; the **score ring** is the data motif.
- **No emoji. No multicolor/3-D icons in UI** (the metallic crest is hero/print only). In-product:
  flat navy / teal / slate line icons.
- **Implementation:** the brand guidance calls for a **custom icon set** (competitors that invest in
  custom icons read as more premium). Until that set ships, this system uses **[Lucide](https://lucide.dev)**
  via CDN — 24px / 2px rounded outlines, the closest match. *(Substitution flagged — swap for the
  in-house set when provided.)* Load `<script src="https://unpkg.com/lucide@latest"></script>`
  then `lucide.createIcons()`.

---

## 5 · Index / manifest

**Root**
- `styles.css` — global entry (import this). `@import`s everything below.
- `tokens/` — `fonts.css`, `colors.css`, `typography.css`, `spacing.css`, `elevation.css`.
- `assets/logos/` — 2026 CCA logo suite (flat-vector + metallic; navy + teal).
- `assets/brand/` — `cca-brand-awareness.pdf` (canonical briefing), `cca-brand-inspiration.pdf`
  (strategy/competitive analysis), `cag-brand-family.png`, `roseos-brand-board.png`.
- `SKILL.md` — Agent-Skills-compatible entry for downloaded use.

**Foundations cards** (Design System tab → Type / Colors / Spacing / Brand) — `guidelines/`.

**Components** (`components/`, namespace `window.CCADesignSystem_001d63`) — *planned*
- `core/` — Button, IconButton, Badge, Tag, Avatar, Logo
- `forms/` — Input, Select, Checkbox, Switch
- `data/` — StatCard, ScoreRing, DomainBar, StatusPill, DataTable
- `layout/` — Card, SectionHeader, Tabs, SidebarNav, Topbar

**UI kits** (`ui_kits/`) — *planned*
- `complianceconnect/` — the ComplianceConnect SaaS dashboard (score, alerts, domain monitoring).
- `marketing/` — contractor-compliance-authority.com hero + benefit triad + audit CTA.
- `business_cards/` — CCA stationery concepts (built; navy + teal).

*(Components and the ComplianceConnect/marketing kits are the next build targets, now that the
canonical product architecture is documented above.)*
