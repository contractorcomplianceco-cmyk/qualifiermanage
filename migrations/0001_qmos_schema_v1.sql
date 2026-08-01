-- QualifierManageOS Schema v1
-- Tip baseline: acd552971b63b558d56536c80c4433bcd9f1165a
-- Target: Supabase Postgres
-- Scope: 11 UI entities + coverage map helpers + append-only decision_audit_log
-- ID mapping (DATA_MODEL.md §6 Option A — no-touch): QMOS string PKs stay;
--   nullable unique auditengine_id on qualifiers, licenses, placements, needs, risks.
-- No live sync seams. No RLS policies in this file (auth allowlist slice follows).
-- Apply via Supabase SQL editor / supabase db push / psql — do not embed secrets here.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ---------------------------------------------------------------------------
-- Staff directory (UI STAFF) — name is the FK target used throughout the seed
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS staff (
  name            text PRIMARY KEY,
  role            text NOT NULL
    CHECK (role IN (
      'Leadership',
      'Admin',
      'Placement Coordinator',
      'Fulfillment',
      'Sales Viewer'
    )),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------------
-- Qualifiers (Q-)
-- readiness parts are derived server-side (DATA_MODEL); score cache optional
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS qualifiers (
  id                            text PRIMARY KEY
    CHECK (id ~ '^Q-'),
  full_name                     text NOT NULL,
  preferred_name                text,
  email                         text NOT NULL,
  phone                         text,
  city                          text,
  state_of_residence            text,
  timezone                      text,
  status                        text NOT NULL,
  verification_status           text NOT NULL,
  background_check_status       text NOT NULL,
  credit_check_status           text NOT NULL,
  available_for_placement       boolean NOT NULL DEFAULT false,
  preferred_placement_types     text[] NOT NULL DEFAULT '{}',
  minimum_monthly_compensation  integer,
  open_to_negotiation           boolean NOT NULL DEFAULT true,
  internal_owner                text REFERENCES staff(name),
  last_reviewed_date            date,
  next_review_due               date,
  admin_only_notes              text,  -- sensitive: hide from Sales Viewer in API
  readiness_score               integer
    CHECK (readiness_score IS NULL OR (readiness_score >= 0 AND readiness_score <= 100)),
  auditengine_id                uuid UNIQUE,  -- Option A; nullable until sync
  created_at                    timestamptz NOT NULL DEFAULT now(),
  updated_at                    timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS qualifiers_email_idx ON qualifiers (email);
CREATE INDEX IF NOT EXISTS qualifiers_status_idx ON qualifiers (status);
CREATE INDEX IF NOT EXISTS qualifiers_internal_owner_idx ON qualifiers (internal_owner);

-- ---------------------------------------------------------------------------
-- Licenses (L-)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS licenses (
  id                        text PRIMARY KEY
    CHECK (id ~ '^L-'),
  qualifier_id              text NOT NULL REFERENCES qualifiers(id),
  state                     text NOT NULL,
  license_number            text NOT NULL,
  license_type              text,
  trade_classification      text,
  license_status            text NOT NULL,
  issue_date                date,
  expiration_date           date,
  last_verified_date        date,
  verification_source       text,
  restrictions              text,
  can_be_used_for_placement boolean NOT NULL DEFAULT false,
  license_health_status     text,  -- derived preferred; stored for list/query parity
  auditengine_id            uuid UNIQUE,
  created_at                timestamptz NOT NULL DEFAULT now(),
  updated_at                timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS licenses_qualifier_id_idx ON licenses (qualifier_id);
CREATE INDEX IF NOT EXISTS licenses_state_idx ON licenses (state);
CREATE INDEX IF NOT EXISTS licenses_expiration_date_idx ON licenses (expiration_date);

-- ---------------------------------------------------------------------------
-- Availability (A-) — 1:1 with qualifier
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS availability (
  id                       text PRIMARY KEY
    CHECK (id ~ '^A-'),
  qualifier_id             text NOT NULL UNIQUE REFERENCES qualifiers(id),
  availability_status      text NOT NULL,
  available_start_date     date,
  available_end_date       date,
  preferred_states         text[] NOT NULL DEFAULT '{}',
  preferred_trades         text[] NOT NULL DEFAULT '{}',
  max_active_placements    integer NOT NULL DEFAULT 1
    CHECK (max_active_placements >= 0),
  current_placement_count  integer NOT NULL DEFAULT 0
    CHECK (current_placement_count >= 0),  -- prefer derived from placements later
  remote_ok                boolean NOT NULL DEFAULT false,
  in_person_required       boolean NOT NULL DEFAULT false,
  notes                    text,
  created_at               timestamptz NOT NULL DEFAULT now(),
  updated_at               timestamptz NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------------
-- Documents (D-) — status-only for screening; vault:// links only
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS documents (
  id                  text PRIMARY KEY
    CHECK (id ~ '^D-'),
  qualifier_id        text NOT NULL REFERENCES qualifiers(id),
  related_license_id  text REFERENCES licenses(id),
  document_type       text NOT NULL,
  document_status     text NOT NULL,
  expiration_date     date,
  file_link           text,  -- vault://… or vault://status-only; null if not received
  internal_notes      text,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT documents_screening_no_pii_link CHECK (
    file_link IS NULL
    OR file_link LIKE 'vault://%'
  )
);

CREATE INDEX IF NOT EXISTS documents_qualifier_id_idx ON documents (qualifier_id);
CREATE INDEX IF NOT EXISTS documents_status_idx ON documents (document_status);

-- ---------------------------------------------------------------------------
-- Needs (N-)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS needs (
  id                           text PRIMARY KEY
    CHECK (id ~ '^N-'),
  company_name                 text NOT NULL,
  contact_name                 text,
  needed_state                 text NOT NULL,
  needed_trade_classification  text NOT NULL,
  need_status                  text NOT NULL,
  target_start_date            date,
  expected_duration            text,
  monthly_offer_amount         integer,
  setup_signing_amount         integer,
  urgency_level                text NOT NULL,
  required_documents           text[] NOT NULL DEFAULT '{}',
  placement_owner              text REFERENCES staff(name),
  admin_review_status          text NOT NULL,
  auditengine_id               uuid UNIQUE,
  created_at                   timestamptz NOT NULL DEFAULT now(),
  updated_at                   timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS needs_status_idx ON needs (need_status);
CREATE INDEX IF NOT EXISTS needs_state_idx ON needs (needed_state);

-- ---------------------------------------------------------------------------
-- Matches (M-) — human decision lives on admin_approval_status
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS matches (
  id                     text PRIMARY KEY
    CHECK (id ~ '^M-'),
  placement_need_id      text NOT NULL REFERENCES needs(id),
  qualifier_id           text NOT NULL REFERENCES qualifiers(id),
  qualifier_license_id   text REFERENCES licenses(id),
  match_status           text NOT NULL,
  fit_score              integer
    CHECK (fit_score IS NULL OR (fit_score >= 0 AND fit_score <= 100)),
  admin_approval_status  text NOT NULL DEFAULT 'Pending',
  reviewed_by            text REFERENCES staff(name),
  reviewed_date          date,
  match_reason           text,
  ineligibility_reason   text,
  factors                jsonb NOT NULL DEFAULT '[]'::jsonb,  -- [{k,tone,v}] decision support
  created_at             timestamptz NOT NULL DEFAULT now(),
  updated_at             timestamptz NOT NULL DEFAULT now()
  -- external_id deferred (DATA_MODEL §6 open item)
);

CREATE INDEX IF NOT EXISTS matches_need_id_idx ON matches (placement_need_id);
CREATE INDEX IF NOT EXISTS matches_qualifier_id_idx ON matches (qualifier_id);
CREATE INDEX IF NOT EXISTS matches_admin_approval_idx ON matches (admin_approval_status);

-- ---------------------------------------------------------------------------
-- Placements (P-)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS placements (
  id                              text PRIMARY KEY
    CHECK (id ~ '^P-'),
  company_name                    text NOT NULL,
  qualifier_id                    text NOT NULL REFERENCES qualifiers(id),
  placement_need_id               text REFERENCES needs(id),
  placement_match_id              text REFERENCES matches(id),
  placement_status                text NOT NULL,
  start_date                      date,
  expected_end_date               date,
  actual_end_date                 date,
  monthly_fee                     integer,
  qualifier_monthly_compensation  integer,
  cca_monthly_fee                 integer,
  backup_qualifier_needed         boolean NOT NULL DEFAULT false,
  backup_qualifier_identified     boolean NOT NULL DEFAULT false,
  renewal_review_date             date,
  internal_placement_notes        text,
  auditengine_id                  uuid UNIQUE,
  created_at                      timestamptz NOT NULL DEFAULT now(),
  updated_at                      timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS placements_qualifier_id_idx ON placements (qualifier_id);
CREATE INDEX IF NOT EXISTS placements_status_idx ON placements (placement_status);

-- ---------------------------------------------------------------------------
-- Reviews (V-)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS reviews (
  id                          text PRIMARY KEY
    CHECK (id ~ '^V-'),
  qualifier_id                text NOT NULL REFERENCES qualifiers(id),
  related_placement_id        text REFERENCES placements(id),
  review_type                 text NOT NULL,
  reliability_rating          integer CHECK (reliability_rating BETWEEN 1 AND 5),
  communication_rating        integer CHECK (communication_rating BETWEEN 1 AND 5),
  document_readiness_rating   integer CHECK (document_readiness_rating BETWEEN 1 AND 5),
  review_notes                text,
  admin_only                  boolean NOT NULL DEFAULT false,  -- hide from Sales Viewer
  reviewed_by                 text REFERENCES staff(name),
  review_date                 date,
  created_at                  timestamptz NOT NULL DEFAULT now(),
  updated_at                  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS reviews_qualifier_id_idx ON reviews (qualifier_id);

-- ---------------------------------------------------------------------------
-- Risks (R-) — at least one subject FK (seed may attach to more than one)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS risks (
  id                           text PRIMARY KEY
    CHECK (id ~ '^R-'),
  related_qualifier_id         text REFERENCES qualifiers(id),
  related_placement_need_id    text REFERENCES needs(id),
  related_active_placement_id  text REFERENCES placements(id),
  risk_type                    text NOT NULL,
  risk_level                   text NOT NULL,
  risk_status                  text NOT NULL,
  owner                        text REFERENCES staff(name),
  due_date                     date,
  resolution_notes             text,  -- internal: hide from Sales Viewer
  auditengine_id               uuid UNIQUE,
  created_at                   timestamptz NOT NULL DEFAULT now(),
  updated_at                   timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT risks_has_subject CHECK (
    related_qualifier_id IS NOT NULL
    OR related_placement_need_id IS NOT NULL
    OR related_active_placement_id IS NOT NULL
  )
);

CREATE INDEX IF NOT EXISTS risks_status_idx ON risks (risk_status);
CREATE INDEX IF NOT EXISTS risks_level_idx ON risks (risk_level);

-- ---------------------------------------------------------------------------
-- Coverage map helpers (used by coverage-map.html; not in the 11-prefix table
-- but required for the Coverage Map surface)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS cities (
  city       text PRIMARY KEY,
  lng        double precision NOT NULL,
  lat        double precision NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS coverage_gaps (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  state       text NOT NULL,
  city        text NOT NULL,
  reason      text NOT NULL,
  open_needs  integer NOT NULL DEFAULT 0 CHECK (open_needs >= 0),
  severity    text NOT NULL CHECK (severity IN ('low', 'medium', 'high')),
  need_id     text REFERENCES needs(id),
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS coverage_gaps_state_idx ON coverage_gaps (state);

-- ---------------------------------------------------------------------------
-- Append-only decision audit log
-- Replaces prototype localStorage qmos.prototype.overrides.v1 for
-- approveMatch / setRisk (and future audited writes).
-- Application role should have INSERT + SELECT only (no UPDATE/DELETE).
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS decision_audit_log (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at    timestamptz NOT NULL DEFAULT now(),
  actor_name    text REFERENCES staff(name),
  actor_email   text,  -- for allowlist auth v1 (filled when auth lands)
  action        text NOT NULL
    CHECK (action IN (
      'approve_match',
      'set_risk',
      'other'
    )),
  entity_type   text NOT NULL
    CHECK (entity_type IN ('match', 'risk', 'other')),
  entity_id     text NOT NULL,
  from_value    jsonb,
  to_value      jsonb,
  note          text
);

CREATE INDEX IF NOT EXISTS decision_audit_log_created_at_idx
  ON decision_audit_log (created_at DESC);
CREATE INDEX IF NOT EXISTS decision_audit_log_entity_idx
  ON decision_audit_log (entity_type, entity_id);

-- Prevent silent mutation of audit rows (defense in depth; revoke UPDATE/DELETE
-- from app roles when roles are created in a later slice).
CREATE OR REPLACE FUNCTION qmos_forbid_audit_mutation()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  RAISE EXCEPTION 'decision_audit_log is append-only';
END;
$$;

DROP TRIGGER IF EXISTS decision_audit_log_no_update ON decision_audit_log;
CREATE TRIGGER decision_audit_log_no_update
  BEFORE UPDATE OR DELETE ON decision_audit_log
  FOR EACH ROW EXECUTE PROCEDURE qmos_forbid_audit_mutation();

-- ---------------------------------------------------------------------------
-- Schema journal (lightweight; Supabase also tracks its own migration history)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS qmos_schema_migrations (
  id          text PRIMARY KEY,
  applied_at  timestamptz NOT NULL DEFAULT now(),
  notes       text
);

INSERT INTO qmos_schema_migrations (id, notes)
VALUES (
  '0001_qmos_schema_v1',
  'Schema v1: staff, qualifiers, licenses, availability, documents, needs, matches, placements, reviews, risks, cities, coverage_gaps, decision_audit_log; Option A auditengine_id columns'
)
ON CONFLICT (id) DO NOTHING;
