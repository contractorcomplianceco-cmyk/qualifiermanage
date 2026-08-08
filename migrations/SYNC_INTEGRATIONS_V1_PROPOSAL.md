# QualifierManageOS — Sync integrations v1 (proposal only)

**Status:** Slice A **approved to author** (Rose 2026-08-07) · artifacts under `docs/sync-integrations/` + `0014_…PROPOSED` · **not applied · no seams ON**  
**Audience:** `[INTERNAL ONLY]`  
**Trigger for this doc:** Rose 2026-07-30 — “hasn’t been scoped yet; send quick proposal before building”  
**Depends on:** live QMOS through `0012`  
**Seams today:** OFF (nullable `auditengine_id` columns exist; no sync worker, no outbound calls)  
**Slice B:** gated on ID-001 · Contract C required for any future emit (Registry §2.2)

---

## Goal (one sentence)

Define **which systems** talk to QMOS, **which way** data flows, and **what triggers** a sync — so Rose can approve a thin first slice later without inventing wiring now.

---

## Candidate systems (from DATA_MODEL + standing CCA rules)

| System | Role vs QMOS | Direction (proposed) | What would sync | Trigger (proposed) | Priority ask |
|---|---|---|---|---|---|
| **AuditEngine / CCA core scoring** | Upstream compliance / risk taxonomy | **In** to QMOS (mirror approved facts); QMOS may **out** publish placement/qualifier events for mapping | License health signals, risk taxonomy alignment, attach `auditengine_id` on first success | Event on QMOS write to sync-eligible tables **or** scheduled pull of approved results | **P1 candidate** — columns already Option A |
| **DocumentCollection (Docs Collect)** | Document / screening status SoT | **In** only (QMOS consumer) | Document status, vault link refs (`vault://…`); never screening report PII | Webhook or poll when doc status changes for a linked qualifier/license | **P1 candidate** — UI already shows document rows |
| **CRM / Zoho (transitional)** | Contact / company demand reference | **In** optional for needs/contacts; **no Zoho writes** from QMOS unless Rose/Carmen explicitly approve | Company/contact fields on `needs`; optional qualifier contact link | Manual staff link + rare CRM change webhook — not client-facing workflows | **P2 / transitional** — do not make Zoho SoT |
| **Finance / invoicing** | Placement fee truth | **In** for paid/late flags that feed risk “Payment Issue”; later **out** for invoice stubs | Payment status → risk / placement notes | Invoice paid/overdue event | **P3** — reports still placeholder |
| **Matching engine (Rose OS)** | Candidate + fitScore supplier | **In** candidates; QMOS owns human approve | Match candidates, `fitScore`, `factors` | Engine emits candidate set for a need | **P2** — UI already records human decision only |
| **Business Hub** | Account/workflow facts | Not QMOS core | — | — | **Out of scope** unless Rose names a need |
| **ComplianceConnect portal** | Client-facing approved outputs | **Never** via this sync slice | — | — | **HOLD** — client/partner go-live blank lanes = NO |

---

## Direction rules (proposed defaults)

1. **QMOS stays staff placement command center** — not the ecosystem master profile.  
2. **Friendly IDs stay PKs** (`Q-` / `L-` / …); foreign systems map via nullable `auditengine_id` (already in schema).  
3. **No auto-approve** of matches from any sync.  
4. **No client/partner surface** and **no seam ON** until separate Lane approvals.  
5. **Zoho = transitional reference only** — no client workflow that depends on Zoho; no Zoho writes without explicit yes.  
6. Sync worker is **server-only**; browser never holds service_role or foreign API keys.

---

## Suggested first build slice (when Rose says shape yes — not now)

**Slice A — “map only, no live traffic”**

- Confirm field map: Docs Collect status → `documents`; AuditEngine id attach rules for `qualifiers` / `licenses` / `placements` / `needs` (+ optional `risks`)  
- Outbound: append-only `integration_events` (or equivalent) table for sync-eligible writes — **no consumer yet**  
- Inbound: stub/disabled receivers  

**Slice B — “one inbound consumer”** (pick one after A)

- Docs Collect document status **or** AuditEngine id backfill for a small allowlisted set  

**Not in first slice:** Zoho writes, finance, matching engine auto-feed, portal exposure.

---

## What we will not do until you say

- Turn any seam ON  
- Add sync worker / cron / webhooks  
- Call AuditEngine / Docs Collect / Zoho from the live staff app  
- Open client or partner URLs  

---

## Ask-backs (yes / no / pick)

1. First real sync target when we build: **A)** Docs Collect status-in · **B)** AuditEngine id attach · **C)** both map-only (Slice A) first — pick  
2. Zoho in v1 at all? **no** (recommended) / **read-only link later** / **yes with scope**  
3. Triggers: prefer **event on QMOS write** vs **scheduled pull** vs **foreign webhook** for Slice B — pick one  
4. OK to keep `auditengine_id` staff-only name until any future client surface (alias then)? **Y/N**

---

## Out of scope for this proposal

- Implementing any of the above  
- Client/partner go-live  
- Bulk seed apply (separate track: `0012`)
