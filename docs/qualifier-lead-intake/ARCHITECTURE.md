# Qualifier Lead Intake — Architecture Package (13 returns)

**Tag:** `[PROPOSAL]` · `[INTERNAL ONLY]`  
**Lane:** Design only — no activation  
**Systems:** FormsConnect · ComplianceCore · QualifierManageOS · RoseOS · AuditEngine · QualifierConnect (future)  
**QMOS base:** `DATA_MODEL.md` Option A (`auditengine_id`) + Core link via `cca_client_profile_id`

---

## 1. End-to-end architecture and sequence flow

### 1.1 Ownership triangle (intake)

```
                    ┌─────────────────────┐
                    │     FormsConnect     │
                    │  form SoT + submit   │
                    │  + consent versions  │
                    └──────────┬──────────┘
                               │ submission event (versioned)
                               ▼
                    ┌─────────────────────┐
                    │   ComplianceCore     │
                    │  identity match/     │
                    │  create → returns    │
                    │  cca_client_profile_id
                    └──────────┬──────────┘
                               │ profile_id + normalized facts
                               ▼
         ┌─────────────────────┴─────────────────────┐
         │                                           │
         ▼                                           ▼
┌─────────────────┐                       ┌─────────────────┐
│ QualifierManageOS│                       │     RoseOS       │
│ qualifier-domain │◄── orchestration ────│ route / queues / │
│ reflection (Q-)  │    + recommendations │ recommendations  │
└────────┬────────┘                       └────────┬────────┘
         │                                          │
         │  display + staff decisions               │ knowledge requests
         │                                          ▼
         │                                ┌─────────────────┐
         │                                │   AuditEngine    │
         │                                │  license / juris │
         │                                │  risk knowledge  │
         │                                └─────────────────┘
         │
         │  (future) claim token / continuation
         ▼
┌─────────────────┐
│ QualifierConnect │  — design handoff only; not built this lane
│ qualifier portal │
└─────────────────┘
```

### 1.2 Sequence (happy path — first submission)

```
Applicant                FormsConnect           ComplianceCore         RoseOS              QMOS                 AuditEngine
    │                         │                       │                   │                  │                      │
    │── fill + consent ──────►│                       │                   │                  │                      │
    │◄─ thank-you (no Verified claim)
    │                         │── SubmitEvent ───────►│                   │                  │                      │
    │                         │   (form_id, form_ver, │                   │                  │                      │
    │                         │    consent_ver,       │                   │                  │                      │
    │                         │    answers, path_intent)
    │                         │                       │── match/upsert ───┤                  │                      │
    │                         │                       │◄─ profile_id ─────┤                  │                      │
    │                         │                       │── IntakeResolved ─►│                  │                      │
    │                         │                       │                   │── create/update ─►│                      │
    │                         │                       │                   │   Q- reflection   │                      │
    │                         │                       │                   │   (link profile_id)
    │                         │                       │                   │── KnowledgeReq ─────────────────────────►│
    │                         │                       │                   │◄─ KnowledgeResp ─────────────────────────┤
    │                         │                       │                   │── route to queue │                      │
    │                         │                       │                   │   + draft recs   │                      │
    │                         │                       │                   │── staff-visible ─►│                      │
    │                         │                       │                   │   suggestions    │                      │
    Staff                     │                       │                   │                  │                      │
    │── review / decide ──────────────────────────────────────────────────┼─────────────────►│                      │
    │                         │                       │                   │◄─ decision audit │                      │
```

### 1.3 Non-negotiable rules in the flow

1. **FormsConnect** is the only place that defines/publishes the form. QMOS never embeds a parallel form schema that staff must edit in code.  
2. **ComplianceCore** runs **before** QMOS creates/updates a qualifier reflection.  
3. QMOS stores **`cca_client_profile_id`** as the Core foreign key; it does **not** treat email/name as identity SoT.  
4. **`auditengine_id`** remains Option A (nullable AE matrix id) — separate from Core profile id.  
5. RoseOS owns “what happens next”; FormsConnect conditionals only collect answers.  
6. Staff human decision remains the placement gate — suggestions are decision support only.  
7. “Verified” is **never** set by submit.

### 1.4 Event objects (logical — not activated)

| Event | Producer | Consumers | Purpose |
|---|---|---|---|
| `formsconnect.submission.created` | FormsConnect | Core (primary), RoseOS (notify) | Versioned answers + consent |
| `core.profile.resolved` | ComplianceCore | RoseOS, QMOS | Emits `cca_client_profile_id` + match confidence |
| `qmos.qualifier.reflected` | QMOS | RoseOS | `Q-` id + intake stage |
| `roseos.intake.routed` | RoseOS | QMOS staff queues | Queue + priority + path |
| `roseos.match.suggested` | RoseOS | QMOS Match Center | Candidate suggestions + factors |
| `qmos.decision.recorded` | QMOS | audit log | Human approve / reject / more info |

**This lane does not turn on webhooks or consumers.** Contracts only.

---

## 2. FormsConnect form design and conditional field map

### 2.1 Form identity (proposed)

| Field | Proposed value |
|---|---|
| Form key | `cca.qualifier_lead_intake.v1` |
| Owner app | FormsConnect |
| Publish state | **Draft / inactive** until separate Rose yes |
| Branding | CCA / QualifierConnect-ready; no QMOS staff chrome |
| Embed targets (future) | CCA properties, QualifierConnect — not live this lane |

Staff create / edit / activate / deactivate / duplicate / review **only in FormsConnect**. QMOS reads submission snapshots via linked ids when wired later.

### 2.2 Path intent (first question after soft intro)

| Value | Label (proposed copy) | Default route lean |
|---|---|---|
| `explore` | Explore qualifier opportunities | Standard Lead |
| `verified_path` | Apply for the Verified Qualifier path | Verification Candidate intake |
| `unsure` | Not sure — help me determine the right path | RoseOS readiness scoring |

RoseOS may **override** user selection based on readiness answers (see §6).

### 2.3 Section map + conditionals

| Section | Always? | Show when | Notes |
|---|---|---|---|
| **S0 Intro** | Yes | — | Short; sets expectation: interest form ≠ verification |
| **S1 Path intent** | Yes | — | `explore` / `verified_path` / `unsure` |
| **S2 Basic identity** | Yes | — | PII — minimize; no SSN / DL / DOB on public v1 |
| **S3 Qualifier interest** | Yes | — | Multi-select interests |
| **S4 License profile** | Conditional | Interest includes current qualifier, seeking placement, verified path, **or** path=`verified_path` | Allow “I don’t have a license yet” |
| **S4b Additional licenses** | Conditional | S4 answered + “Add another license” | Repeatable group (max proposed: 5) |
| **S5 Experience** | Conditional | Path ≠ explore-only **or** years>0 interest | Lighter for `explore` |
| **S6 Availability & preferences** | Conditional | Seeking placement **or** verified **or** unsure with readiness flags | |
| **S7 Verification readiness** | Conditional | Path ∈ {verified_path, unsure} **or** interest includes Verified program | Soft flags only — no screening PII |
| **S8 Consent** | Yes | — | Versioned; all required checkboxes |

### 2.4 Field catalog (v1)

#### S2 — Basic identity

| Field key | Type | Required | Sensitive | Notes |
|---|---|---|---|---|
| `first_name` | text | Y | PII | |
| `middle_name` | text | N | PII | |
| `last_name` | text | Y | PII | |
| `preferred_name` | text | N | PII | Maps → QMOS `preferredName` |
| `email` | email | Y | PII | Primary contact; not Core sole identity |
| `mobile_phone` | tel | Y | PII | E.164 preferred |
| `preferred_contact_method` | enum | Y | — | `email` · `sms` · `phone` · `any` |
| `city` | text | Y | PII | |
| `state` | US state | Y | PII | Residence |
| `timezone` | tz | N | — | Default from state if blank |

**Public v1 excludes:** SSN, date of birth, government ID images, full background reports, credit data, passport numbers.

#### S3 — Qualifier interest (multi-select)

| Value | Label |
|---|---|
| `current_qualifier` | I currently serve as a qualifier |
| `interested_serving` | Interested in serving as a qualifier |
| `learn_more` | Open to learning more |
| `seeking_placement` | Seeking a new placement |
| `verified_program` | Interested in the Verified Qualifier program |

#### S4 — License profile (per license row)

| Field key | Type | Required if section shown | Notes |
|---|---|---|---|
| `has_license` | bool | Y | If false → skip rest of row; RoseOS may still route learn-more |
| `trade_classification` | text/enum | if has_license | Align later with AE taxonomy (§13) |
| `license_number` | text | if has_license | Normalized in Core/AE — not trusted until verified |
| `issuing_jurisdiction` | state/board | if has_license | |
| `license_status_self` | enum | if has_license | Self-reported: Active / Pending / Expired / Unknown / Other |
| `issue_date` | date | N | |
| `expiration_date` | date | N | |
| `license_holder_type` | enum | if has_license | `individual` · `business` |
| `currently_attached_to_company` | bool | if has_license | |
| `can_serve_another_entity` | enum | if has_license | `yes` · `no` · `unsure` · `depends` |
| `business_name_if_not_holder` | text | if not license holder | Duplicate rule: business contact ≠ holder |

#### S5 — Experience

| Field key | Type | Required |
|---|---|---|
| `years_experience` | int / band | Recommended |
| `trade_specialties` | multi | N |
| `project_types` | multi | N |
| `sector_experience` | multi | N — residential / commercial / industrial / government / other |
| `prior_qualifier_or_rmo` | enum | N — `yes` · `no` · `unsure` |

#### S6 — Availability and placement preferences

| Field key | Type | Maps toward QMOS |
|---|---|---|
| `availability_intent` | enum: now / later / exploring | `availabilityStatus` lean |
| `preferred_states` | state[] | `AVAILABILITY.preferredStates` |
| `involvement_modes` | multi: remote / advisory / supervisory / operational | notes + prefs |
| `engagement_types` | multi: full-time / part-time / project / licensing-only | `preferredPlacementTypes` |
| `travel_willingness` | enum | notes |
| `company_size_preference` | enum/multi | notes |
| `opportunity_type_preference` | multi | notes |

#### S7 — Verification readiness (flags only)

| Field key | Type | Notes |
|---|---|---|
| `willing_license_verification` | bool | |
| `willing_provide_documentation` | bool | |
| `willing_permitted_screening` | bool | **No** collection of screening results here |
| `references_available` | bool | |
| `wants_verified_path` | bool | May differ from S1 path intent |

#### S8 — Consent (all required)

| Field key | Type | Stored with |
|---|---|---|
| `consent_contact` | bool | submission + consent_version |
| `ack_accuracy` | bool | |
| `ack_privacy_notice` | bool | Link to privacy notice URL + version |
| `ack_no_placement_guarantee` | bool | |
| `ack_submit_not_verified` | bool | Explicit: submission ≠ Verified |
| `consent_version` | string | FormsConnect-managed |
| `form_version` | string | FormsConnect-managed |
| `submitted_at` | timestamptz | |

### 2.5 Conditional logic (pseudo)

```
IF path_intent == verified_path OR interests includes verified_program
  SHOW S7 (verification readiness)
  SHOW S4 (license) unless has_license explicitly false after prompt
IF interests includes seeking_placement OR current_qualifier
  SHOW S4, S6
IF path_intent == explore AND interests only learn_more
  LIGHT: S2 + S3 + optional city/state + S8; soft-ask license
IF path_intent == unsure
  SHOW S4 (optional), S5 (light), S7; RoseOS decides route
```

### 2.6 FormsConnect → downstream payload (logical schema)

```json
{
  "event": "formsconnect.submission.created",
  "form_key": "cca.qualifier_lead_intake.v1",
  "form_version": "2026-08-01.1",
  "consent_version": "2026-08-01.consent.1",
  "submission_id": "fc_sub_…",
  "submitted_at": "ISO-8601",
  "path_intent": "explore|verified_path|unsure",
  "answers": { },
  "source_channel": "direct|embed|qualifierconnect|staff_import",
  "locale": "en-US"
}
```

QMOS does **not** own this schema. It stores a **reference** (`formsconnect_submission_id`, versions) on the qualifier reflection when wiring is approved.

---

## 3. Standard Lead versus Verified Qualifier journey

### 3.1 Side-by-side

| Dimension | Standard Qualifier Lead | Verified Qualifier Path |
|---|---|---|
| Intent | Interest / opportunities / learn | Higher-trust program entry |
| Form length | Short–medium | Structured multi-stage (form = stage 0 only) |
| After submit | Core profile + QMOS lead · staff review queue | Core profile + QMOS verification-candidate · verification workflow queue |
| “Verified” label | Never from this path alone | Only after **approved** verification complete |
| Sensitive docs / screening | Later via QualifierConnect (protected) | Same — not on public form |
| Continuation | Claim profile later in QualifierConnect | Claim + complete verification checklist in QualifierConnect |
| Placement suggestions | Possible once readiness ≥ threshold | Prefer after verification milestones (RoseOS policy) |

### 3.2 Standard Lead stages (proposed)

1. **Submitted** — FormsConnect thank-you  
2. **Core resolved** — `cca_client_profile_id` assigned  
3. **QMOS New qualifier lead** — reflection created  
4. **Staff review** — missing info / qualify / nurture  
5. **Optional:** promote to Verification candidate (staff or RoseOS recommend)  
6. **Future:** QualifierConnect claim → enrich → placement-ready  

### 3.3 Verified path stages (proposed — program, not form)

| Stage | Owner | Public form? |
|---|---|---|
| 0 Interest + readiness flags | FormsConnect | Yes (this form) |
| 1 Identity confirmation | Core + future QC | No — protected |
| 2 License validation | AE knowledge + staff / boards | No |
| 3 License status & disciplinary review | AE + staff | No |
| 4 Experience & trade review | Staff + RoseOS | No |
| 5 Geographic coverage | QMOS availability | Partial prefs on form |
| 6 Availability | QMOS | Partial on form |
| 7 Permitted screening | Protected process | **Never** public form |
| 8 References | Protected | No |
| 9 Supporting documentation | DocumentCollection / QC | No |
| 10 Agreements | FormsConnect or QC docs | Later versions |
| 11 Periodic reverification | RoseOS schedule | Annual/policy |

**Hard rule:** Completing stage 0 does **not** set QMOS `verificationStatus = Verified` or `status = Verified`.

### 3.4 Path switching

- User selected Explore but readiness flags strong → RoseOS may recommend Verification candidate (staff confirms).  
- User selected Verified but thin license/experience → RoseOS routes as Standard Lead + nurture, not Verified.  
- Staff may move stages via controlled transitions only (§5).

---

## 4. ComplianceCore identity and upsert contract

### 4.1 Role

ComplianceCore is the **primary identity record** for the person/business profile. QMOS never creates a competing editable Core identity.

### 4.2 Match inputs (normalized — proposed)

| Input | Normalize | Weight class |
|---|---|---|
| Email | lower trim | Strong |
| Mobile phone | E.164 | Strong |
| Legal name | casefold, strip punctuation | Medium |
| License number + jurisdiction | strip spaces/dashes; jurisdiction code | Strong when present |
| City / state | state code | Weak context |

**Forbidden:** silent merge on name-only.

### 4.3 Match outcomes

| Outcome | Core action | Confidence | Downstream |
|---|---|---|---|
| `exact_match` | Update/append allowed fields only | high | Reuse `cca_client_profile_id` |
| `probable_match` | **No auto-merge** — queue for staff | medium | Hold QMOS create **or** create lead flagged `identity_review_required` |
| `no_match` | Create Core profile at **lead** lifecycle stage | n/a | New `cca_client_profile_id` |
| `conflict` | No write of trusted fields; escalate | — | Staff resolution |

### 4.4 Upsert rules (trusted vs applicant-asserted)

| Field class | On match | On create |
|---|---|---|
| **Trusted Core** (prior verified legal name, verified contacts, established ids) | **Do not silently replace**; append alternate contact / note conflict | Set from submission |
| **Applicant-asserted** (self-reported license status, prefs) | Append / update “asserted” layer; never overwrite trusted verification facts | Store as asserted |
| **Consent / submission meta** | Always append new submission record | Append |

Proposed Core API (logical):

```
POST /core/v1/profiles/resolve-from-intake
Request:
  submission_id, form_version, consent_version,
  identity: { first, middle, last, preferred, email, phone, city, state },
  licenses[]: { number, jurisdiction, … },
  path_intent, source_channel
Response:
  cca_client_profile_id,
  match_outcome: exact_match|probable_match|no_match|conflict,
  match_confidence: 0–1,
  match_candidates[] (if probable),
  profile_lifecycle_stage,
  field_write_report[]  // what was written vs held
```

### 4.5 What Core returns to QMOS / RoseOS

- `cca_client_profile_id` (**required** before durable QMOS reflection in steady state)  
- `match_outcome` + `match_confidence`  
- Optional display name / primary email (read-only mirror hints)  
- Flags: `identity_review_required`, `duplicate_suspect`

### 4.6 QMOS rule

QMOS **references** Core via `cca_client_profile_id`. Staff edit qualifier-domain fields in QMOS; identity corrections that affect the person SoT go through Core (or staff tools that write Core).

---

## 5. QualifierManageOS reflection and status model

### 5.1 Reflection principle

On intake (when wiring approved):

1. Ensure Core `cca_client_profile_id` exists.  
2. Find existing QMOS qualifier by `cca_client_profile_id` (preferred) or staff-resolved duplicate.  
3. If none: create `Q-###` with intake defaults.  
4. Store FormsConnect submission reference + consent/form versions.  
5. **Do not** copy Core into an independently authoritative identity blob — mirror display fields only as needed for staff UX, refreshable from Core.

### 5.2 Proposed columns (non-destructive — not applied)

| Column | Table | Purpose |
|---|---|---|
| `cca_client_profile_id` | `qualifiers` | uuid/text unique nullable — Core FK |
| `formsconnect_submission_id` | `qualifiers` or child `qualifier_intake_submissions` | Latest or 1:N submissions |
| `intake_path` | `qualifiers` or submission child | `standard_lead` · `verified_path` · `unsure_routed_*` |
| `intake_stage` | `qualifiers` | Controlled stage enum (below) |
| `identity_match_outcome` | submission child | From Core |
| `identity_match_confidence` | submission child | From Core |
| `auditengine_id` | already exists | Option A — AE matrix; **not** Core id |

**Prefer** child table `qualifier_intake_submissions` for submission history (1 qualifier : many submissions) so resubmits do not destroy prior consent versions.

### 5.3 Staff-visible personas (Rose list → model)

| Staff sees | Proposed derivation |
|---|---|
| New qualifier lead | `intake_stage = new_lead` · `status ∈ {New, Intake Started}` |
| Existing qualifier | `cca_client_profile_id` matched existing `Q-` with prior history |
| Verification candidate | `intake_stage = verification_candidate` · `verificationStatus ∈ {Not Started, In Progress, …}` but **not** Verified |
| Verified qualifier | `verificationStatus = Verified` **and** staff/program gate completed (never auto from form) |
| Placement-ready qualifier | `availableForPlacement = true` + license health usable + no Do-Not-Place |
| Placed qualifier | Active `PLACEMENTS` row |
| Inactive / unavailable | `status ∈ {Inactive, Paused}` or `availabilityStatus ∈ {Not Available, Paused}` |

### 5.4 `intake_stage` (proposed controlled enum)

```
new_lead
identity_review_required
staff_review
nurture
verification_candidate
verification_in_progress
verification_blocked_missing_info
verified_program_member      -- only after controlled grant
placement_candidate
placed
inactive
do_not_place_hold
```

Transitions are **staff- or RoseOS-orchestrated**, never raw form POST.

### 5.5 Mapping to existing QMOS enums (live today)

| Live field | Intake use |
|---|---|
| `status` | Keep vocabulary; prefer `New` / `Intake Started` / `Documents Requested` / `Under Review` early; `Verified` only when program says |
| `verificationStatus` | `Not Started` on submit; progress via workflow — **not** jump to `Verified` |
| `backgroundCheckStatus` / `creditCheckStatus` | Remain `Not Started` until protected process |
| `availableForPlacement` | Default `false` on new lead |
| `adminOnlyNotes` | Staff notes; Sales Viewer hidden |

### 5.6 Domain data QMOS owns (unchanged intent)

License history, availability, placement status, review status, risk indicators, verification **progress**, documents (status / vault refs), matches, placements, staff actions — per `DATA_MODEL.md`.

### 5.7 Staff management capabilities (target UX — not built this lane)

When separately approved, authorized staff should:

- View original FormsConnect submission + form/consent versions  
- Open linked ComplianceCore profile  
- See duplicate / match confidence  
- Request missing information  
- Move controlled stages  
- Mark verification candidate / start verification workflow  
- Review RoseOS recommendations + AE-supported factors  
- Approve / decline / needs-more-info on suggestions (existing Match Center pattern)  
- Notes + append-only audit history  

Existing audited writes today: `approveMatch`, `setRisk` only.

---

## 6. RoseOS routing and recommendation responsibilities

### 6.1 RoseOS owns (not the form UI)

- Post-submit workflow routing  
- Queue selection + prioritization  
- Whether path_intent is honored or overridden  
- Missing-information request plans  
- Verification readiness scoring (policy rules)  
- Placement-candidate eligibility  
- Draft match suggestions + explainability factors  
- Escalation to human identity review  

**Do not** hard-code long-term decision trees into FormsConnect beyond collect/show conditionals.

### 6.2 Routing inputs

- `path_intent` + interest multi-select  
- Verification readiness flags  
- License self-report completeness  
- Core `match_outcome` / confidence  
- Existing QMOS history if profile already linked  
- AuditEngine knowledge responses (§7)  
- Open needs (when match slice on)  

### 6.3 Example routing outcomes

| Condition | Route |
|---|---|
| Explore + learn_more only | `nurture` queue · low priority |
| Seeking placement + usable license self-report | `staff_review` · match-prep |
| Verified path + strong readiness + license | `verification_candidate` |
| Verified path + weak license/experience | `staff_review` as standard lead + education |
| Core `probable_match` / `conflict` | `identity_review_required` **before** enrichment |
| Existing placed qualifier resubmit | Attach submission; notify owner; no duplicate Q- |

### 6.4 Recommendations (future Match Center feed)

Suggestions are **decision support**. Language: “Suggested”, “Possible fit”, “Best fit” — never “guaranteed”, “legal determination”, or “final placement”.

Explainability factors (align with existing `MATCHES.factors`):

- Trade / license-class alignment  
- State / jurisdiction eligibility  
- License status (asserted vs AE-confirmed — labeled honestly)  
- Availability  
- Geographic preference  
- Experience  
- Company / opportunity requirements  
- Compliance gaps identified  
- Verification status  

Human staff: approve / reject / needs more info / hold — append-only audit (extend `decision_audit_log` actions when built).

### 6.5 What RoseOS must not do

- Auto-approve matches  
- Auto-grant Verified  
- Silent Core merges  
- Call AE formulas onto `[CLIENT-FACING]` surfaces  
- Bypass QMOS Do-Not-Place holds  

---

## 7. AuditEngine knowledge inputs and outputs

### 7.1 Role

AuditEngine supplies **regulatory, licensing, trade, jurisdiction, risk, and compliance knowledge** used by RoseOS. QMOS must **not** recreate AE’s knowledgebase or scoring engine.

### 7.2 Knowledge request (logical)

```
AE.KnowledgeRequest
  purpose: intake_enrichment | verification_support | match_support
  cca_client_profile_id
  qmos_qualifier_id?          // if already reflected
  licenses[]: { number, jurisdiction, trade_asserted }
  jurisdictions_of_interest[]
  trade_classifications[]
```

### 7.3 Knowledge response (logical)

```
AE.KnowledgeResponse
  request_id
  license_lookups[]: {
    jurisdiction, number,
    board_status_known: bool,
    status_summary?,            // staff-safe
    disciplinary_flags_summary?, // staff-safe; no raw PII dumps to public
    as_of
  }
  jurisdiction_rules_hints[]    // e.g. dual-hat / attach constraints — advisory
  trade_taxonomy_alignment[]    // map free-text → AE classes
  risk_taxonomy_tags[]          // for RoseOS — not client-facing scores
  gaps[]                        // missing info to collect later
  auditengine_matrix_ids?       // for later Option A attach — seams still OFF
```

### 7.4 Display rules

| Surface | Allowed |
|---|---|
| QMOS staff | AE-supported **reasoning factors** (plain language); no formula/weights/bands catalog |
| Public form / QualifierConnect applicant | **No** AuditEngine branding, scores, or internal taxonomy |
| Partner/client | Blank lanes = NO |

### 7.5 Sync relationship

Nullable `auditengine_id` on QMOS tables stays Option A. Intake design **does not** activate sync. When a future sync slice attaches ids, it follows `SYNC_INTEGRATIONS_V1_PROPOSAL.md` after Rose shape yes.

---

## 8. Future QualifierConnect claim and continuation flow

### 8.1 Design goal

Avoid rebuilding intake when QualifierConnect ships. Public form is **stage 0**; QC is the protected continuation surface.

### 8.2 Claim / activate (future)

```
Applicant has submission_id + email
  → QualifierConnect “Claim profile”
  → Verify email / magic link / approved auth
  → Resolve cca_client_profile_id (Core)
  → Bind applicant auth subject ↔ Core profile
  → Open continuation checklist based on intake_stage / path
```

### 8.3 Continuation capabilities (future QC)

- Complete additional information  
- Upload documents (DocumentCollection)  
- Review licenses  
- Set availability / geographic preferences  
- Compensation / opportunity preferences where appropriate  
- Track verification progress (status-only)  
- Respond to placement opportunities  
- Maintain **approved** portions of profile (Core/QMOS field ownership matrix — §13)  

### 8.4 What QC must not become

- A second identity SoT  
- A place that grants Verified without workflow  
- A bypass of staff Do-Not-Place / approval  

### 8.5 Handoff artifact from intake

Store on submission / reflection:

- `claim_token_hint` strategy (opaque token issued later — **not** in this lane)  
- `continuation_checklist_id` from RoseOS  
- Prefill map: form answers → QC fields (asserted layer)

**This lane:** architecture only — no QC build, no applicant accounts.

---

## 9. Duplicate-resolution rules

### 9.1 Principles

1. ComplianceCore is authoritative for **who the person is**.  
2. QMOS is authoritative for **qualifier-domain operations**.  
3. No silent merge on name-only.  
4. Uncertain matches → human review.  

### 9.2 Scenarios

| Scenario | Rule |
|---|---|
| Existing Core contact becomes qualifier lead | Core match → same `cca_client_profile_id` → create QMOS reflection if missing |
| Existing qualifier submits again | Match Core + existing `Q-` → append submission row; refresh asserted prefs; notify `internalOwner` |
| Same person, second email | Core probable_match on phone/license → staff merge in Core; QMOS follows profile_id |
| Multiple licenses, one person | One Core profile · one Q- · many `LICENSES` rows |
| License tied to multiple historical companies | License rows + notes; company association is history — not duplicate people |
| Business contact ≠ license holder | Separate Core profiles when identities differ; link via relation type later if Rose defines; do not collapse |
| Staff unsure | `identity_review_required`; dual candidates visible; no auto-merge |

### 9.3 QMOS duplicate keys (lookup order when wiring)

1. `cca_client_profile_id`  
2. Staff-confirmed merge  
3. **Never** auto-merge on `fullName` alone  
4. Email match is a **hint** that must reconcile through Core  

### 9.4 Manual staff tools (future)

- Side-by-side candidate compare  
- “Link to existing Q-” / “Create new Q-”  
- “Send to Core identity review”  
- Full audit of merge/link decisions  

---

## 10. Consent, privacy, and audit requirements

### 10.1 Consent

- All consent copy lives in **FormsConnect** (versioned).  
- Each submission stores `consent_version` + `form_version` + timestamp + checkbox states.  
- Resubmits store a **new** consent artifact; do not overwrite prior.  
- Required acknowledgments include: contact permission, accuracy, privacy notice, **no placement guarantee**, **submission ≠ verification**.  

### 10.2 Privacy / data minimization

| Collect on public form v1 | Defer to protected QC / staff |
|---|---|
| Name, email, phone, city/state | Government ID images |
| Self-reported license basics | Screening reports / credit raw data |
| Preferences + readiness flags | Disciplinary raw case files |
| Consents | SSN / ITIN / DOB (unless Rose documents legal need) |

Screening remains **status-only** in QMOS (`vault://status-only` pattern) — never store reports in QMOS.

### 10.3 Audit

| Event | Audit store |
|---|---|
| Form submit | FormsConnect submission log |
| Core resolve/upsert | Core audit |
| QMOS reflection create/update | QMOS `decision_audit_log` (extend actions) or intake audit table |
| RoseOS route / suggest | Orchestration audit (RoseOS) + factors snapshot on match row |
| Staff approve/reject/more info | QMOS `decision_audit_log` (existing pattern) |
| Identity merge/link | Core + QMOS staff action audit |

### 10.4 Access

- Public form: applicant sees only their submit UX.  
- QMOS: staff role-gated (`Sales Viewer` cannot see admin-only notes).  
- AE internals: staff-safe summaries only; no client-facing AE exposure.  

---

## 11. Required migrations, APIs, and system dependencies

### 11.1 QMOS migrations (proposed — **not authored/applied this lane**)

| Proposed id | Change | Destructive? |
|---|---|---|
| `0013_qualifier_core_link_v1` | `qualifiers.cca_client_profile_id` uuid UNIQUE NULL + index | No |
| `0014_qualifier_intake_submissions_v1` | Child table: submission_id, form/consent versions, path_intent, answers jsonb or pointer, match_outcome, confidence, created_at | No |
| `0015_intake_stage_v1` | `qualifiers.intake_stage` text + check constraint | No |
| Later | Extend `decision_audit_log.action` / `entity_type` for intake + identity_link | No (additive constraints) |

**Do not apply** until Rose shape + apply yes. Live journal remains `0012`.

### 11.2 APIs / contracts (logical dependencies)

| Contract | System | Status this lane |
|---|---|---|
| FormsConnect submission export / event | FormsConnect | Spec only |
| `POST /core/v1/profiles/resolve-from-intake` | ComplianceCore | Spec only |
| QMOS `reflectFromIntake` internal RPC | QMOS | Spec only |
| RoseOS intake router | RoseOS | Spec only |
| AE KnowledgeRequest/Response | AuditEngine | Spec only |
| QualifierConnect claim | QC | Future |

### 11.3 System dependencies

| Dependency | Need |
|---|---|
| FormsConnect | Form builder + versioning + consent |
| ComplianceCore | Identity resolve/upsert + `cca_client_profile_id` |
| QMOS Supabase | Non-destructive columns/tables when approved |
| RoseOS | Orchestration host |
| AuditEngine | Knowledge API (staff-safe) |
| DocumentCollection | Later docs — status consumer in QMOS |
| CSV staff import | Optional reuse for staff-assisted leads (same Core-first rules) |

### 11.4 Explicit non-dependencies this lane

- Public DNS for form  
- Webhooks enabled  
- Sync worker  
- Applicant auth  
- QualifierConnect app  

---

## 12. Proposed implementation phases

| Phase | Name | Includes | Exit gate (Rose yes each) |
|---|---|---|---|
| **D0** | Design package (this doc) | 13 returns · contracts · field map | Shape yes / revise |
| **D1** | FormsConnect draft form | Build form in FC · inactive · consent versions | Preview yes · **activate = separate** |
| **D2** | Core resolve contract stub | Implement resolve API in Core nonprod | Contract test yes |
| **D3** | QMOS schema additive | `0013`–`0015` on nonprod → then prod apply yes | Apply yes |
| **D4** | Orchestration dry-run | RoseOS router + AE knowledge in nonprod; **no public traffic** | Dry-run yes |
| **D5** | Staff intake console (QMOS) | View submission · stages · identity flags · queues | Staff preview yes |
| **D6** | Public form pilot | Limited activate · monitoring · no Verified auto | **Public activate yes** |
| **D7** | Match suggestions feed | RoseOS → Match Center factors; human approve only | Seam/slice yes |
| **D8** | QualifierConnect claim | Claim + continuation checklist | QC build yes (separate lane) |

**CSV staff-assisted import:** can parallel D5 as internal-only, still Core-first, same duplicate rules.

Hard stop: D6+ require separate lane approvals. This package ends at **D0** until Rose says otherwise.

---

## 13. Exact decisions still needed from Rose

Please answer **yes / no / pick** (blank = no):

### Ownership & IDs

1. Confirm Core foreign key on QMOS qualifiers is named **`cca_client_profile_id`** (uuid) — **Y/N**?  
2. Confirm AE link stays separate as Option A **`auditengine_id`** — **Y/N**?  
3. One QMOS `Q-` per Core person profile even with many licenses — **Y/N**?

### Form

4. Approve form key `cca.qualifier_lead_intake.v1` and section/conditional map in §2 — **Y/N / revise**?  
5. Public v1 excludes SSN/DOB/gov ID/screening reports — **Y/N**?  
6. Max additional licenses on public form: **3 / 5 / other**?  
7. Path labels copy OK (`Explore` / `Verified path` / `Not sure`) — **Y/N / supply copy**?

### Journeys & status

8. Approve `intake_stage` enum in §5.4 — **Y/N / edit list**?  
9. May RoseOS override user path_intent based on readiness — **Y/N**?  
10. Verification program stages 1–11 in §3.3 — any mandatory reorder/add/cut?

### Duplicates

11. On Core `probable_match`: **(A)** block QMOS create until staff resolves · **(B)** create Q- flagged `identity_review_required` — pick  
12. Business contact who is not license holder: always **separate Core profiles** until you define a relation model — **Y/N**?

### Consent / legal

13. Who supplies final privacy notice URL + legal consent text — **Rose / counsel / FormsConnect owner**?  
14. Any jurisdiction where public form **must** collect extra identity fields at stage 0?

### Phasing / activation

15. After D0 shape yes, next build slice: **D1 FormsConnect draft** · **D2 Core stub** · **D3 QMOS columns** · **other** — pick one  
16. Staff CSV import in parallel with D5 — **Y/N**?  
17. Any mockup/prototype in QMOS UI this lane — **no (docs only)** · **yes internal disconnected**?

### Ecosystem

18. Trade classification list source for the form: **free text v1** · **AE taxonomy dropdown** · **hybrid** — pick  
19. Should nurture-only explores create a Core profile immediately — **Y/N**?  
20. Partner-share or public form activation in scope of any near-term yes — **NO expected; confirm**?

---

## Appendix A — Language lock (suggestions)

Use: suggested · possible fit · best fit · decision support · staff review required  

Do **not** use on applicant or staff primary CTAs: guaranteed match · legally cleared · verified by submit · automatic placement  

## Appendix B — Relationship to existing proposals

| Doc | Relationship |
|---|---|
| `DATA_MODEL.md` | Enums + Option A preserved |
| `migrations/SYNC_INTEGRATIONS_V1_PROPOSAL.md` | Intake does not turn sync on; AE knowledge calls are a **separate** future orchestration concern |
| Live staff UI | Unchanged by this design branch |

## Appendix C — Out of scope checklist

- [ ] Public form live  
- [ ] Webhooks / external writes  
- [ ] Sync seams ON  
- [ ] Applicant accounts  
- [ ] QualifierConnect build  
- [ ] Verified from submit  
- [ ] Destructive migrations  
- [ ] QMOS code-owned form schema as SoT  

---

*End of 13-return design package. Waiting on Rose §13 decisions before any build or activation.*
