/**
 * QualifierManageOS — browser API (anon key + user JWT only).
 * No service_role. Hydrate under RLS; writes via audited RPCs.
 */
import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2.49.8/+esm';
import { QMOS_SUPABASE_URL, QMOS_SUPABASE_ANON_KEY } from './qmos-config.js';

export const QmosAuthError = class extends Error {
  constructor(code, message) {
    super(message);
    this.name = 'QmosAuthError';
    this.code = code;
  }
};

let _client = null;

export function getClient() {
  if (_client) return _client;
  _client = createClient(QMOS_SUPABASE_URL, QMOS_SUPABASE_ANON_KEY, {
    auth: {
      persistSession: true,
      autoRefreshToken: true,
      detectSessionInUrl: true,
      storageKey: 'qmos.auth.v1',
    },
  });
  return _client;
}

function b64urlJson(segment) {
  const pad = '='.repeat((4 - (segment.length % 4)) % 4);
  const json = atob(segment.replace(/-/g, '+').replace(/_/g, '/') + pad);
  return JSON.parse(json);
}

/** Decode access token claims (qmos_role lives on the JWT, not user metadata). */
export function claimsFromSession(session) {
  if (!session?.access_token) return {};
  try {
    return b64urlJson(session.access_token.split('.')[1]) || {};
  } catch {
    return {};
  }
}

export function roleFromSession(session) {
  const c = claimsFromSession(session);
  return c.qmos_role || null;
}

export function staffNameFromSession(session) {
  const c = claimsFromSession(session);
  return c.qmos_staff_name || null;
}

export async function getSession() {
  const { data, error } = await getClient().auth.getSession();
  if (error) throw error;
  return data.session || null;
}

export async function signIn(email, password) {
  const { data, error } = await getClient().auth.signInWithPassword({
    email: String(email || '').trim(),
    password: String(password || ''),
  });
  if (error) {
    const msg = error.message || 'Sign-in failed';
    if (/signups? not allowed|signup_disabled/i.test(msg)) {
      throw new QmosAuthError('signup_disabled', 'Staff accounts are provisioned by Admin — public signup is off.');
    }
    throw new QmosAuthError('sign_in_failed', msg);
  }
  const session = data.session;
  if (!roleFromSession(session)) {
    await getClient().auth.signOut();
    throw new QmosAuthError(
      'not_allowlisted',
      'You’re signed in but not on the QualifierManageOS staff allowlist. Ask an Admin to add your email on staff (active).'
    );
  }
  return session;
}

export async function signOut() {
  await getClient().auth.signOut();
}

function snakeToCamelKey(k) {
  return k.replace(/_([a-z])/g, (_, c) => c.toUpperCase());
}

function mapRow(row) {
  if (!row || typeof row !== 'object') return row;
  const out = {};
  for (const [k, v] of Object.entries(row)) {
    out[snakeToCamelKey(k)] = v;
  }
  return out;
}

function mapRows(rows) {
  return (rows || []).map(mapRow);
}

function todayIso() {
  const d = new Date();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${d.getFullYear()}-${m}-${day}`;
}

function throwFriendly(error, fallback) {
  if (!error) return;
  const msg = error.message || fallback || 'Request failed';
  const code = error.code || error.details || '';
  if (code === '42501' || /permission denied|JWT|not authorized|forbidden/i.test(msg)) {
    throw new QmosAuthError('forbidden', msg);
  }
  if (code === 'P0002' || /not found/i.test(msg)) {
    throw new QmosAuthError('not_found', msg);
  }
  throw new QmosAuthError('api_error', msg);
}

async function selectAll(table) {
  const { data, error } = await getClient().from(table).select('*');
  throwFriendly(error, `Failed to load ${table}`);
  return data || [];
}

/**
 * Hydrate the data.js-shaped bag. Empty tables → empty arrays / {} (honest empty).
 * Requires allowlisted session (qmos_role present).
 */
export async function hydrate() {
  const session = await getSession();
  if (!session) throw new QmosAuthError('no_session', 'Sign in required.');
  if (!roleFromSession(session)) {
    throw new QmosAuthError('not_allowlisted', 'Not on the QualifierManageOS staff allowlist.');
  }

  const [
    qualifiers,
    licenses,
    availability,
    documents,
    needs,
    matches,
    placements,
    reviews,
    risks,
    staff,
    citiesRows,
    coverageGaps,
  ] = await Promise.all([
    selectAll('v_qualifiers_public_fields'),
    selectAll('licenses'),
    selectAll('availability'),
    selectAll('documents'),
    selectAll('needs'),
    selectAll('matches'),
    selectAll('placements'),
    selectAll('reviews'),
    selectAll('v_risks_public_fields'),
    selectAll('staff'),
    selectAll('cities'),
    selectAll('coverage_gaps'),
  ]);

  const QUALIFIERS = mapRows(qualifiers).map((q) => ({
    ...q,
    adminOnlyNotes: q.adminOnlyNotes ?? null,
    readiness: q.readinessScore != null ? { score: q.readinessScore, parts: [] } : { score: null, parts: [] },
  }));

  const CITIES = {};
  for (const row of citiesRows || []) {
    if (row.city != null) CITIES[row.city] = [row.lng, row.lat];
  }

  const STAFF = mapRows(staff).map((s) => ({ name: s.name, role: s.role }));

  return {
    TODAY: todayIso(),
    STAFF,
    CITIES,
    QUALIFIERS,
    LICENSES: mapRows(licenses),
    AVAILABILITY: mapRows(availability),
    DOCUMENTS: mapRows(documents),
    NEEDS: mapRows(needs),
    MATCHES: mapRows(matches),
    PLACEMENTS: mapRows(placements),
    REVIEWS: mapRows(reviews),
    RISKS: mapRows(risks),
    COVERAGE_GAPS: mapRows(coverageGaps).map((g) => ({
      state: g.state,
      city: g.city,
      reason: g.reason,
      openNeeds: g.openNeeds,
      severity: g.severity,
      needId: g.needId ?? null,
    })),
  };
}

export async function approveMatch(id, status) {
  const { data, error } = await getClient().rpc('qmos_approve_match', {
    p_id: id,
    p_status: status,
  });
  throwFriendly(error, 'Match approval failed');
  return mapRow(data);
}

export async function setRisk(id, status) {
  const { data, error } = await getClient().rpc('qmos_set_risk', {
    p_id: id,
    p_status: status,
  });
  throwFriendly(error, 'Risk update failed');
  return mapRow(data);
}

/** Ensure session is allowlisted; returns { session, role, staffName }. */
export async function requireAllowlistedSession() {
  const session = await getSession();
  if (!session) throw new QmosAuthError('no_session', 'Sign in required.');
  const role = roleFromSession(session);
  if (!role) throw new QmosAuthError('not_allowlisted', 'Not on the QualifierManageOS staff allowlist.');
  return { session, role, staffName: staffNameFromSession(session) };
}
