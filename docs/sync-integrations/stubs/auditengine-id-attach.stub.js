/**
 * Slice A stub — AuditEngine id attach / backfill receiver.
 * Slice B is GATED on ID-001 (Rose 2026-08-07). This file exists only so the
 * map + stub layout is complete under Slice A; it must not run.
 */

export const STUB_SYSTEM = 'auditengine';
export const STUB_EVENT = 'auditengine.id-attached.v1';

export function receiveAuditEngineIdAttach(_envelope) {
  return {
    ok: false,
    reason: 'slice_b_gated_on_id_001',
    mapRef: 'docs/sync-integrations/FIELD_MAPS.md#2-auditengine--qmos-option-a-ids',
  };
}

export function assertNoNetwork() {
  throw new Error('Slice A/B stub: network I/O forbidden until ID-001 + Rose yes');
}
