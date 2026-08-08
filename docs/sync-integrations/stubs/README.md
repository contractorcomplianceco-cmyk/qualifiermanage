# Slice A stub receivers

**Do not import from the staff UI.** These modules document the inbound shape and hard-refuse live delivery.

| Stub | Purpose |
|---|---|
| `documentcollection-status.stub.js` | Inbound Docs Collect status → `documents` map |
| `auditengine-id-attach.stub.js` | Inbound AE id attach (Slice B gated) |
| `outbox-record.stub.js` | Append Contract C row to `integration_events` as `stub_recorded` only |

All stubs throw or return `{ ok: false, reason: 'slice_a_no_live_traffic' }` if asked to perform network I/O.
