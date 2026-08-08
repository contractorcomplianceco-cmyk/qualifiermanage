/**
 * Slice A stub — record a Contract C envelope into integration_events semantics
 * without performing delivery. Does not call Supabase; returns the row shape
 * a future service_role writer would insert with delivery_status=stub_recorded.
 */

/** @typedef {{ eventId: string, id: string, event: string, occurredAt: string, payload: object }} ContractC */

/**
 * @param {ContractC} envelope
 * @param {{ targetSystem: string, direction?: string }} meta
 */
export function buildStubOutboxRow(envelope, meta) {
  const required = ['eventId', 'id', 'event', 'occurredAt', 'payload'];
  for (const k of required) {
    if (envelope == null || envelope[k] === undefined || envelope[k] === null) {
      throw new Error(`Contract C missing field: ${k}`);
    }
  }
  return {
    event_id: envelope.eventId,
    id: envelope.id,
    event: envelope.event,
    occurred_at: envelope.occurredAt,
    payload: envelope.payload,
    direction: meta.direction || 'outbound_stub',
    target_system: meta.targetSystem,
    delivery_status: 'stub_recorded',
  };
}

export function deliver(_row) {
  return { ok: false, reason: 'slice_a_no_live_traffic' };
}
