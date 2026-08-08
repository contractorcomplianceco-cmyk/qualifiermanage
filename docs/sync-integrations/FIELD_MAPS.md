# Slice A — Field maps (no live traffic)

Maps only. No workers, webhooks, or outbound calls. When a future slice emits, envelope is **Contract C**: `eventId`, `id`, `event`, `occurredAt`, `payload` (Registry §2.2). Canonical names include QM-001 `qualifier.need-created.v1` and QM-002 `qualifier.placement-approved.v1`.

Identity: **no new Core id column** on QMOS (Registry §4a / ID-001). Foreign mapping today = Option A `auditengine_id` only.

---

## 1. DocumentCollection → QMOS `documents` (inbound map — stub only)

| Docs Collect concept | QMOS column | Notes |
|---|---|---|
| External document id | *(not stored yet)* | Resolve via qualifier `auditengine_id` or future link table — open |
| Qualifier link | `documents.qualifier_id` | Must already exist as `Q-###` |
| License link | `documents.related_license_id` | Optional |
| Doc type | `documents.document_type` | Align vocabulary in a later yes |
| Status | `documents.document_status` | Status-only; never screening report PII |
| Vault ref | `documents.file_link` | `vault://…` or `vault://status-only` only |
| Expiration | `documents.expiration_date` | Optional |

**Trigger (deferred):** Rose still owns push vs poll vs hybrid. Slice A records map only.

---

## 2. AuditEngine ↔ QMOS Option A ids (attach map — stub only)

| QMOS table | QMOS PK | AE column | Attach rule (future) |
|---|---|---|---|
| `qualifiers` | `Q-###` | `auditengine_id` | First successful AE matrix link |
| `licenses` | `L-###` | `auditengine_id` | Per license |
| `placements` | `P-###` | `auditengine_id` | Per placement |
| `needs` | `N-###` | `auditengine_id` | Per need |
| `risks` | `R-###` | `auditengine_id` | Optional |

No backfill in Slice A. Slice B (AE id backfill **or** Docs Collect consumer) gated on ID-001.

---

## 3. QMOS → outbox event sketches (stub / map_only rows only)

| Canonical event | When (future) | `id` aggregate | `payload` (sketch) |
|---|---|---|---|
| `qualifier.need-created.v1` (QM-001) | Need row created | `needs.id` | `{ needId, state, trade, urgency, auditengine_id? }` |
| `qualifier.placement-approved.v1` (QM-002) | Human match approve | `matches.id` | `{ matchId, qualifierId, needId, approvedBy, approvedAt }` |

Emitters **not wired**. If a dry-run row is inserted into `integration_events`, `direction = outbound_stub` and `delivery_status = stub_recorded`.

---

## 4. Zoho / finance / matching engine

Mapped as **out of Slice A build** pending Rose ask-backs. No field maps authored beyond the placeholder target_system enum on `integration_events`.
