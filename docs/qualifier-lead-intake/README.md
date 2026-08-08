# Qualifier Lead Intake & Future Verified Qualifier Architecture

**Status:** `[PROPOSAL]` · design lane only · **no build / no public form / no seams ON**  
**Audience:** `[INTERNAL ONLY]`  
**Handoff type:** INCREMENTAL design add-on to QualifierManageOS staff work  
**Authorized by Rose:** 2026-08-01 — “Qualifier Lead Intake and Future Verified Qualifier Architecture”  
**Base tip:** `main` @ `fd458156c0434abe77ec8dedc8482f7da3ea1a3f`  
**Design branch:** `cursor/qualifier-lead-intake-design-97db`  
**Redlines (2026-08-08):** C-1 identity hold · C-2 RS-001/RS-002 §7.1a · C-3 Contract C envelopes — awaiting Rose re-review / §13 picks

---

## What this package is

One connected **architecture + contracts** package for qualifier acquisition → Core identity → QMOS reflection → RoseOS orchestration → AuditEngine knowledge → future QualifierConnect continuation.

It is **not** a standalone QualifierManageOS public form and **not** authorization to activate intake, sync, webhooks, applicant accounts, or QualifierConnect.

---

## Locked ownership (Rose)

| System | Owns |
|---|---|
| **FormsConnect** | Form definition, fields, conditionals, branding, publish controls, consent language, versioning, submission UX |
| **ComplianceCore** | Primary identity SoT; mints Core profile ids (server-side resolve for consumers) |
| **QualifierManageOS** | Qualifier-domain reflection (`Q-###`); **no** Core identifier column until ID-001 / Registry §4a re-decide |
| **RoseOS** | Workflow, routing, prioritization, recommendation rules after submit |
| **AuditEngine** | Regulatory / license / trade / jurisdiction / risk / compliance knowledge (no QMOS recreation of AE scoring) |
| **QualifierConnect** | Future qualifier-facing portal — design handoff only in this lane |

---

## Hard stops (this lane)

- No public form activation  
- No webhooks / external writes  
- No sync activation (seams stay OFF)  
- No applicant accounts  
- No QualifierConnect build  
- No “Verified” status from submit alone  
- No destructive migrations  
- Form changes must **not** require editing QMOS code  

---

## Alignment with live QMOS

| Anchor | How this design uses it |
|---|---|
| `DATA_MODEL.md` Option A | Keep friendly `Q-` PKs; nullable unique `auditengine_id` for AE mapping |
| Core link | **On hold** (Registry §4a / ID-001) — no `cca_client_profile_id` on QMOS tables; server-side resolve only |
| Existing status enums | Map lead / verification / placement stages onto `status` + `verification_status` + proposed intake fields — see §5 |
| Sync proposal | Complements `migrations/SYNC_INTEGRATIONS_V1_PROPOSAL.md`; intake does **not** turn seams on |
| Live journal | Through `0012_seed_bulk_v1` — do not reapply unless Rose says |

---

## Package contents (Rose’s 13 returns)

| # | Deliverable | Location |
|---|---|---|
| 1 | End-to-end architecture + sequence flow | [ARCHITECTURE.md](./ARCHITECTURE.md) §1 |
| 2 | FormsConnect form design + conditional field map | [ARCHITECTURE.md](./ARCHITECTURE.md) §2 |
| 3 | Standard Lead vs Verified Qualifier journey | [ARCHITECTURE.md](./ARCHITECTURE.md) §3 |
| 4 | ComplianceCore identity + upsert contract | [ARCHITECTURE.md](./ARCHITECTURE.md) §4 |
| 5 | QMOS reflection + status model | [ARCHITECTURE.md](./ARCHITECTURE.md) §5 |
| 6 | RoseOS routing + recommendation responsibilities | [ARCHITECTURE.md](./ARCHITECTURE.md) §6 |
| 7 | AuditEngine knowledge inputs/outputs | [ARCHITECTURE.md](./ARCHITECTURE.md) §7 |
| 8 | Future QualifierConnect claim/continuation | [ARCHITECTURE.md](./ARCHITECTURE.md) §8 |
| 9 | Duplicate-resolution rules | [ARCHITECTURE.md](./ARCHITECTURE.md) §9 |
| 10 | Consent, privacy, audit requirements | [ARCHITECTURE.md](./ARCHITECTURE.md) §10 |
| 11 | Required migrations, APIs, dependencies | [ARCHITECTURE.md](./ARCHITECTURE.md) §11 |
| 12 | Proposed implementation phases | [ARCHITECTURE.md](./ARCHITECTURE.md) §12 |
| 13 | Exact decisions still needed from Rose | [ARCHITECTURE.md](./ARCHITECTURE.md) §13 |

---

## Three approval lanes (unchanged by this design)

| Lane | Status |
|---|---|
| Staff preview (existing QMOS UI) | YES (already live) |
| Partner-share | **NO** |
| Public form / DNS go-live | **NO** — design only |

---

## Related SoT

- `DATA_MODEL.md` — entity enums + Option A `auditengine_id`  
- `migrations/SYNC_INTEGRATIONS_V1_PROPOSAL.md` — sync seams (still OFF)  
- `migrations/README.md` — journal tip `0012`  
- Staff preview: https://qualifiers.cagteam.net · `[INTERNAL ONLY]`
