/**
 * Slice A stub — DocumentCollection status inbound receiver.
 * Issue #3. No network. No Supabase writes. Map-only documentation helper.
 *
 * Future (Slice B, gated on ID-001): accept Contract C envelope and patch
 * documents.document_status / file_link per docs/sync-integrations/FIELD_MAPS.md.
 */

export const STUB_SYSTEM = 'documentcollection';
export const STUB_EVENT = 'documentcollection.status-changed.v1';

/** @param {unknown} _envelope Contract C shape expected later */
export function receiveDocumentStatus(_envelope) {
  return {
    ok: false,
    reason: 'slice_a_no_live_traffic',
    mapRef: 'docs/sync-integrations/FIELD_MAPS.md#1-documentcollection--qmos-documents',
  };
}

export function assertNoNetwork() {
  throw new Error('Slice A stub: network I/O forbidden');
}
