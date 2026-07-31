-- QualifierManageOS — 0009 Base seed v1
-- STATUS: PROPOSAL ONLY — do not apply until Rose yes on shape, then separate yes to apply.
-- Source: data.base.js (Phase-1 reviewed). NO data.bulk.js.
-- Companion: migrations/SEED_V1_PROPOSAL.md
-- Tip baseline when drafted: 135b19a1e9e8585e0f667be968428886978db3d5
--
-- STAFF RULE (Rose 2026-07-30):
--   * Fictional demo staff (reviewed_by / owners) use @example.com emails — NEVER real domains.
--   * Real Auth allowlist rows (email + auth_user_id) are SEPARATE and additive — do not overwrite.
--   * Carmen Bootstrap / live allowlist rows must remain untouched (ON CONFLICT DO NOTHING on name).
--
-- Idempotent: ON CONFLICT DO UPDATE for seed entity PKs; staff demo rows ON CONFLICT DO NOTHING
-- so a real allowlist row that reused a demo name would not be clobbered (we use distinct demo names).

BEGIN;

-- ---------------------------------------------------------------------------
-- Demo staff (fictional — @example.com only)
-- ---------------------------------------------------------------------------

-- DEMO-ONLY staff (not a live Auth allowlist identity)
INSERT INTO staff (name, role, email, active)
VALUES ('Rose Martinez', 'Leadership', 'demo.rose.martinez@example.com', true)
ON CONFLICT (name) DO NOTHING;

-- DEMO-ONLY staff (not a live Auth allowlist identity)
INSERT INTO staff (name, role, email, active)
VALUES ('Dana Whitfield', 'Admin', 'demo.dana.whitfield@example.com', true)
ON CONFLICT (name) DO NOTHING;

-- DEMO-ONLY staff (not a live Auth allowlist identity)
INSERT INTO staff (name, role, email, active)
VALUES ('Carmen Delgado', 'Placement Coordinator', 'demo.carmen.delgado@example.com', true)
ON CONFLICT (name) DO NOTHING;

-- DEMO-ONLY staff (not a live Auth allowlist identity)
INSERT INTO staff (name, role, email, active)
VALUES ('Marcus Lee', 'Fulfillment', 'demo.marcus.lee@example.com', true)
ON CONFLICT (name) DO NOTHING;

-- DEMO-ONLY staff (not a live Auth allowlist identity)
INSERT INTO staff (name, role, email, active)
VALUES ('Kim Sato', 'Sales Viewer', 'demo.kim.sato@example.com', true)
ON CONFLICT (name) DO NOTHING;


-- ---------------------------------------------------------------------------
-- Cities (base qualifier cities + map gap pin)
-- ---------------------------------------------------------------------------

INSERT INTO cities (city, lng, lat) VALUES ('Tampa', -82.4572, 27.9506)
ON CONFLICT (city) DO UPDATE SET lng = EXCLUDED.lng, lat = EXCLUDED.lat;
INSERT INTO cities (city, lng, lat) VALUES ('Austin', -97.7431, 30.2672)
ON CONFLICT (city) DO UPDATE SET lng = EXCLUDED.lng, lat = EXCLUDED.lat;
INSERT INTO cities (city, lng, lat) VALUES ('Atlanta', -84.388, 33.749)
ON CONFLICT (city) DO UPDATE SET lng = EXCLUDED.lng, lat = EXCLUDED.lat;
INSERT INTO cities (city, lng, lat) VALUES ('Charlotte', -80.8431, 35.2271)
ON CONFLICT (city) DO UPDATE SET lng = EXCLUDED.lng, lat = EXCLUDED.lat;
INSERT INTO cities (city, lng, lat) VALUES ('Miami', -80.1918, 25.7617)
ON CONFLICT (city) DO UPDATE SET lng = EXCLUDED.lng, lat = EXCLUDED.lat;
INSERT INTO cities (city, lng, lat) VALUES ('Houston', -95.3698, 29.7604)
ON CONFLICT (city) DO UPDATE SET lng = EXCLUDED.lng, lat = EXCLUDED.lat;
INSERT INTO cities (city, lng, lat) VALUES ('Orlando', -81.3792, 28.5383)
ON CONFLICT (city) DO UPDATE SET lng = EXCLUDED.lng, lat = EXCLUDED.lat;
INSERT INTO cities (city, lng, lat) VALUES ('San Diego', -117.1611, 32.7157)
ON CONFLICT (city) DO UPDATE SET lng = EXCLUDED.lng, lat = EXCLUDED.lat;
INSERT INTO cities (city, lng, lat) VALUES ('Raleigh', -78.6382, 35.7796)
ON CONFLICT (city) DO UPDATE SET lng = EXCLUDED.lng, lat = EXCLUDED.lat;
INSERT INTO cities (city, lng, lat) VALUES ('Brooklyn', -73.9442, 40.6782)
ON CONFLICT (city) DO UPDATE SET lng = EXCLUDED.lng, lat = EXCLUDED.lat;

-- ---------------------------------------------------------------------------
-- Qualifiers
-- ---------------------------------------------------------------------------

INSERT INTO qualifiers (
  id, full_name, preferred_name, email, phone, city, state_of_residence, timezone,
  status, verification_status, background_check_status, credit_check_status,
  available_for_placement, preferred_placement_types, minimum_monthly_compensation, open_to_negotiation,
  internal_owner, last_reviewed_date, next_review_due, admin_only_notes, readiness_score
) VALUES (
  'Q-001', 'Marcus Webb', 'Marc', 'm.webb@qmail.com', '(813) 555-0142',
  'Tampa', 'FL', 'ET',
  'Active', 'Verified', 'Clear', 'Clear',
  true, ARRAY['License Qualifier', 'Expansion Support']::text[], 4500, true,
  'Carmen Delgado', '2026-06-30', '2026-12-30', 'Strong communicator; Gulfside placement is healthy. Approved as dual-state (FL/GA). First call for FL GC needs — but GL insurance COI lapsed 7/1; hold new starts until carrier confirms.', 84
)
ON CONFLICT (id) DO UPDATE SET
  full_name = EXCLUDED.full_name,
  preferred_name = EXCLUDED.preferred_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  city = EXCLUDED.city,
  state_of_residence = EXCLUDED.state_of_residence,
  timezone = EXCLUDED.timezone,
  status = EXCLUDED.status,
  verification_status = EXCLUDED.verification_status,
  background_check_status = EXCLUDED.background_check_status,
  credit_check_status = EXCLUDED.credit_check_status,
  available_for_placement = EXCLUDED.available_for_placement,
  preferred_placement_types = EXCLUDED.preferred_placement_types,
  minimum_monthly_compensation = EXCLUDED.minimum_monthly_compensation,
  open_to_negotiation = EXCLUDED.open_to_negotiation,
  internal_owner = EXCLUDED.internal_owner,
  last_reviewed_date = EXCLUDED.last_reviewed_date,
  next_review_due = EXCLUDED.next_review_due,
  admin_only_notes = EXCLUDED.admin_only_notes,
  readiness_score = EXCLUDED.readiness_score,
  updated_at = now();

INSERT INTO qualifiers (
  id, full_name, preferred_name, email, phone, city, state_of_residence, timezone,
  status, verification_status, background_check_status, credit_check_status,
  available_for_placement, preferred_placement_types, minimum_monthly_compensation, open_to_negotiation,
  internal_owner, last_reviewed_date, next_review_due, admin_only_notes, readiness_score
) VALUES (
  'Q-002', 'Elena Vasquez', 'Elena', 'elena.v@qmail.com', '(512) 555-0177',
  'Austin', 'TX', 'CT',
  'Verified', 'Verified', 'Clear', 'Clear',
  true, ARRAY['License Qualifier', 'Replacement']::text[], 3800, true,
  'Rose Martinez', '2026-07-01', '2027-01-01', 'Fast document turnaround. Wants TX-only engagements until Q1 2027. OK reciprocity application pending — do not pitch OK until board approves.', 90
)
ON CONFLICT (id) DO UPDATE SET
  full_name = EXCLUDED.full_name,
  preferred_name = EXCLUDED.preferred_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  city = EXCLUDED.city,
  state_of_residence = EXCLUDED.state_of_residence,
  timezone = EXCLUDED.timezone,
  status = EXCLUDED.status,
  verification_status = EXCLUDED.verification_status,
  background_check_status = EXCLUDED.background_check_status,
  credit_check_status = EXCLUDED.credit_check_status,
  available_for_placement = EXCLUDED.available_for_placement,
  preferred_placement_types = EXCLUDED.preferred_placement_types,
  minimum_monthly_compensation = EXCLUDED.minimum_monthly_compensation,
  open_to_negotiation = EXCLUDED.open_to_negotiation,
  internal_owner = EXCLUDED.internal_owner,
  last_reviewed_date = EXCLUDED.last_reviewed_date,
  next_review_due = EXCLUDED.next_review_due,
  admin_only_notes = EXCLUDED.admin_only_notes,
  readiness_score = EXCLUDED.readiness_score,
  updated_at = now();

INSERT INTO qualifiers (
  id, full_name, preferred_name, email, phone, city, state_of_residence, timezone,
  status, verification_status, background_check_status, credit_check_status,
  available_for_placement, preferred_placement_types, minimum_monthly_compensation, open_to_negotiation,
  internal_owner, last_reviewed_date, next_review_due, admin_only_notes, readiness_score
) VALUES (
  'Q-003', 'David Okafor', 'David', 'd.okafor@qmail.com', '(404) 555-0128',
  'Atlanta', 'GA', 'ET',
  'Active', 'Verified', 'Clear', 'Clear',
  false, ARRAY['License Qualifier']::text[], 4000, false,
  'Carmen Delgado', '2026-05-15', '2026-11-15', 'At max placements (1/1). FL roofing license needs re-verification before any second engagement. Communication gaps in April — coached, improving.', 78
)
ON CONFLICT (id) DO UPDATE SET
  full_name = EXCLUDED.full_name,
  preferred_name = EXCLUDED.preferred_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  city = EXCLUDED.city,
  state_of_residence = EXCLUDED.state_of_residence,
  timezone = EXCLUDED.timezone,
  status = EXCLUDED.status,
  verification_status = EXCLUDED.verification_status,
  background_check_status = EXCLUDED.background_check_status,
  credit_check_status = EXCLUDED.credit_check_status,
  available_for_placement = EXCLUDED.available_for_placement,
  preferred_placement_types = EXCLUDED.preferred_placement_types,
  minimum_monthly_compensation = EXCLUDED.minimum_monthly_compensation,
  open_to_negotiation = EXCLUDED.open_to_negotiation,
  internal_owner = EXCLUDED.internal_owner,
  last_reviewed_date = EXCLUDED.last_reviewed_date,
  next_review_due = EXCLUDED.next_review_due,
  admin_only_notes = EXCLUDED.admin_only_notes,
  readiness_score = EXCLUDED.readiness_score,
  updated_at = now();

INSERT INTO qualifiers (
  id, full_name, preferred_name, email, phone, city, state_of_residence, timezone,
  status, verification_status, background_check_status, credit_check_status,
  available_for_placement, preferred_placement_types, minimum_monthly_compensation, open_to_negotiation,
  internal_owner, last_reviewed_date, next_review_due, admin_only_notes, readiness_score
) VALUES (
  'Q-004', 'Sarah Lindqvist', 'Sarah', 's.lindqvist@qmail.com', '(704) 555-0195',
  'Charlotte', 'NC', 'ET',
  'Under Review', 'In Progress', 'Pending', 'Pending',
  false, ARRAY['License Qualifier', 'Compliance Oversight']::text[], 3200, true,
  'Dana Whitfield', '2026-07-10', '2026-08-10', 'Intake strong. Verification blocked on experience proof; checks in flight. Do not surface to sales until Verified.', 58
)
ON CONFLICT (id) DO UPDATE SET
  full_name = EXCLUDED.full_name,
  preferred_name = EXCLUDED.preferred_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  city = EXCLUDED.city,
  state_of_residence = EXCLUDED.state_of_residence,
  timezone = EXCLUDED.timezone,
  status = EXCLUDED.status,
  verification_status = EXCLUDED.verification_status,
  background_check_status = EXCLUDED.background_check_status,
  credit_check_status = EXCLUDED.credit_check_status,
  available_for_placement = EXCLUDED.available_for_placement,
  preferred_placement_types = EXCLUDED.preferred_placement_types,
  minimum_monthly_compensation = EXCLUDED.minimum_monthly_compensation,
  open_to_negotiation = EXCLUDED.open_to_negotiation,
  internal_owner = EXCLUDED.internal_owner,
  last_reviewed_date = EXCLUDED.last_reviewed_date,
  next_review_due = EXCLUDED.next_review_due,
  admin_only_notes = EXCLUDED.admin_only_notes,
  readiness_score = EXCLUDED.readiness_score,
  updated_at = now();

INSERT INTO qualifiers (
  id, full_name, preferred_name, email, phone, city, state_of_residence, timezone,
  status, verification_status, background_check_status, credit_check_status,
  available_for_placement, preferred_placement_types, minimum_monthly_compensation, open_to_negotiation,
  internal_owner, last_reviewed_date, next_review_due, admin_only_notes, readiness_score
) VALUES (
  'Q-005', 'James Ferraro', 'Jim', 'j.ferraro@qmail.com', '(305) 555-0163',
  'Miami', 'FL', 'ET',
  'Verified', 'Verified', 'Clear', 'Review Required',
  true, ARRAY['License Qualifier', 'Backup / On-Deck']::text[], 4200, true,
  'Carmen Delgado', '2026-06-20', '2026-09-20', 'Named backup for Gulfside (P-402). FL CGC renewal filed 7/18, DBPR confirmation pending. Credit re-check open — resolve before backup rider finalizes.', 71
)
ON CONFLICT (id) DO UPDATE SET
  full_name = EXCLUDED.full_name,
  preferred_name = EXCLUDED.preferred_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  city = EXCLUDED.city,
  state_of_residence = EXCLUDED.state_of_residence,
  timezone = EXCLUDED.timezone,
  status = EXCLUDED.status,
  verification_status = EXCLUDED.verification_status,
  background_check_status = EXCLUDED.background_check_status,
  credit_check_status = EXCLUDED.credit_check_status,
  available_for_placement = EXCLUDED.available_for_placement,
  preferred_placement_types = EXCLUDED.preferred_placement_types,
  minimum_monthly_compensation = EXCLUDED.minimum_monthly_compensation,
  open_to_negotiation = EXCLUDED.open_to_negotiation,
  internal_owner = EXCLUDED.internal_owner,
  last_reviewed_date = EXCLUDED.last_reviewed_date,
  next_review_due = EXCLUDED.next_review_due,
  admin_only_notes = EXCLUDED.admin_only_notes,
  readiness_score = EXCLUDED.readiness_score,
  updated_at = now();

INSERT INTO qualifiers (
  id, full_name, preferred_name, email, phone, city, state_of_residence, timezone,
  status, verification_status, background_check_status, credit_check_status,
  available_for_placement, preferred_placement_types, minimum_monthly_compensation, open_to_negotiation,
  internal_owner, last_reviewed_date, next_review_due, admin_only_notes, readiness_score
) VALUES (
  'Q-006', 'Priya Raman', 'Priya', 'p.raman@qmail.com', '(713) 555-0119',
  'Houston', 'TX', 'CT',
  'Active', 'Verified', 'Clear', 'Clear',
  true, ARRAY['License Qualifier', 'Expansion Support']::text[], 3600, true,
  'Rose Martinez', '2026-07-05', '2027-01-05', 'Excellent on Hill Country Air. Approved for one additional TX/LA placement (2 max). Model communicator — protect the relationship.', 88
)
ON CONFLICT (id) DO UPDATE SET
  full_name = EXCLUDED.full_name,
  preferred_name = EXCLUDED.preferred_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  city = EXCLUDED.city,
  state_of_residence = EXCLUDED.state_of_residence,
  timezone = EXCLUDED.timezone,
  status = EXCLUDED.status,
  verification_status = EXCLUDED.verification_status,
  background_check_status = EXCLUDED.background_check_status,
  credit_check_status = EXCLUDED.credit_check_status,
  available_for_placement = EXCLUDED.available_for_placement,
  preferred_placement_types = EXCLUDED.preferred_placement_types,
  minimum_monthly_compensation = EXCLUDED.minimum_monthly_compensation,
  open_to_negotiation = EXCLUDED.open_to_negotiation,
  internal_owner = EXCLUDED.internal_owner,
  last_reviewed_date = EXCLUDED.last_reviewed_date,
  next_review_due = EXCLUDED.next_review_due,
  admin_only_notes = EXCLUDED.admin_only_notes,
  readiness_score = EXCLUDED.readiness_score,
  updated_at = now();

INSERT INTO qualifiers (
  id, full_name, preferred_name, email, phone, city, state_of_residence, timezone,
  status, verification_status, background_check_status, credit_check_status,
  available_for_placement, preferred_placement_types, minimum_monthly_compensation, open_to_negotiation,
  internal_owner, last_reviewed_date, next_review_due, admin_only_notes, readiness_score
) VALUES (
  'Q-007', 'Tom Gallagher', 'Tom', 't.gallagher@qmail.com', '(407) 555-0151',
  'Orlando', 'FL', 'ET',
  'Do Not Place Pending Review', 'Human Review Required', 'Clear', 'Clear',
  false, ARRAY['License Qualifier']::text[], 3000, true,
  'Dana Whitfield', '2026-07-15', '2026-07-29', 'FL roofing license expired 6/30 with an open board inquiry. DO NOT PLACE until reinstatement docs land and Dana closes the review. Tom is cooperative — keep the relationship warm.', 24
)
ON CONFLICT (id) DO UPDATE SET
  full_name = EXCLUDED.full_name,
  preferred_name = EXCLUDED.preferred_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  city = EXCLUDED.city,
  state_of_residence = EXCLUDED.state_of_residence,
  timezone = EXCLUDED.timezone,
  status = EXCLUDED.status,
  verification_status = EXCLUDED.verification_status,
  background_check_status = EXCLUDED.background_check_status,
  credit_check_status = EXCLUDED.credit_check_status,
  available_for_placement = EXCLUDED.available_for_placement,
  preferred_placement_types = EXCLUDED.preferred_placement_types,
  minimum_monthly_compensation = EXCLUDED.minimum_monthly_compensation,
  open_to_negotiation = EXCLUDED.open_to_negotiation,
  internal_owner = EXCLUDED.internal_owner,
  last_reviewed_date = EXCLUDED.last_reviewed_date,
  next_review_due = EXCLUDED.next_review_due,
  admin_only_notes = EXCLUDED.admin_only_notes,
  readiness_score = EXCLUDED.readiness_score,
  updated_at = now();

INSERT INTO qualifiers (
  id, full_name, preferred_name, email, phone, city, state_of_residence, timezone,
  status, verification_status, background_check_status, credit_check_status,
  available_for_placement, preferred_placement_types, minimum_monthly_compensation, open_to_negotiation,
  internal_owner, last_reviewed_date, next_review_due, admin_only_notes, readiness_score
) VALUES (
  'Q-008', 'Nicole Barnes', 'Nicole', 'n.barnes@qmail.com', '(619) 555-0184',
  'San Diego', 'CA', 'PT',
  'Verified', 'Verified', 'Clear', 'Clear',
  true, ARRAY['License Qualifier', 'Expansion Support', 'Replacement']::text[], 5500, false,
  'Rose Martinez', '2026-07-12', '2027-01-12', 'Premium profile: CA B + AZ KB-2, RMO experience. Firm on the $5,500 floor — do not pitch below it. Prefers a single premium engagement.', 94
)
ON CONFLICT (id) DO UPDATE SET
  full_name = EXCLUDED.full_name,
  preferred_name = EXCLUDED.preferred_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  city = EXCLUDED.city,
  state_of_residence = EXCLUDED.state_of_residence,
  timezone = EXCLUDED.timezone,
  status = EXCLUDED.status,
  verification_status = EXCLUDED.verification_status,
  background_check_status = EXCLUDED.background_check_status,
  credit_check_status = EXCLUDED.credit_check_status,
  available_for_placement = EXCLUDED.available_for_placement,
  preferred_placement_types = EXCLUDED.preferred_placement_types,
  minimum_monthly_compensation = EXCLUDED.minimum_monthly_compensation,
  open_to_negotiation = EXCLUDED.open_to_negotiation,
  internal_owner = EXCLUDED.internal_owner,
  last_reviewed_date = EXCLUDED.last_reviewed_date,
  next_review_due = EXCLUDED.next_review_due,
  admin_only_notes = EXCLUDED.admin_only_notes,
  readiness_score = EXCLUDED.readiness_score,
  updated_at = now();

INSERT INTO qualifiers (
  id, full_name, preferred_name, email, phone, city, state_of_residence, timezone,
  status, verification_status, background_check_status, credit_check_status,
  available_for_placement, preferred_placement_types, minimum_monthly_compensation, open_to_negotiation,
  internal_owner, last_reviewed_date, next_review_due, admin_only_notes, readiness_score
) VALUES (
  'Q-009', 'Robert Choi', 'Rob', 'r.choi@qmail.com', '(919) 555-0136',
  'Raleigh', 'NC', 'ET',
  'Intake Started', 'Not Started', 'Not Started', 'Not Started',
  false, ARRAY['License Qualifier']::text[], 2800, true,
  'Marcus Lee', NULL, '2026-08-05', 'New referral from the NC association. ID and license verification outstanding — needed before M-305 can advance.', 31
)
ON CONFLICT (id) DO UPDATE SET
  full_name = EXCLUDED.full_name,
  preferred_name = EXCLUDED.preferred_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  city = EXCLUDED.city,
  state_of_residence = EXCLUDED.state_of_residence,
  timezone = EXCLUDED.timezone,
  status = EXCLUDED.status,
  verification_status = EXCLUDED.verification_status,
  background_check_status = EXCLUDED.background_check_status,
  credit_check_status = EXCLUDED.credit_check_status,
  available_for_placement = EXCLUDED.available_for_placement,
  preferred_placement_types = EXCLUDED.preferred_placement_types,
  minimum_monthly_compensation = EXCLUDED.minimum_monthly_compensation,
  open_to_negotiation = EXCLUDED.open_to_negotiation,
  internal_owner = EXCLUDED.internal_owner,
  last_reviewed_date = EXCLUDED.last_reviewed_date,
  next_review_due = EXCLUDED.next_review_due,
  admin_only_notes = EXCLUDED.admin_only_notes,
  readiness_score = EXCLUDED.readiness_score,
  updated_at = now();

INSERT INTO qualifiers (
  id, full_name, preferred_name, email, phone, city, state_of_residence, timezone,
  status, verification_status, background_check_status, credit_check_status,
  available_for_placement, preferred_placement_types, minimum_monthly_compensation, open_to_negotiation,
  internal_owner, last_reviewed_date, next_review_due, admin_only_notes, readiness_score
) VALUES (
  'Q-010', 'Angela Duke', 'Angela', 'a.duke@qmail.com', '(718) 555-0109',
  'Brooklyn', 'NY', 'ET',
  'Paused', 'Verified', 'Clear', 'Clear',
  false, ARRAY['License Qualifier']::text[], 5000, false,
  'Rose Martinez', '2026-07-18', '2026-08-18', 'Paused for family leave through ~9/15 while on the Harbor Point placement. Replacement search open as N-206. Handle with care — strong long-term profile, gave 3 weeks notice.', 66
)
ON CONFLICT (id) DO UPDATE SET
  full_name = EXCLUDED.full_name,
  preferred_name = EXCLUDED.preferred_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  city = EXCLUDED.city,
  state_of_residence = EXCLUDED.state_of_residence,
  timezone = EXCLUDED.timezone,
  status = EXCLUDED.status,
  verification_status = EXCLUDED.verification_status,
  background_check_status = EXCLUDED.background_check_status,
  credit_check_status = EXCLUDED.credit_check_status,
  available_for_placement = EXCLUDED.available_for_placement,
  preferred_placement_types = EXCLUDED.preferred_placement_types,
  minimum_monthly_compensation = EXCLUDED.minimum_monthly_compensation,
  open_to_negotiation = EXCLUDED.open_to_negotiation,
  internal_owner = EXCLUDED.internal_owner,
  last_reviewed_date = EXCLUDED.last_reviewed_date,
  next_review_due = EXCLUDED.next_review_due,
  admin_only_notes = EXCLUDED.admin_only_notes,
  readiness_score = EXCLUDED.readiness_score,
  updated_at = now();


-- ---------------------------------------------------------------------------
-- Licenses
-- ---------------------------------------------------------------------------

INSERT INTO licenses (
  id, qualifier_id, state, license_number, license_type, trade_classification, license_status,
  issue_date, expiration_date, last_verified_date, verification_source, restrictions,
  can_be_used_for_placement, license_health_status
) VALUES (
  'L-101', 'Q-001', 'FL', 'CGC1512873', 'Certified General Contractor',
  'General Contracting', 'Active', '2019-08-31', '2027-08-31',
  '2026-07-01', 'FL DBPR portal', NULL,
  true, 'Verified Current'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  state = EXCLUDED.state,
  license_number = EXCLUDED.license_number,
  license_type = EXCLUDED.license_type,
  trade_classification = EXCLUDED.trade_classification,
  license_status = EXCLUDED.license_status,
  issue_date = EXCLUDED.issue_date,
  expiration_date = EXCLUDED.expiration_date,
  last_verified_date = EXCLUDED.last_verified_date,
  verification_source = EXCLUDED.verification_source,
  restrictions = EXCLUDED.restrictions,
  can_be_used_for_placement = EXCLUDED.can_be_used_for_placement,
  license_health_status = EXCLUDED.license_health_status,
  updated_at = now();

INSERT INTO licenses (
  id, qualifier_id, state, license_number, license_type, trade_classification, license_status,
  issue_date, expiration_date, last_verified_date, verification_source, restrictions,
  can_be_used_for_placement, license_health_status
) VALUES (
  'L-102', 'Q-001', 'GA', 'GCCO006214', 'General Contractor',
  'General Contracting', 'Renewal Window', '2022-10-15', '2026-10-15',
  '2026-07-01', 'GA licensing board', NULL,
  true, 'Renewal Window'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  state = EXCLUDED.state,
  license_number = EXCLUDED.license_number,
  license_type = EXCLUDED.license_type,
  trade_classification = EXCLUDED.trade_classification,
  license_status = EXCLUDED.license_status,
  issue_date = EXCLUDED.issue_date,
  expiration_date = EXCLUDED.expiration_date,
  last_verified_date = EXCLUDED.last_verified_date,
  verification_source = EXCLUDED.verification_source,
  restrictions = EXCLUDED.restrictions,
  can_be_used_for_placement = EXCLUDED.can_be_used_for_placement,
  license_health_status = EXCLUDED.license_health_status,
  updated_at = now();

INSERT INTO licenses (
  id, qualifier_id, state, license_number, license_type, trade_classification, license_status,
  issue_date, expiration_date, last_verified_date, verification_source, restrictions,
  can_be_used_for_placement, license_health_status
) VALUES (
  'L-103', 'Q-002', 'TX', 'TECL-38217', 'Master Electrician',
  'Electrical', 'Active', '2018-03-14', '2027-03-14',
  '2026-06-28', 'TDLR lookup', NULL,
  true, 'Verified Current'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  state = EXCLUDED.state,
  license_number = EXCLUDED.license_number,
  license_type = EXCLUDED.license_type,
  trade_classification = EXCLUDED.trade_classification,
  license_status = EXCLUDED.license_status,
  issue_date = EXCLUDED.issue_date,
  expiration_date = EXCLUDED.expiration_date,
  last_verified_date = EXCLUDED.last_verified_date,
  verification_source = EXCLUDED.verification_source,
  restrictions = EXCLUDED.restrictions,
  can_be_used_for_placement = EXCLUDED.can_be_used_for_placement,
  license_health_status = EXCLUDED.license_health_status,
  updated_at = now();

INSERT INTO licenses (
  id, qualifier_id, state, license_number, license_type, trade_classification, license_status,
  issue_date, expiration_date, last_verified_date, verification_source, restrictions,
  can_be_used_for_placement, license_health_status
) VALUES (
  'L-104', 'Q-002', 'OK', 'OK-EL-88412', 'Electrical Contractor (reciprocity)',
  'Electrical', 'Pending', '2026-06-01', NULL,
  NULL, 'OK CIB application', 'Application pending — await board approval',
  false, 'Human Review Required'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  state = EXCLUDED.state,
  license_number = EXCLUDED.license_number,
  license_type = EXCLUDED.license_type,
  trade_classification = EXCLUDED.trade_classification,
  license_status = EXCLUDED.license_status,
  issue_date = EXCLUDED.issue_date,
  expiration_date = EXCLUDED.expiration_date,
  last_verified_date = EXCLUDED.last_verified_date,
  verification_source = EXCLUDED.verification_source,
  restrictions = EXCLUDED.restrictions,
  can_be_used_for_placement = EXCLUDED.can_be_used_for_placement,
  license_health_status = EXCLUDED.license_health_status,
  updated_at = now();

INSERT INTO licenses (
  id, qualifier_id, state, license_number, license_type, trade_classification, license_status,
  issue_date, expiration_date, last_verified_date, verification_source, restrictions,
  can_be_used_for_placement, license_health_status
) VALUES (
  'L-105', 'Q-003', 'GA', 'GCQA004518', 'General Contractor — Qualifying Agent',
  'General Contracting', 'Active', '2020-01-20', '2028-01-20',
  '2026-05-10', 'GA licensing board', NULL,
  true, 'Verified Current'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  state = EXCLUDED.state,
  license_number = EXCLUDED.license_number,
  license_type = EXCLUDED.license_type,
  trade_classification = EXCLUDED.trade_classification,
  license_status = EXCLUDED.license_status,
  issue_date = EXCLUDED.issue_date,
  expiration_date = EXCLUDED.expiration_date,
  last_verified_date = EXCLUDED.last_verified_date,
  verification_source = EXCLUDED.verification_source,
  restrictions = EXCLUDED.restrictions,
  can_be_used_for_placement = EXCLUDED.can_be_used_for_placement,
  license_health_status = EXCLUDED.license_health_status,
  updated_at = now();

INSERT INTO licenses (
  id, qualifier_id, state, license_number, license_type, trade_classification, license_status,
  issue_date, expiration_date, last_verified_date, verification_source, restrictions,
  can_be_used_for_placement, license_health_status
) VALUES (
  'L-106', 'Q-003', 'FL', 'CCC1327745', 'Certified Roofing Contractor',
  'Roofing', 'Active', '2021-06-11', '2027-06-11',
  '2025-09-02', 'FL DBPR portal', NULL,
  false, 'Missing Verification'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  state = EXCLUDED.state,
  license_number = EXCLUDED.license_number,
  license_type = EXCLUDED.license_type,
  trade_classification = EXCLUDED.trade_classification,
  license_status = EXCLUDED.license_status,
  issue_date = EXCLUDED.issue_date,
  expiration_date = EXCLUDED.expiration_date,
  last_verified_date = EXCLUDED.last_verified_date,
  verification_source = EXCLUDED.verification_source,
  restrictions = EXCLUDED.restrictions,
  can_be_used_for_placement = EXCLUDED.can_be_used_for_placement,
  license_health_status = EXCLUDED.license_health_status,
  updated_at = now();

INSERT INTO licenses (
  id, qualifier_id, state, license_number, license_type, trade_classification, license_status,
  issue_date, expiration_date, last_verified_date, verification_source, restrictions,
  can_be_used_for_placement, license_health_status
) VALUES (
  'L-107', 'Q-004', 'NC', 'P1-30988', 'Plumbing Contractor (P-I)',
  'Plumbing', 'Active', '2019-01-05', '2027-01-05',
  '2026-07-08', 'NC State Board', NULL,
  false, 'Verified Current'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  state = EXCLUDED.state,
  license_number = EXCLUDED.license_number,
  license_type = EXCLUDED.license_type,
  trade_classification = EXCLUDED.trade_classification,
  license_status = EXCLUDED.license_status,
  issue_date = EXCLUDED.issue_date,
  expiration_date = EXCLUDED.expiration_date,
  last_verified_date = EXCLUDED.last_verified_date,
  verification_source = EXCLUDED.verification_source,
  restrictions = EXCLUDED.restrictions,
  can_be_used_for_placement = EXCLUDED.can_be_used_for_placement,
  license_health_status = EXCLUDED.license_health_status,
  updated_at = now();

INSERT INTO licenses (
  id, qualifier_id, state, license_number, license_type, trade_classification, license_status,
  issue_date, expiration_date, last_verified_date, verification_source, restrictions,
  can_be_used_for_placement, license_health_status
) VALUES (
  'L-108', 'Q-005', 'FL', 'CGC1499020', 'Certified General Contractor',
  'General Contracting', 'Expiring Soon', '2015-08-30', '2026-08-30',
  '2026-07-18', 'FL DBPR portal', NULL,
  true, 'Expiring Soon'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  state = EXCLUDED.state,
  license_number = EXCLUDED.license_number,
  license_type = EXCLUDED.license_type,
  trade_classification = EXCLUDED.trade_classification,
  license_status = EXCLUDED.license_status,
  issue_date = EXCLUDED.issue_date,
  expiration_date = EXCLUDED.expiration_date,
  last_verified_date = EXCLUDED.last_verified_date,
  verification_source = EXCLUDED.verification_source,
  restrictions = EXCLUDED.restrictions,
  can_be_used_for_placement = EXCLUDED.can_be_used_for_placement,
  license_health_status = EXCLUDED.license_health_status,
  updated_at = now();

INSERT INTO licenses (
  id, qualifier_id, state, license_number, license_type, trade_classification, license_status,
  issue_date, expiration_date, last_verified_date, verification_source, restrictions,
  can_be_used_for_placement, license_health_status
) VALUES (
  'L-109', 'Q-006', 'TX', 'TACLA00281C', 'HVAC Contractor — Class A',
  'HVAC', 'Active', '2017-11-02', '2027-11-02',
  '2026-07-02', 'TDLR lookup', NULL,
  true, 'Verified Current'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  state = EXCLUDED.state,
  license_number = EXCLUDED.license_number,
  license_type = EXCLUDED.license_type,
  trade_classification = EXCLUDED.trade_classification,
  license_status = EXCLUDED.license_status,
  issue_date = EXCLUDED.issue_date,
  expiration_date = EXCLUDED.expiration_date,
  last_verified_date = EXCLUDED.last_verified_date,
  verification_source = EXCLUDED.verification_source,
  restrictions = EXCLUDED.restrictions,
  can_be_used_for_placement = EXCLUDED.can_be_used_for_placement,
  license_health_status = EXCLUDED.license_health_status,
  updated_at = now();

INSERT INTO licenses (
  id, qualifier_id, state, license_number, license_type, trade_classification, license_status,
  issue_date, expiration_date, last_verified_date, verification_source, restrictions,
  can_be_used_for_placement, license_health_status
) VALUES (
  'L-110', 'Q-006', 'LA', 'LA-52117-M', 'Mechanical Contractor',
  'HVAC', 'Renewal Window', '2023-10-01', '2026-10-01',
  '2026-06-15', 'LSLBC portal', NULL,
  true, 'Renewal Window'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  state = EXCLUDED.state,
  license_number = EXCLUDED.license_number,
  license_type = EXCLUDED.license_type,
  trade_classification = EXCLUDED.trade_classification,
  license_status = EXCLUDED.license_status,
  issue_date = EXCLUDED.issue_date,
  expiration_date = EXCLUDED.expiration_date,
  last_verified_date = EXCLUDED.last_verified_date,
  verification_source = EXCLUDED.verification_source,
  restrictions = EXCLUDED.restrictions,
  can_be_used_for_placement = EXCLUDED.can_be_used_for_placement,
  license_health_status = EXCLUDED.license_health_status,
  updated_at = now();

INSERT INTO licenses (
  id, qualifier_id, state, license_number, license_type, trade_classification, license_status,
  issue_date, expiration_date, last_verified_date, verification_source, restrictions,
  can_be_used_for_placement, license_health_status
) VALUES (
  'L-111', 'Q-007', 'FL', 'CCC1330912', 'Certified Roofing Contractor',
  'Roofing', 'Expired', '2018-06-30', '2026-06-30',
  '2026-07-15', 'FL DBPR portal', 'Board inquiry open — reinstatement required',
  false, 'Do Not Place Pending Review'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  state = EXCLUDED.state,
  license_number = EXCLUDED.license_number,
  license_type = EXCLUDED.license_type,
  trade_classification = EXCLUDED.trade_classification,
  license_status = EXCLUDED.license_status,
  issue_date = EXCLUDED.issue_date,
  expiration_date = EXCLUDED.expiration_date,
  last_verified_date = EXCLUDED.last_verified_date,
  verification_source = EXCLUDED.verification_source,
  restrictions = EXCLUDED.restrictions,
  can_be_used_for_placement = EXCLUDED.can_be_used_for_placement,
  license_health_status = EXCLUDED.license_health_status,
  updated_at = now();

INSERT INTO licenses (
  id, qualifier_id, state, license_number, license_type, trade_classification, license_status,
  issue_date, expiration_date, last_verified_date, verification_source, restrictions,
  can_be_used_for_placement, license_health_status
) VALUES (
  'L-112', 'Q-008', 'CA', '1088412', 'Class B — General Building',
  'General Contracting', 'Active', '2016-02-28', '2028-02-28',
  '2026-07-10', 'CSLB lookup', NULL,
  true, 'Verified Current'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  state = EXCLUDED.state,
  license_number = EXCLUDED.license_number,
  license_type = EXCLUDED.license_type,
  trade_classification = EXCLUDED.trade_classification,
  license_status = EXCLUDED.license_status,
  issue_date = EXCLUDED.issue_date,
  expiration_date = EXCLUDED.expiration_date,
  last_verified_date = EXCLUDED.last_verified_date,
  verification_source = EXCLUDED.verification_source,
  restrictions = EXCLUDED.restrictions,
  can_be_used_for_placement = EXCLUDED.can_be_used_for_placement,
  license_health_status = EXCLUDED.license_health_status,
  updated_at = now();

INSERT INTO licenses (
  id, qualifier_id, state, license_number, license_type, trade_classification, license_status,
  issue_date, expiration_date, last_verified_date, verification_source, restrictions,
  can_be_used_for_placement, license_health_status
) VALUES (
  'L-113', 'Q-008', 'AZ', 'ROC-KB2-33914', 'KB-2 Dual Building',
  'General Contracting', 'Active', '2019-06-15', '2027-06-15',
  '2026-07-10', 'AZ ROC lookup', NULL,
  true, 'Verified Current'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  state = EXCLUDED.state,
  license_number = EXCLUDED.license_number,
  license_type = EXCLUDED.license_type,
  trade_classification = EXCLUDED.trade_classification,
  license_status = EXCLUDED.license_status,
  issue_date = EXCLUDED.issue_date,
  expiration_date = EXCLUDED.expiration_date,
  last_verified_date = EXCLUDED.last_verified_date,
  verification_source = EXCLUDED.verification_source,
  restrictions = EXCLUDED.restrictions,
  can_be_used_for_placement = EXCLUDED.can_be_used_for_placement,
  license_health_status = EXCLUDED.license_health_status,
  updated_at = now();

INSERT INTO licenses (
  id, qualifier_id, state, license_number, license_type, trade_classification, license_status,
  issue_date, expiration_date, last_verified_date, verification_source, restrictions,
  can_be_used_for_placement, license_health_status
) VALUES (
  'L-114', 'Q-009', 'NC', 'U-29441', 'Electrical — Limited (SP-L)',
  'Electrical', 'Unknown', '2020-04-22', '2027-04-22',
  NULL, 'Self-reported — not yet verified', NULL,
  false, 'Human Review Required'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  state = EXCLUDED.state,
  license_number = EXCLUDED.license_number,
  license_type = EXCLUDED.license_type,
  trade_classification = EXCLUDED.trade_classification,
  license_status = EXCLUDED.license_status,
  issue_date = EXCLUDED.issue_date,
  expiration_date = EXCLUDED.expiration_date,
  last_verified_date = EXCLUDED.last_verified_date,
  verification_source = EXCLUDED.verification_source,
  restrictions = EXCLUDED.restrictions,
  can_be_used_for_placement = EXCLUDED.can_be_used_for_placement,
  license_health_status = EXCLUDED.license_health_status,
  updated_at = now();

INSERT INTO licenses (
  id, qualifier_id, state, license_number, license_type, trade_classification, license_status,
  issue_date, expiration_date, last_verified_date, verification_source, restrictions,
  can_be_used_for_placement, license_health_status
) VALUES (
  'L-115', 'Q-010', 'NY', '613455-HIC', 'General Contractor (NYC HIC)',
  'General Contracting', 'Active', '2015-05-19', '2027-05-19',
  '2026-06-01', 'NYC DCA lookup', NULL,
  true, 'Verified Current'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  state = EXCLUDED.state,
  license_number = EXCLUDED.license_number,
  license_type = EXCLUDED.license_type,
  trade_classification = EXCLUDED.trade_classification,
  license_status = EXCLUDED.license_status,
  issue_date = EXCLUDED.issue_date,
  expiration_date = EXCLUDED.expiration_date,
  last_verified_date = EXCLUDED.last_verified_date,
  verification_source = EXCLUDED.verification_source,
  restrictions = EXCLUDED.restrictions,
  can_be_used_for_placement = EXCLUDED.can_be_used_for_placement,
  license_health_status = EXCLUDED.license_health_status,
  updated_at = now();


-- ---------------------------------------------------------------------------
-- Availability
-- ---------------------------------------------------------------------------

INSERT INTO availability (
  id, qualifier_id, availability_status, available_start_date, available_end_date,
  preferred_states, preferred_trades, max_active_placements, current_placement_count,
  remote_ok, in_person_required, notes
) VALUES (
  'A-001', 'Q-001', 'Limited Availability', NULL, NULL,
  ARRAY['FL', 'GA']::text[], ARRAY['General Contracting']::text[], 2, 1,
  true, false, 'Second slot reserved for FL/GA GC needs at $4,500+.'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  availability_status = EXCLUDED.availability_status,
  available_start_date = EXCLUDED.available_start_date,
  available_end_date = EXCLUDED.available_end_date,
  preferred_states = EXCLUDED.preferred_states,
  preferred_trades = EXCLUDED.preferred_trades,
  max_active_placements = EXCLUDED.max_active_placements,
  current_placement_count = EXCLUDED.current_placement_count,
  remote_ok = EXCLUDED.remote_ok,
  in_person_required = EXCLUDED.in_person_required,
  notes = EXCLUDED.notes,
  updated_at = now();

INSERT INTO availability (
  id, qualifier_id, availability_status, available_start_date, available_end_date,
  preferred_states, preferred_trades, max_active_placements, current_placement_count,
  remote_ok, in_person_required, notes
) VALUES (
  'A-002', 'Q-002', 'Available Now', NULL, NULL,
  ARRAY['TX']::text[], ARRAY['Electrical']::text[], 1, 0,
  true, false, 'TX-only until Q1 2027.'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  availability_status = EXCLUDED.availability_status,
  available_start_date = EXCLUDED.available_start_date,
  available_end_date = EXCLUDED.available_end_date,
  preferred_states = EXCLUDED.preferred_states,
  preferred_trades = EXCLUDED.preferred_trades,
  max_active_placements = EXCLUDED.max_active_placements,
  current_placement_count = EXCLUDED.current_placement_count,
  remote_ok = EXCLUDED.remote_ok,
  in_person_required = EXCLUDED.in_person_required,
  notes = EXCLUDED.notes,
  updated_at = now();

INSERT INTO availability (
  id, qualifier_id, availability_status, available_start_date, available_end_date,
  preferred_states, preferred_trades, max_active_placements, current_placement_count,
  remote_ok, in_person_required, notes
) VALUES (
  'A-003', 'Q-003', 'Not Available', NULL, NULL,
  ARRAY['GA']::text[], ARRAY['General Contracting', 'Roofing']::text[], 1, 1,
  false, true, 'At capacity on Summit Restoration.'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  availability_status = EXCLUDED.availability_status,
  available_start_date = EXCLUDED.available_start_date,
  available_end_date = EXCLUDED.available_end_date,
  preferred_states = EXCLUDED.preferred_states,
  preferred_trades = EXCLUDED.preferred_trades,
  max_active_placements = EXCLUDED.max_active_placements,
  current_placement_count = EXCLUDED.current_placement_count,
  remote_ok = EXCLUDED.remote_ok,
  in_person_required = EXCLUDED.in_person_required,
  notes = EXCLUDED.notes,
  updated_at = now();

INSERT INTO availability (
  id, qualifier_id, availability_status, available_start_date, available_end_date,
  preferred_states, preferred_trades, max_active_placements, current_placement_count,
  remote_ok, in_person_required, notes
) VALUES (
  'A-004', 'Q-004', 'Not Available', NULL, NULL,
  ARRAY['NC', 'SC']::text[], ARRAY['Plumbing']::text[], 1, 0,
  true, false, 'Hold until verification completes.'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  availability_status = EXCLUDED.availability_status,
  available_start_date = EXCLUDED.available_start_date,
  available_end_date = EXCLUDED.available_end_date,
  preferred_states = EXCLUDED.preferred_states,
  preferred_trades = EXCLUDED.preferred_trades,
  max_active_placements = EXCLUDED.max_active_placements,
  current_placement_count = EXCLUDED.current_placement_count,
  remote_ok = EXCLUDED.remote_ok,
  in_person_required = EXCLUDED.in_person_required,
  notes = EXCLUDED.notes,
  updated_at = now();

INSERT INTO availability (
  id, qualifier_id, availability_status, available_start_date, available_end_date,
  preferred_states, preferred_trades, max_active_placements, current_placement_count,
  remote_ok, in_person_required, notes
) VALUES (
  'A-005', 'Q-005', 'Available Soon', '2026-09-01', NULL,
  ARRAY['FL']::text[], ARRAY['General Contracting']::text[], 1, 0,
  true, false, 'Backup commitment to P-402 takes priority if triggered.'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  availability_status = EXCLUDED.availability_status,
  available_start_date = EXCLUDED.available_start_date,
  available_end_date = EXCLUDED.available_end_date,
  preferred_states = EXCLUDED.preferred_states,
  preferred_trades = EXCLUDED.preferred_trades,
  max_active_placements = EXCLUDED.max_active_placements,
  current_placement_count = EXCLUDED.current_placement_count,
  remote_ok = EXCLUDED.remote_ok,
  in_person_required = EXCLUDED.in_person_required,
  notes = EXCLUDED.notes,
  updated_at = now();

INSERT INTO availability (
  id, qualifier_id, availability_status, available_start_date, available_end_date,
  preferred_states, preferred_trades, max_active_placements, current_placement_count,
  remote_ok, in_person_required, notes
) VALUES (
  'A-006', 'Q-006', 'Limited Availability', NULL, NULL,
  ARRAY['TX', 'LA']::text[], ARRAY['HVAC']::text[], 2, 1,
  true, false, 'Open to one additional TX/LA engagement.'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  availability_status = EXCLUDED.availability_status,
  available_start_date = EXCLUDED.available_start_date,
  available_end_date = EXCLUDED.available_end_date,
  preferred_states = EXCLUDED.preferred_states,
  preferred_trades = EXCLUDED.preferred_trades,
  max_active_placements = EXCLUDED.max_active_placements,
  current_placement_count = EXCLUDED.current_placement_count,
  remote_ok = EXCLUDED.remote_ok,
  in_person_required = EXCLUDED.in_person_required,
  notes = EXCLUDED.notes,
  updated_at = now();

INSERT INTO availability (
  id, qualifier_id, availability_status, available_start_date, available_end_date,
  preferred_states, preferred_trades, max_active_placements, current_placement_count,
  remote_ok, in_person_required, notes
) VALUES (
  'A-007', 'Q-007', 'Paused', NULL, NULL,
  ARRAY['FL']::text[], ARRAY['Roofing']::text[], 1, 0,
  false, true, 'Do not place — pending review (R-602).'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  availability_status = EXCLUDED.availability_status,
  available_start_date = EXCLUDED.available_start_date,
  available_end_date = EXCLUDED.available_end_date,
  preferred_states = EXCLUDED.preferred_states,
  preferred_trades = EXCLUDED.preferred_trades,
  max_active_placements = EXCLUDED.max_active_placements,
  current_placement_count = EXCLUDED.current_placement_count,
  remote_ok = EXCLUDED.remote_ok,
  in_person_required = EXCLUDED.in_person_required,
  notes = EXCLUDED.notes,
  updated_at = now();

INSERT INTO availability (
  id, qualifier_id, availability_status, available_start_date, available_end_date,
  preferred_states, preferred_trades, max_active_placements, current_placement_count,
  remote_ok, in_person_required, notes
) VALUES (
  'A-008', 'Q-008', 'Available Now', NULL, NULL,
  ARRAY['CA', 'AZ']::text[], ARRAY['General Contracting']::text[], 1, 0,
  true, false, 'Single premium engagement preferred.'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  availability_status = EXCLUDED.availability_status,
  available_start_date = EXCLUDED.available_start_date,
  available_end_date = EXCLUDED.available_end_date,
  preferred_states = EXCLUDED.preferred_states,
  preferred_trades = EXCLUDED.preferred_trades,
  max_active_placements = EXCLUDED.max_active_placements,
  current_placement_count = EXCLUDED.current_placement_count,
  remote_ok = EXCLUDED.remote_ok,
  in_person_required = EXCLUDED.in_person_required,
  notes = EXCLUDED.notes,
  updated_at = now();

INSERT INTO availability (
  id, qualifier_id, availability_status, available_start_date, available_end_date,
  preferred_states, preferred_trades, max_active_placements, current_placement_count,
  remote_ok, in_person_required, notes
) VALUES (
  'A-009', 'Q-009', 'Not Available', NULL, NULL,
  ARRAY['NC']::text[], ARRAY['Electrical']::text[], 1, 0,
  true, false, 'Intake in progress.'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  availability_status = EXCLUDED.availability_status,
  available_start_date = EXCLUDED.available_start_date,
  available_end_date = EXCLUDED.available_end_date,
  preferred_states = EXCLUDED.preferred_states,
  preferred_trades = EXCLUDED.preferred_trades,
  max_active_placements = EXCLUDED.max_active_placements,
  current_placement_count = EXCLUDED.current_placement_count,
  remote_ok = EXCLUDED.remote_ok,
  in_person_required = EXCLUDED.in_person_required,
  notes = EXCLUDED.notes,
  updated_at = now();

INSERT INTO availability (
  id, qualifier_id, availability_status, available_start_date, available_end_date,
  preferred_states, preferred_trades, max_active_placements, current_placement_count,
  remote_ok, in_person_required, notes
) VALUES (
  'A-010', 'Q-010', 'Paused', '2026-09-15', NULL,
  ARRAY['NY', 'NJ']::text[], ARRAY['General Contracting']::text[], 1, 1,
  false, true, 'Family leave through ~9/15.'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  availability_status = EXCLUDED.availability_status,
  available_start_date = EXCLUDED.available_start_date,
  available_end_date = EXCLUDED.available_end_date,
  preferred_states = EXCLUDED.preferred_states,
  preferred_trades = EXCLUDED.preferred_trades,
  max_active_placements = EXCLUDED.max_active_placements,
  current_placement_count = EXCLUDED.current_placement_count,
  remote_ok = EXCLUDED.remote_ok,
  in_person_required = EXCLUDED.in_person_required,
  notes = EXCLUDED.notes,
  updated_at = now();


-- ---------------------------------------------------------------------------
-- Documents
-- ---------------------------------------------------------------------------

INSERT INTO documents (
  id, qualifier_id, related_license_id, document_type, document_status, expiration_date, file_link, internal_notes
) VALUES (
  'D-501', 'Q-001', NULL, 'ID',
  'Approved', '2029-03-12', 'vault://doc/D-501', NULL
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  related_license_id = EXCLUDED.related_license_id,
  document_type = EXCLUDED.document_type,
  document_status = EXCLUDED.document_status,
  expiration_date = EXCLUDED.expiration_date,
  file_link = EXCLUDED.file_link,
  internal_notes = EXCLUDED.internal_notes,
  updated_at = now();

INSERT INTO documents (
  id, qualifier_id, related_license_id, document_type, document_status, expiration_date, file_link, internal_notes
) VALUES (
  'D-502', 'Q-001', 'L-101', 'License Copy',
  'Approved', '2027-08-31', 'vault://doc/D-502', NULL
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  related_license_id = EXCLUDED.related_license_id,
  document_type = EXCLUDED.document_type,
  document_status = EXCLUDED.document_status,
  expiration_date = EXCLUDED.expiration_date,
  file_link = EXCLUDED.file_link,
  internal_notes = EXCLUDED.internal_notes,
  updated_at = now();

INSERT INTO documents (
  id, qualifier_id, related_license_id, document_type, document_status, expiration_date, file_link, internal_notes
) VALUES (
  'D-503', 'Q-001', NULL, 'Insurance',
  'Needs Update', '2026-07-01', 'vault://doc/D-503', 'GL COI lapsed 7/1 — carrier confirmation requested 7/20.'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  related_license_id = EXCLUDED.related_license_id,
  document_type = EXCLUDED.document_type,
  document_status = EXCLUDED.document_status,
  expiration_date = EXCLUDED.expiration_date,
  file_link = EXCLUDED.file_link,
  internal_notes = EXCLUDED.internal_notes,
  updated_at = now();

INSERT INTO documents (
  id, qualifier_id, related_license_id, document_type, document_status, expiration_date, file_link, internal_notes
) VALUES (
  'D-504', 'Q-002', NULL, 'Resume',
  'Approved', NULL, 'vault://doc/D-504', NULL
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  related_license_id = EXCLUDED.related_license_id,
  document_type = EXCLUDED.document_type,
  document_status = EXCLUDED.document_status,
  expiration_date = EXCLUDED.expiration_date,
  file_link = EXCLUDED.file_link,
  internal_notes = EXCLUDED.internal_notes,
  updated_at = now();

INSERT INTO documents (
  id, qualifier_id, related_license_id, document_type, document_status, expiration_date, file_link, internal_notes
) VALUES (
  'D-505', 'Q-002', NULL, 'Background Check',
  'Approved', '2027-07-01', 'vault://status-only', 'Status only — report held by screening vendor.'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  related_license_id = EXCLUDED.related_license_id,
  document_type = EXCLUDED.document_type,
  document_status = EXCLUDED.document_status,
  expiration_date = EXCLUDED.expiration_date,
  file_link = EXCLUDED.file_link,
  internal_notes = EXCLUDED.internal_notes,
  updated_at = now();

INSERT INTO documents (
  id, qualifier_id, related_license_id, document_type, document_status, expiration_date, file_link, internal_notes
) VALUES (
  'D-506', 'Q-004', 'L-107', 'License Copy',
  'In Review', '2027-01-05', 'vault://doc/D-506', NULL
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  related_license_id = EXCLUDED.related_license_id,
  document_type = EXCLUDED.document_type,
  document_status = EXCLUDED.document_status,
  expiration_date = EXCLUDED.expiration_date,
  file_link = EXCLUDED.file_link,
  internal_notes = EXCLUDED.internal_notes,
  updated_at = now();

INSERT INTO documents (
  id, qualifier_id, related_license_id, document_type, document_status, expiration_date, file_link, internal_notes
) VALUES (
  'D-507', 'Q-004', NULL, 'Experience Proof',
  'Requested', NULL, NULL, 'Blocking verification — requested 7/10, reminder 7/21.'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  related_license_id = EXCLUDED.related_license_id,
  document_type = EXCLUDED.document_type,
  document_status = EXCLUDED.document_status,
  expiration_date = EXCLUDED.expiration_date,
  file_link = EXCLUDED.file_link,
  internal_notes = EXCLUDED.internal_notes,
  updated_at = now();

INSERT INTO documents (
  id, qualifier_id, related_license_id, document_type, document_status, expiration_date, file_link, internal_notes
) VALUES (
  'D-508', 'Q-005', NULL, 'Agreement',
  'In Review', NULL, 'vault://doc/D-508', 'Backup rider for P-402 attached.'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  related_license_id = EXCLUDED.related_license_id,
  document_type = EXCLUDED.document_type,
  document_status = EXCLUDED.document_status,
  expiration_date = EXCLUDED.expiration_date,
  file_link = EXCLUDED.file_link,
  internal_notes = EXCLUDED.internal_notes,
  updated_at = now();

INSERT INTO documents (
  id, qualifier_id, related_license_id, document_type, document_status, expiration_date, file_link, internal_notes
) VALUES (
  'D-509', 'Q-007', 'L-111', 'License Copy',
  'Expired', '2026-06-30', 'vault://doc/D-509', 'Superseded — awaiting reinstatement documentation.'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  related_license_id = EXCLUDED.related_license_id,
  document_type = EXCLUDED.document_type,
  document_status = EXCLUDED.document_status,
  expiration_date = EXCLUDED.expiration_date,
  file_link = EXCLUDED.file_link,
  internal_notes = EXCLUDED.internal_notes,
  updated_at = now();

INSERT INTO documents (
  id, qualifier_id, related_license_id, document_type, document_status, expiration_date, file_link, internal_notes
) VALUES (
  'D-510', 'Q-009', NULL, 'ID',
  'Requested', NULL, NULL, 'Requested at intake 7/14.'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  related_license_id = EXCLUDED.related_license_id,
  document_type = EXCLUDED.document_type,
  document_status = EXCLUDED.document_status,
  expiration_date = EXCLUDED.expiration_date,
  file_link = EXCLUDED.file_link,
  internal_notes = EXCLUDED.internal_notes,
  updated_at = now();

INSERT INTO documents (
  id, qualifier_id, related_license_id, document_type, document_status, expiration_date, file_link, internal_notes
) VALUES (
  'D-511', 'Q-009', NULL, 'Resume',
  'Received', NULL, 'vault://doc/D-511', NULL
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  related_license_id = EXCLUDED.related_license_id,
  document_type = EXCLUDED.document_type,
  document_status = EXCLUDED.document_status,
  expiration_date = EXCLUDED.expiration_date,
  file_link = EXCLUDED.file_link,
  internal_notes = EXCLUDED.internal_notes,
  updated_at = now();

INSERT INTO documents (
  id, qualifier_id, related_license_id, document_type, document_status, expiration_date, file_link, internal_notes
) VALUES (
  'D-512', 'Q-008', NULL, 'Bonding',
  'Approved', '2026-09-10', 'vault://doc/D-512', 'Renewal quote requested 7/20.'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  related_license_id = EXCLUDED.related_license_id,
  document_type = EXCLUDED.document_type,
  document_status = EXCLUDED.document_status,
  expiration_date = EXCLUDED.expiration_date,
  file_link = EXCLUDED.file_link,
  internal_notes = EXCLUDED.internal_notes,
  updated_at = now();


-- ---------------------------------------------------------------------------
-- Needs
-- ---------------------------------------------------------------------------

INSERT INTO needs (
  id, company_name, contact_name, needed_state, needed_trade_classification, need_status,
  target_start_date, expected_duration, monthly_offer_amount, setup_signing_amount, urgency_level,
  required_documents, placement_owner, admin_review_status
) VALUES (
  'N-201', 'Meridian Build Group', 'Alan Pruitt · VP Ops', 'FL', 'General Contracting (CGC)',
  'Open', '2026-08-15', '12 months, renewable', 4500,
  2500, 'High', ARRAY['License Copy', 'Insurance', 'Agreement']::text[], 'Carmen Delgado', 'Approved to Match'
)
ON CONFLICT (id) DO UPDATE SET
  company_name = EXCLUDED.company_name,
  contact_name = EXCLUDED.contact_name,
  needed_state = EXCLUDED.needed_state,
  needed_trade_classification = EXCLUDED.needed_trade_classification,
  need_status = EXCLUDED.need_status,
  target_start_date = EXCLUDED.target_start_date,
  expected_duration = EXCLUDED.expected_duration,
  monthly_offer_amount = EXCLUDED.monthly_offer_amount,
  setup_signing_amount = EXCLUDED.setup_signing_amount,
  urgency_level = EXCLUDED.urgency_level,
  required_documents = EXCLUDED.required_documents,
  placement_owner = EXCLUDED.placement_owner,
  admin_review_status = EXCLUDED.admin_review_status,
  updated_at = now();

INSERT INTO needs (
  id, company_name, contact_name, needed_state, needed_trade_classification, need_status,
  target_start_date, expected_duration, monthly_offer_amount, setup_signing_amount, urgency_level,
  required_documents, placement_owner, admin_review_status
) VALUES (
  'N-202', 'Lonestar Mechanical', 'Dee Alvarez · Owner', 'TX', 'HVAC — Class A',
  'Match Proposed', '2026-09-01', '12 months', 3800,
  1500, 'Normal', ARRAY['License Copy', 'Agreement']::text[], 'Rose Martinez', 'Approved to Match'
)
ON CONFLICT (id) DO UPDATE SET
  company_name = EXCLUDED.company_name,
  contact_name = EXCLUDED.contact_name,
  needed_state = EXCLUDED.needed_state,
  needed_trade_classification = EXCLUDED.needed_trade_classification,
  need_status = EXCLUDED.need_status,
  target_start_date = EXCLUDED.target_start_date,
  expected_duration = EXCLUDED.expected_duration,
  monthly_offer_amount = EXCLUDED.monthly_offer_amount,
  setup_signing_amount = EXCLUDED.setup_signing_amount,
  urgency_level = EXCLUDED.urgency_level,
  required_documents = EXCLUDED.required_documents,
  placement_owner = EXCLUDED.placement_owner,
  admin_review_status = EXCLUDED.admin_review_status,
  updated_at = now();

INSERT INTO needs (
  id, company_name, contact_name, needed_state, needed_trade_classification, need_status,
  target_start_date, expected_duration, monthly_offer_amount, setup_signing_amount, urgency_level,
  required_documents, placement_owner, admin_review_status
) VALUES (
  'N-203', 'Blue Ridge Renovations', 'Sam Teller · GM', 'NC', 'Electrical — Limited',
  'Under Review', '2026-10-01', '6 months, option to extend', 3200,
  1000, 'Normal', ARRAY['License Copy', 'Experience Proof', 'Agreement']::text[], 'Marcus Lee', 'In Review'
)
ON CONFLICT (id) DO UPDATE SET
  company_name = EXCLUDED.company_name,
  contact_name = EXCLUDED.contact_name,
  needed_state = EXCLUDED.needed_state,
  needed_trade_classification = EXCLUDED.needed_trade_classification,
  need_status = EXCLUDED.need_status,
  target_start_date = EXCLUDED.target_start_date,
  expected_duration = EXCLUDED.expected_duration,
  monthly_offer_amount = EXCLUDED.monthly_offer_amount,
  setup_signing_amount = EXCLUDED.setup_signing_amount,
  urgency_level = EXCLUDED.urgency_level,
  required_documents = EXCLUDED.required_documents,
  placement_owner = EXCLUDED.placement_owner,
  admin_review_status = EXCLUDED.admin_review_status,
  updated_at = now();

INSERT INTO needs (
  id, company_name, contact_name, needed_state, needed_trade_classification, need_status,
  target_start_date, expected_duration, monthly_offer_amount, setup_signing_amount, urgency_level,
  required_documents, placement_owner, admin_review_status
) VALUES (
  'N-204', 'Pacific Crest Builders', 'Judith Hong · CFO', 'CA', 'Class B — General Building',
  'Match Approved', '2026-08-01', '24 months', 6000,
  5000, 'Emergency', ARRAY['License Copy', 'Bonding', 'Insurance', 'Agreement']::text[], 'Rose Martinez', 'Approved to Match'
)
ON CONFLICT (id) DO UPDATE SET
  company_name = EXCLUDED.company_name,
  contact_name = EXCLUDED.contact_name,
  needed_state = EXCLUDED.needed_state,
  needed_trade_classification = EXCLUDED.needed_trade_classification,
  need_status = EXCLUDED.need_status,
  target_start_date = EXCLUDED.target_start_date,
  expected_duration = EXCLUDED.expected_duration,
  monthly_offer_amount = EXCLUDED.monthly_offer_amount,
  setup_signing_amount = EXCLUDED.setup_signing_amount,
  urgency_level = EXCLUDED.urgency_level,
  required_documents = EXCLUDED.required_documents,
  placement_owner = EXCLUDED.placement_owner,
  admin_review_status = EXCLUDED.admin_review_status,
  updated_at = now();

INSERT INTO needs (
  id, company_name, contact_name, needed_state, needed_trade_classification, need_status,
  target_start_date, expected_duration, monthly_offer_amount, setup_signing_amount, urgency_level,
  required_documents, placement_owner, admin_review_status
) VALUES (
  'N-205', 'Peach State Roofing', 'Bo Landry · President', 'GA', 'Roofing',
  'Draft', '2026-11-01', '12 months', 2800,
  0, 'Low', ARRAY['License Copy', 'Insurance']::text[], 'Carmen Delgado', 'Needs More Info'
)
ON CONFLICT (id) DO UPDATE SET
  company_name = EXCLUDED.company_name,
  contact_name = EXCLUDED.contact_name,
  needed_state = EXCLUDED.needed_state,
  needed_trade_classification = EXCLUDED.needed_trade_classification,
  need_status = EXCLUDED.need_status,
  target_start_date = EXCLUDED.target_start_date,
  expected_duration = EXCLUDED.expected_duration,
  monthly_offer_amount = EXCLUDED.monthly_offer_amount,
  setup_signing_amount = EXCLUDED.setup_signing_amount,
  urgency_level = EXCLUDED.urgency_level,
  required_documents = EXCLUDED.required_documents,
  placement_owner = EXCLUDED.placement_owner,
  admin_review_status = EXCLUDED.admin_review_status,
  updated_at = now();

INSERT INTO needs (
  id, company_name, contact_name, needed_state, needed_trade_classification, need_status,
  target_start_date, expected_duration, monthly_offer_amount, setup_signing_amount, urgency_level,
  required_documents, placement_owner, admin_review_status
) VALUES (
  'N-206', 'Empire Interior Systems', 'Rita Moss · COO', 'NY', 'General Contracting (HIC)',
  'Open', '2026-08-20', 'Replacement — through 2027', 5200,
  3000, 'High', ARRAY['License Copy', 'Agreement']::text[], 'Rose Martinez', 'In Review'
)
ON CONFLICT (id) DO UPDATE SET
  company_name = EXCLUDED.company_name,
  contact_name = EXCLUDED.contact_name,
  needed_state = EXCLUDED.needed_state,
  needed_trade_classification = EXCLUDED.needed_trade_classification,
  need_status = EXCLUDED.need_status,
  target_start_date = EXCLUDED.target_start_date,
  expected_duration = EXCLUDED.expected_duration,
  monthly_offer_amount = EXCLUDED.monthly_offer_amount,
  setup_signing_amount = EXCLUDED.setup_signing_amount,
  urgency_level = EXCLUDED.urgency_level,
  required_documents = EXCLUDED.required_documents,
  placement_owner = EXCLUDED.placement_owner,
  admin_review_status = EXCLUDED.admin_review_status,
  updated_at = now();


-- ---------------------------------------------------------------------------
-- Matches
-- ---------------------------------------------------------------------------

INSERT INTO matches (
  id, placement_need_id, qualifier_id, qualifier_license_id, match_status, fit_score,
  admin_approval_status, reviewed_by, reviewed_date, match_reason, ineligibility_reason, factors
) VALUES (
  'M-301', 'N-201', 'Q-001', 'L-101',
  'Best Fit', 92, 'Pending', NULL,
  NULL, 'Exact state/trade match — current FL CGC, open capacity, and a strong review record on an active FL placement.', NULL, '[{"k":"License","tone":"ok","v":"FL CGC1512873 · Verified Current through 8/2027"},{"k":"Availability","tone":"ok","v":"Limited — 1 of 2 slots open · FL preferred"},{"k":"Compensation","tone":"ok","v":"Min $4,500 = offer $4,500 + $2,500 signing"},{"k":"Documents","tone":"warn","v":"GL insurance COI lapsed 7/1 — renewal in progress"},{"k":"Placement load","tone":"ok","v":"1 active (Gulfside Development)"},{"k":"Risk flags","tone":"ok","v":"None open"}]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  placement_need_id = EXCLUDED.placement_need_id,
  qualifier_id = EXCLUDED.qualifier_id,
  qualifier_license_id = EXCLUDED.qualifier_license_id,
  match_status = EXCLUDED.match_status,
  fit_score = EXCLUDED.fit_score,
  admin_approval_status = EXCLUDED.admin_approval_status,
  reviewed_by = EXCLUDED.reviewed_by,
  reviewed_date = EXCLUDED.reviewed_date,
  match_reason = EXCLUDED.match_reason,
  ineligibility_reason = EXCLUDED.ineligibility_reason,
  factors = EXCLUDED.factors,
  updated_at = now();

INSERT INTO matches (
  id, placement_need_id, qualifier_id, qualifier_license_id, match_status, fit_score,
  admin_approval_status, reviewed_by, reviewed_date, match_reason, ineligibility_reason, factors
) VALUES (
  'M-302', 'N-201', 'Q-005', 'L-108',
  'Possible Fit', 74, 'Pending', NULL,
  NULL, 'Strong FL GC profile, but the CGC renewal must confirm before an 8/15 start is safe.', NULL, '[{"k":"License","tone":"warn","v":"FL CGC expires 8/30 — renewal filed 7/18, confirmation pending"},{"k":"Availability","tone":"warn","v":"Available Soon (9/1) — after target start 8/15"},{"k":"Compensation","tone":"ok","v":"Min $4,200 under offer $4,500"},{"k":"Documents","tone":"warn","v":"Agreement rider in review · credit re-check open"},{"k":"Placement load","tone":"ok","v":"0 active · backup commitment to P-402"},{"k":"Risk flags","tone":"warn","v":"R-601 License Expiring (Medium)"}]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  placement_need_id = EXCLUDED.placement_need_id,
  qualifier_id = EXCLUDED.qualifier_id,
  qualifier_license_id = EXCLUDED.qualifier_license_id,
  match_status = EXCLUDED.match_status,
  fit_score = EXCLUDED.fit_score,
  admin_approval_status = EXCLUDED.admin_approval_status,
  reviewed_by = EXCLUDED.reviewed_by,
  reviewed_date = EXCLUDED.reviewed_date,
  match_reason = EXCLUDED.match_reason,
  ineligibility_reason = EXCLUDED.ineligibility_reason,
  factors = EXCLUDED.factors,
  updated_at = now();

INSERT INTO matches (
  id, placement_need_id, qualifier_id, qualifier_license_id, match_status, fit_score,
  admin_approval_status, reviewed_by, reviewed_date, match_reason, ineligibility_reason, factors
) VALUES (
  'M-303', 'N-201', 'Q-007', 'L-111',
  'Not Recommended', 18, 'Rejected', 'Dana Whitfield',
  '2026-07-16', NULL, 'FL roofing license expired 6/30 with an open board inquiry; qualifier is on a Do Not Place hold pending review.', '[{"k":"License","tone":"bad","v":"Expired 6/30 — reinstatement required"},{"k":"Risk flags","tone":"bad","v":"R-602 Critical · escalated"},{"k":"Availability","tone":"bad","v":"Paused — do-not-place hold"}]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  placement_need_id = EXCLUDED.placement_need_id,
  qualifier_id = EXCLUDED.qualifier_id,
  qualifier_license_id = EXCLUDED.qualifier_license_id,
  match_status = EXCLUDED.match_status,
  fit_score = EXCLUDED.fit_score,
  admin_approval_status = EXCLUDED.admin_approval_status,
  reviewed_by = EXCLUDED.reviewed_by,
  reviewed_date = EXCLUDED.reviewed_date,
  match_reason = EXCLUDED.match_reason,
  ineligibility_reason = EXCLUDED.ineligibility_reason,
  factors = EXCLUDED.factors,
  updated_at = now();

INSERT INTO matches (
  id, placement_need_id, qualifier_id, qualifier_license_id, match_status, fit_score,
  admin_approval_status, reviewed_by, reviewed_date, match_reason, ineligibility_reason, factors
) VALUES (
  'M-304', 'N-202', 'Q-006', 'L-109',
  'Best Fit', 88, 'Pending', NULL,
  NULL, 'Only verified TX Class A profile with open capacity; model review record.', NULL, '[{"k":"License","tone":"ok","v":"TX TACLA00281C · Verified Current through 11/2027"},{"k":"Availability","tone":"ok","v":"Limited — 1 of 2 slots open · TX/LA"},{"k":"Compensation","tone":"ok","v":"Min $3,600 under offer $3,800"},{"k":"Documents","tone":"ok","v":"All current"},{"k":"Placement load","tone":"warn","v":"1 active (Hill Country Air) — ends 8/25, renewal undecided"},{"k":"Risk flags","tone":"ok","v":"None on qualifier · P-403 ending-soon flag is placement-side"}]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  placement_need_id = EXCLUDED.placement_need_id,
  qualifier_id = EXCLUDED.qualifier_id,
  qualifier_license_id = EXCLUDED.qualifier_license_id,
  match_status = EXCLUDED.match_status,
  fit_score = EXCLUDED.fit_score,
  admin_approval_status = EXCLUDED.admin_approval_status,
  reviewed_by = EXCLUDED.reviewed_by,
  reviewed_date = EXCLUDED.reviewed_date,
  match_reason = EXCLUDED.match_reason,
  ineligibility_reason = EXCLUDED.ineligibility_reason,
  factors = EXCLUDED.factors,
  updated_at = now();

INSERT INTO matches (
  id, placement_need_id, qualifier_id, qualifier_license_id, match_status, fit_score,
  admin_approval_status, reviewed_by, reviewed_date, match_reason, ineligibility_reason, factors
) VALUES (
  'M-305', 'N-203', 'Q-009', 'L-114',
  'Possible Fit', 61, 'Needs More Info', 'Dana Whitfield',
  '2026-07-20', 'Trade/state match if verification completes before the 10/1 start.', NULL, '[{"k":"License","tone":"warn","v":"NC SP-L self-reported — verification not started"},{"k":"Documents","tone":"bad","v":"ID outstanding · experience proof not yet requested"},{"k":"Availability","tone":"warn","v":"Intake in progress — 10/1 feasible"},{"k":"Compensation","tone":"ok","v":"Min $2,800 under offer $3,200"},{"k":"Placement load","tone":"ok","v":"0 active"},{"k":"Risk flags","tone":"warn","v":"R-604 Missing Documents (Medium)"}]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  placement_need_id = EXCLUDED.placement_need_id,
  qualifier_id = EXCLUDED.qualifier_id,
  qualifier_license_id = EXCLUDED.qualifier_license_id,
  match_status = EXCLUDED.match_status,
  fit_score = EXCLUDED.fit_score,
  admin_approval_status = EXCLUDED.admin_approval_status,
  reviewed_by = EXCLUDED.reviewed_by,
  reviewed_date = EXCLUDED.reviewed_date,
  match_reason = EXCLUDED.match_reason,
  ineligibility_reason = EXCLUDED.ineligibility_reason,
  factors = EXCLUDED.factors,
  updated_at = now();

INSERT INTO matches (
  id, placement_need_id, qualifier_id, qualifier_license_id, match_status, fit_score,
  admin_approval_status, reviewed_by, reviewed_date, match_reason, ineligibility_reason, factors
) VALUES (
  'M-306', 'N-203', 'Q-002', 'L-103',
  'Not Recommended', 25, 'Rejected', 'Rose Martinez',
  '2026-07-14', NULL, 'No NC electrical credential — TX Master license has no NC reciprocity path before the target start. Qualifier also prefers TX-only.', '[{"k":"License","tone":"bad","v":"TX-only — no NC credential or reciprocity in flight"},{"k":"Availability","tone":"ok","v":"Available Now"},{"k":"Compensation","tone":"ok","v":"Min $3,800 over offer $3,200 — would require negotiation"}]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  placement_need_id = EXCLUDED.placement_need_id,
  qualifier_id = EXCLUDED.qualifier_id,
  qualifier_license_id = EXCLUDED.qualifier_license_id,
  match_status = EXCLUDED.match_status,
  fit_score = EXCLUDED.fit_score,
  admin_approval_status = EXCLUDED.admin_approval_status,
  reviewed_by = EXCLUDED.reviewed_by,
  reviewed_date = EXCLUDED.reviewed_date,
  match_reason = EXCLUDED.match_reason,
  ineligibility_reason = EXCLUDED.ineligibility_reason,
  factors = EXCLUDED.factors,
  updated_at = now();

INSERT INTO matches (
  id, placement_need_id, qualifier_id, qualifier_license_id, match_status, fit_score,
  admin_approval_status, reviewed_by, reviewed_date, match_reason, ineligibility_reason, factors
) VALUES (
  'M-307', 'N-204', 'Q-008', 'L-112',
  'Best Fit', 95, 'Approved', 'Rose Martinez',
  '2026-07-21', 'Premium CA profile — verified Class B, immediate availability, emergency replacement fit.', NULL, '[{"k":"License","tone":"ok","v":"CA B 1088412 · Verified Current through 2/2028"},{"k":"Availability","tone":"ok","v":"Available Now · CA preferred"},{"k":"Compensation","tone":"ok","v":"Offer $6,000 clears firm $5,500 floor"},{"k":"Documents","tone":"ok","v":"Bonding current — renewal quote out (exp 9/10)"},{"k":"Placement load","tone":"ok","v":"0 active"},{"k":"Risk flags","tone":"ok","v":"None open"}]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  placement_need_id = EXCLUDED.placement_need_id,
  qualifier_id = EXCLUDED.qualifier_id,
  qualifier_license_id = EXCLUDED.qualifier_license_id,
  match_status = EXCLUDED.match_status,
  fit_score = EXCLUDED.fit_score,
  admin_approval_status = EXCLUDED.admin_approval_status,
  reviewed_by = EXCLUDED.reviewed_by,
  reviewed_date = EXCLUDED.reviewed_date,
  match_reason = EXCLUDED.match_reason,
  ineligibility_reason = EXCLUDED.ineligibility_reason,
  factors = EXCLUDED.factors,
  updated_at = now();

INSERT INTO matches (
  id, placement_need_id, qualifier_id, qualifier_license_id, match_status, fit_score,
  admin_approval_status, reviewed_by, reviewed_date, match_reason, ineligibility_reason, factors
) VALUES (
  'M-308', 'N-206', 'Q-001', NULL,
  'Not Recommended', 22, 'Hold', 'Dana Whitfield',
  '2026-07-22', NULL, 'No NY GC/HIC credential — licensed FL/GA only. NY bench is currently exhausted; external sourcing required for this need.', '[{"k":"License","tone":"bad","v":"No NY credential — FL CGC + GA GC only"},{"k":"Availability","tone":"ok","v":"1 of 2 slots open"},{"k":"Risk flags","tone":"warn","v":"Need N-206 flagged — thin NY pool (R-606)"}]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  placement_need_id = EXCLUDED.placement_need_id,
  qualifier_id = EXCLUDED.qualifier_id,
  qualifier_license_id = EXCLUDED.qualifier_license_id,
  match_status = EXCLUDED.match_status,
  fit_score = EXCLUDED.fit_score,
  admin_approval_status = EXCLUDED.admin_approval_status,
  reviewed_by = EXCLUDED.reviewed_by,
  reviewed_date = EXCLUDED.reviewed_date,
  match_reason = EXCLUDED.match_reason,
  ineligibility_reason = EXCLUDED.ineligibility_reason,
  factors = EXCLUDED.factors,
  updated_at = now();


-- ---------------------------------------------------------------------------
-- Placements
-- ---------------------------------------------------------------------------

INSERT INTO placements (
  id, company_name, qualifier_id, placement_need_id, placement_match_id, placement_status,
  start_date, expected_end_date, actual_end_date, monthly_fee, qualifier_monthly_compensation, cca_monthly_fee,
  backup_qualifier_needed, backup_qualifier_identified, renewal_review_date, internal_placement_notes
) VALUES (
  'P-401', 'Summit Restoration Co', 'Q-003', NULL, NULL,
  'Active', '2025-11-01', '2026-10-20', NULL,
  5500, 4000, 1500,
  true, false, '2026-09-15', 'Pre-OS placement migrated in. Client ran 24 days late on the June invoice (R-607). GA GC bench is thin — no backup identified.'
)
ON CONFLICT (id) DO UPDATE SET
  company_name = EXCLUDED.company_name,
  qualifier_id = EXCLUDED.qualifier_id,
  placement_need_id = EXCLUDED.placement_need_id,
  placement_match_id = EXCLUDED.placement_match_id,
  placement_status = EXCLUDED.placement_status,
  start_date = EXCLUDED.start_date,
  expected_end_date = EXCLUDED.expected_end_date,
  actual_end_date = EXCLUDED.actual_end_date,
  monthly_fee = EXCLUDED.monthly_fee,
  qualifier_monthly_compensation = EXCLUDED.qualifier_monthly_compensation,
  cca_monthly_fee = EXCLUDED.cca_monthly_fee,
  backup_qualifier_needed = EXCLUDED.backup_qualifier_needed,
  backup_qualifier_identified = EXCLUDED.backup_qualifier_identified,
  renewal_review_date = EXCLUDED.renewal_review_date,
  internal_placement_notes = EXCLUDED.internal_placement_notes,
  updated_at = now();

INSERT INTO placements (
  id, company_name, qualifier_id, placement_need_id, placement_match_id, placement_status,
  start_date, expected_end_date, actual_end_date, monthly_fee, qualifier_monthly_compensation, cca_monthly_fee,
  backup_qualifier_needed, backup_qualifier_identified, renewal_review_date, internal_placement_notes
) VALUES (
  'P-402', 'Gulfside Development', 'Q-001', NULL, NULL,
  'Active', '2026-02-01', '2027-02-01', NULL,
  6200, 4500, 1700,
  true, true, '2026-11-01', 'Healthy relationship. Backup: James Ferraro (Q-005) — agreement rider in review (D-508).'
)
ON CONFLICT (id) DO UPDATE SET
  company_name = EXCLUDED.company_name,
  qualifier_id = EXCLUDED.qualifier_id,
  placement_need_id = EXCLUDED.placement_need_id,
  placement_match_id = EXCLUDED.placement_match_id,
  placement_status = EXCLUDED.placement_status,
  start_date = EXCLUDED.start_date,
  expected_end_date = EXCLUDED.expected_end_date,
  actual_end_date = EXCLUDED.actual_end_date,
  monthly_fee = EXCLUDED.monthly_fee,
  qualifier_monthly_compensation = EXCLUDED.qualifier_monthly_compensation,
  cca_monthly_fee = EXCLUDED.cca_monthly_fee,
  backup_qualifier_needed = EXCLUDED.backup_qualifier_needed,
  backup_qualifier_identified = EXCLUDED.backup_qualifier_identified,
  renewal_review_date = EXCLUDED.renewal_review_date,
  internal_placement_notes = EXCLUDED.internal_placement_notes,
  updated_at = now();

INSERT INTO placements (
  id, company_name, qualifier_id, placement_need_id, placement_match_id, placement_status,
  start_date, expected_end_date, actual_end_date, monthly_fee, qualifier_monthly_compensation, cca_monthly_fee,
  backup_qualifier_needed, backup_qualifier_identified, renewal_review_date, internal_placement_notes
) VALUES (
  'P-403', 'Hill Country Air', 'Q-006', NULL, NULL,
  'Ending Soon', '2025-08-25', '2026-08-25', NULL,
  5000, 3600, 1400,
  true, false, '2026-07-15', 'Renewal decision OVERDUE (review was 7/15). If renewed, Priya continues; if not, close cleanly and release her second slot.'
)
ON CONFLICT (id) DO UPDATE SET
  company_name = EXCLUDED.company_name,
  qualifier_id = EXCLUDED.qualifier_id,
  placement_need_id = EXCLUDED.placement_need_id,
  placement_match_id = EXCLUDED.placement_match_id,
  placement_status = EXCLUDED.placement_status,
  start_date = EXCLUDED.start_date,
  expected_end_date = EXCLUDED.expected_end_date,
  actual_end_date = EXCLUDED.actual_end_date,
  monthly_fee = EXCLUDED.monthly_fee,
  qualifier_monthly_compensation = EXCLUDED.qualifier_monthly_compensation,
  cca_monthly_fee = EXCLUDED.cca_monthly_fee,
  backup_qualifier_needed = EXCLUDED.backup_qualifier_needed,
  backup_qualifier_identified = EXCLUDED.backup_qualifier_identified,
  renewal_review_date = EXCLUDED.renewal_review_date,
  internal_placement_notes = EXCLUDED.internal_placement_notes,
  updated_at = now();

INSERT INTO placements (
  id, company_name, qualifier_id, placement_need_id, placement_match_id, placement_status,
  start_date, expected_end_date, actual_end_date, monthly_fee, qualifier_monthly_compensation, cca_monthly_fee,
  backup_qualifier_needed, backup_qualifier_identified, renewal_review_date, internal_placement_notes
) VALUES (
  'P-404', 'Harbor Point Construction', 'Q-010', NULL, NULL,
  'At Risk', '2025-12-15', '2026-12-15', NULL,
  7000, 5000, 2000,
  true, false, '2026-10-15', 'Angela paused for family leave through ~9/15. Client notified; replacement search open as N-206. At risk if leave extends.'
)
ON CONFLICT (id) DO UPDATE SET
  company_name = EXCLUDED.company_name,
  qualifier_id = EXCLUDED.qualifier_id,
  placement_need_id = EXCLUDED.placement_need_id,
  placement_match_id = EXCLUDED.placement_match_id,
  placement_status = EXCLUDED.placement_status,
  start_date = EXCLUDED.start_date,
  expected_end_date = EXCLUDED.expected_end_date,
  actual_end_date = EXCLUDED.actual_end_date,
  monthly_fee = EXCLUDED.monthly_fee,
  qualifier_monthly_compensation = EXCLUDED.qualifier_monthly_compensation,
  cca_monthly_fee = EXCLUDED.cca_monthly_fee,
  backup_qualifier_needed = EXCLUDED.backup_qualifier_needed,
  backup_qualifier_identified = EXCLUDED.backup_qualifier_identified,
  renewal_review_date = EXCLUDED.renewal_review_date,
  internal_placement_notes = EXCLUDED.internal_placement_notes,
  updated_at = now();


-- ---------------------------------------------------------------------------
-- Reviews
-- ---------------------------------------------------------------------------

INSERT INTO reviews (
  id, qualifier_id, related_placement_id, review_type, reliability_rating, communication_rating,
  document_readiness_rating, review_notes, admin_only, reviewed_by, review_date
) VALUES (
  'V-701', 'Q-001', 'P-402', 'Placement Review',
  5, 5, 4,
  'Gulfside praises responsiveness. Documents occasionally lag — see insurance lapse.', false, 'Rose Martinez', '2026-06-30'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  related_placement_id = EXCLUDED.related_placement_id,
  review_type = EXCLUDED.review_type,
  reliability_rating = EXCLUDED.reliability_rating,
  communication_rating = EXCLUDED.communication_rating,
  document_readiness_rating = EXCLUDED.document_readiness_rating,
  review_notes = EXCLUDED.review_notes,
  admin_only = EXCLUDED.admin_only,
  reviewed_by = EXCLUDED.reviewed_by,
  review_date = EXCLUDED.review_date,
  updated_at = now();

INSERT INTO reviews (
  id, qualifier_id, related_placement_id, review_type, reliability_rating, communication_rating,
  document_readiness_rating, review_notes, admin_only, reviewed_by, review_date
) VALUES (
  'V-702', 'Q-003', 'P-401', 'Placement Review',
  4, 3, 4,
  'Solid on-site presence. Communication gaps during April — coached. Watch for invoice-friction spillover.', true, 'Carmen Delgado', '2026-05-15'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  related_placement_id = EXCLUDED.related_placement_id,
  review_type = EXCLUDED.review_type,
  reliability_rating = EXCLUDED.reliability_rating,
  communication_rating = EXCLUDED.communication_rating,
  document_readiness_rating = EXCLUDED.document_readiness_rating,
  review_notes = EXCLUDED.review_notes,
  admin_only = EXCLUDED.admin_only,
  reviewed_by = EXCLUDED.reviewed_by,
  review_date = EXCLUDED.review_date,
  updated_at = now();

INSERT INTO reviews (
  id, qualifier_id, related_placement_id, review_type, reliability_rating, communication_rating,
  document_readiness_rating, review_notes, admin_only, reviewed_by, review_date
) VALUES (
  'V-703', 'Q-006', 'P-403', 'Communication Review',
  5, 5, 5,
  'Model qualifier — pre-empted the renewal conversation with the client.', false, 'Rose Martinez', '2026-07-05'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  related_placement_id = EXCLUDED.related_placement_id,
  review_type = EXCLUDED.review_type,
  reliability_rating = EXCLUDED.reliability_rating,
  communication_rating = EXCLUDED.communication_rating,
  document_readiness_rating = EXCLUDED.document_readiness_rating,
  review_notes = EXCLUDED.review_notes,
  admin_only = EXCLUDED.admin_only,
  reviewed_by = EXCLUDED.reviewed_by,
  review_date = EXCLUDED.review_date,
  updated_at = now();

INSERT INTO reviews (
  id, qualifier_id, related_placement_id, review_type, reliability_rating, communication_rating,
  document_readiness_rating, review_notes, admin_only, reviewed_by, review_date
) VALUES (
  'V-704', 'Q-010', 'P-404', 'Risk Review',
  4, 4, 5,
  'Leave handled professionally with 3 weeks notice. Availability risk only — no performance concern.', true, 'Dana Whitfield', '2026-07-18'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  related_placement_id = EXCLUDED.related_placement_id,
  review_type = EXCLUDED.review_type,
  reliability_rating = EXCLUDED.reliability_rating,
  communication_rating = EXCLUDED.communication_rating,
  document_readiness_rating = EXCLUDED.document_readiness_rating,
  review_notes = EXCLUDED.review_notes,
  admin_only = EXCLUDED.admin_only,
  reviewed_by = EXCLUDED.reviewed_by,
  review_date = EXCLUDED.review_date,
  updated_at = now();

INSERT INTO reviews (
  id, qualifier_id, related_placement_id, review_type, reliability_rating, communication_rating,
  document_readiness_rating, review_notes, admin_only, reviewed_by, review_date
) VALUES (
  'V-705', 'Q-005', NULL, 'Document Readiness Review',
  4, 4, 2,
  'Insurance and credit re-check dragging. 8/15 deadline set before the backup rider can finalize.', true, 'Dana Whitfield', '2026-07-12'
)
ON CONFLICT (id) DO UPDATE SET
  qualifier_id = EXCLUDED.qualifier_id,
  related_placement_id = EXCLUDED.related_placement_id,
  review_type = EXCLUDED.review_type,
  reliability_rating = EXCLUDED.reliability_rating,
  communication_rating = EXCLUDED.communication_rating,
  document_readiness_rating = EXCLUDED.document_readiness_rating,
  review_notes = EXCLUDED.review_notes,
  admin_only = EXCLUDED.admin_only,
  reviewed_by = EXCLUDED.reviewed_by,
  review_date = EXCLUDED.review_date,
  updated_at = now();


-- ---------------------------------------------------------------------------
-- Risks (base) + two additive rows so UI can show Resolved / Dismissed branches
-- ---------------------------------------------------------------------------

INSERT INTO risks (
  id, related_qualifier_id, related_placement_need_id, related_active_placement_id,
  risk_type, risk_level, risk_status, owner, due_date, resolution_notes
) VALUES (
  'R-601', 'Q-005', 'N-201', NULL,
  'License Expiring', 'Medium', 'Open', 'Carmen Delgado', '2026-08-15', 'FL CGC expires 8/30. Renewal filed 7/18 — confirm with DBPR before M-302 can clear.'
)
ON CONFLICT (id) DO UPDATE SET
  related_qualifier_id = EXCLUDED.related_qualifier_id,
  related_placement_need_id = EXCLUDED.related_placement_need_id,
  related_active_placement_id = EXCLUDED.related_active_placement_id,
  risk_type = EXCLUDED.risk_type,
  risk_level = EXCLUDED.risk_level,
  risk_status = EXCLUDED.risk_status,
  owner = EXCLUDED.owner,
  due_date = EXCLUDED.due_date,
  resolution_notes = EXCLUDED.resolution_notes,
  updated_at = now();

INSERT INTO risks (
  id, related_qualifier_id, related_placement_need_id, related_active_placement_id,
  risk_type, risk_level, risk_status, owner, due_date, resolution_notes
) VALUES (
  'R-602', 'Q-007', NULL, NULL,
  'Human Review Required', 'Critical', 'Escalated', 'Dana Whitfield', '2026-07-29', 'Expired roofing license + open board inquiry. DNP hold stands until reinstatement docs land and review closes.'
)
ON CONFLICT (id) DO UPDATE SET
  related_qualifier_id = EXCLUDED.related_qualifier_id,
  related_placement_need_id = EXCLUDED.related_placement_need_id,
  related_active_placement_id = EXCLUDED.related_active_placement_id,
  risk_type = EXCLUDED.risk_type,
  risk_level = EXCLUDED.risk_level,
  risk_status = EXCLUDED.risk_status,
  owner = EXCLUDED.owner,
  due_date = EXCLUDED.due_date,
  resolution_notes = EXCLUDED.resolution_notes,
  updated_at = now();

INSERT INTO risks (
  id, related_qualifier_id, related_placement_need_id, related_active_placement_id,
  risk_type, risk_level, risk_status, owner, due_date, resolution_notes
) VALUES (
  'R-603', 'Q-006', NULL, 'P-403',
  'Ending Soon No Backup', 'High', 'In Review', 'Rose Martinez', '2026-08-01', 'Renewal decision overdue (7/15). If non-renewal, no backup identified for Hill Country Air.'
)
ON CONFLICT (id) DO UPDATE SET
  related_qualifier_id = EXCLUDED.related_qualifier_id,
  related_placement_need_id = EXCLUDED.related_placement_need_id,
  related_active_placement_id = EXCLUDED.related_active_placement_id,
  risk_type = EXCLUDED.risk_type,
  risk_level = EXCLUDED.risk_level,
  risk_status = EXCLUDED.risk_status,
  owner = EXCLUDED.owner,
  due_date = EXCLUDED.due_date,
  resolution_notes = EXCLUDED.resolution_notes,
  updated_at = now();

INSERT INTO risks (
  id, related_qualifier_id, related_placement_need_id, related_active_placement_id,
  risk_type, risk_level, risk_status, owner, due_date, resolution_notes
) VALUES (
  'R-604', 'Q-009', 'N-203', NULL,
  'Missing Documents', 'Medium', 'Open', 'Marcus Lee', '2026-08-05', 'ID outstanding — blocks verification and match M-305.'
)
ON CONFLICT (id) DO UPDATE SET
  related_qualifier_id = EXCLUDED.related_qualifier_id,
  related_placement_need_id = EXCLUDED.related_placement_need_id,
  related_active_placement_id = EXCLUDED.related_active_placement_id,
  risk_type = EXCLUDED.risk_type,
  risk_level = EXCLUDED.risk_level,
  risk_status = EXCLUDED.risk_status,
  owner = EXCLUDED.owner,
  due_date = EXCLUDED.due_date,
  resolution_notes = EXCLUDED.resolution_notes,
  updated_at = now();

INSERT INTO risks (
  id, related_qualifier_id, related_placement_need_id, related_active_placement_id,
  risk_type, risk_level, risk_status, owner, due_date, resolution_notes
) VALUES (
  'R-605', 'Q-003', NULL, NULL,
  'License Not Verified', 'Medium', 'Open', 'Marcus Lee', '2026-08-20', 'FL roofing license last verified 9/2025 — re-verify before any second engagement.'
)
ON CONFLICT (id) DO UPDATE SET
  related_qualifier_id = EXCLUDED.related_qualifier_id,
  related_placement_need_id = EXCLUDED.related_placement_need_id,
  related_active_placement_id = EXCLUDED.related_active_placement_id,
  risk_type = EXCLUDED.risk_type,
  risk_level = EXCLUDED.risk_level,
  risk_status = EXCLUDED.risk_status,
  owner = EXCLUDED.owner,
  due_date = EXCLUDED.due_date,
  resolution_notes = EXCLUDED.resolution_notes,
  updated_at = now();

INSERT INTO risks (
  id, related_qualifier_id, related_placement_need_id, related_active_placement_id,
  risk_type, risk_level, risk_status, owner, due_date, resolution_notes
) VALUES (
  'R-606', 'Q-010', 'N-206', 'P-404',
  'Availability Conflict', 'High', 'In Review', 'Rose Martinez', '2026-08-10', 'Qualifier on leave mid-placement. Replacement need N-206 open; NY bench thin — sourcing required.'
)
ON CONFLICT (id) DO UPDATE SET
  related_qualifier_id = EXCLUDED.related_qualifier_id,
  related_placement_need_id = EXCLUDED.related_placement_need_id,
  related_active_placement_id = EXCLUDED.related_active_placement_id,
  risk_type = EXCLUDED.risk_type,
  risk_level = EXCLUDED.risk_level,
  risk_status = EXCLUDED.risk_status,
  owner = EXCLUDED.owner,
  due_date = EXCLUDED.due_date,
  resolution_notes = EXCLUDED.resolution_notes,
  updated_at = now();

INSERT INTO risks (
  id, related_qualifier_id, related_placement_need_id, related_active_placement_id,
  risk_type, risk_level, risk_status, owner, due_date, resolution_notes
) VALUES (
  'R-607', NULL, NULL, 'P-401',
  'Payment Issue', 'Medium', 'In Review', 'Carmen Delgado', '2026-08-01', 'June invoice paid 24 days late; July pending. Escalate to leadership if July slips.'
)
ON CONFLICT (id) DO UPDATE SET
  related_qualifier_id = EXCLUDED.related_qualifier_id,
  related_placement_need_id = EXCLUDED.related_placement_need_id,
  related_active_placement_id = EXCLUDED.related_active_placement_id,
  risk_type = EXCLUDED.risk_type,
  risk_level = EXCLUDED.risk_level,
  risk_status = EXCLUDED.risk_status,
  owner = EXCLUDED.owner,
  due_date = EXCLUDED.due_date,
  resolution_notes = EXCLUDED.resolution_notes,
  updated_at = now();

INSERT INTO risks (
  id, related_qualifier_id, related_placement_need_id, related_active_placement_id,
  risk_type, risk_level, risk_status, owner, due_date, resolution_notes
) VALUES (
  'R-608', NULL, NULL, 'P-401',
  'Ending Soon No Backup', 'Medium', 'Open', 'Carmen Delgado', '2026-09-15', 'Ends 10/20 with renewal review 9/15 and no backup identified. Start backup search by mid-August.'
)
ON CONFLICT (id) DO UPDATE SET
  related_qualifier_id = EXCLUDED.related_qualifier_id,
  related_placement_need_id = EXCLUDED.related_placement_need_id,
  related_active_placement_id = EXCLUDED.related_active_placement_id,
  risk_type = EXCLUDED.risk_type,
  risk_level = EXCLUDED.risk_level,
  risk_status = EXCLUDED.risk_status,
  owner = EXCLUDED.owner,
  due_date = EXCLUDED.due_date,
  resolution_notes = EXCLUDED.resolution_notes,
  updated_at = now();


-- Additive (not in data.base.js): close status branches for Risk Review filters
INSERT INTO risks (
  id, related_qualifier_id, related_placement_need_id, related_active_placement_id,
  risk_type, risk_level, risk_status, owner, due_date, resolution_notes
) VALUES (
  'R-609', 'Q-002', NULL, NULL,
  'Document Follow-up', 'Low', 'Resolved', 'Marcus Lee', '2026-07-10',
  'Demo closed item — OK reciprocity packet filed; no further action.'
)
ON CONFLICT (id) DO UPDATE SET
  risk_status = EXCLUDED.risk_status,
  resolution_notes = EXCLUDED.resolution_notes,
  updated_at = now();

INSERT INTO risks (
  id, related_qualifier_id, related_placement_need_id, related_active_placement_id,
  risk_type, risk_level, risk_status, owner, due_date, resolution_notes
) VALUES (
  'R-610', 'Q-008', NULL, NULL,
  'Compensation Note', 'Low', 'Dismissed', 'Rose Martinez', '2026-07-12',
  'Demo dismissed item — firm floor already reflected in match M-307; no risk.'
)
ON CONFLICT (id) DO UPDATE SET
  risk_status = EXCLUDED.risk_status,
  resolution_notes = EXCLUDED.resolution_notes,
  updated_at = now();


-- ---------------------------------------------------------------------------
-- Coverage gaps — only rows whose need_id exists in base (N-206)
-- ---------------------------------------------------------------------------
INSERT INTO coverage_gaps (id, state, city, reason, open_needs, severity, need_id)
VALUES (
  'a0000000-0000-4000-8000-000000000206',
  'NY', 'Brooklyn',
  'Replacement need, bench exhausted (on leave)',
  1, 'high', 'N-206'
)
ON CONFLICT (id) DO UPDATE SET
  state = EXCLUDED.state,
  city = EXCLUDED.city,
  reason = EXCLUDED.reason,
  open_needs = EXCLUDED.open_needs,
  severity = EXCLUDED.severity,
  need_id = EXCLUDED.need_id,
  updated_at = now();


INSERT INTO qmos_schema_migrations (id, notes)
VALUES (
  '0009_seed_base_v1',
  'Base seed from data.base.js + R-609/R-610 status branches; demo staff @example.com; no bulk'
)
ON CONFLICT (id) DO NOTHING;

COMMIT;
