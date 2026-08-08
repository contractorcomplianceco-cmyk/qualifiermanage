# Issue #5 — Full re-sync (seven sections) · 2026-08-08

Evidence-cited status for Rose. Propose-only work authored this pass; **pushes may be blocked on agent git credentials** — confirm remote tips after Carmen push.

---

## 1. PR #2 — Qualifier Lead Intake

- **Branch:** `cursor/qualifier-lead-intake-design-97db`
- **Prior tip:** `fe8c6fd` (2026-08-02) — design package only; not merged.
- **This pass:** redlines commit `e7981d4` — C-1 / C-2 / C-3 applied in `docs/qualifier-lead-intake/ARCHITECTURE.md` + README.
  - **C-1:** identity hold; no `cca_client_profile_id` on QMOS; §4.5–4.6 + §11 withdrawn; server-side resolve via `auditengine_id` mapping.
  - **C-2:** §7.1a RS-001/RS-002 validated-knowledge paragraph.
  - **C-3:** Contract C envelopes on §4.4 and §7.2/§7.3.
- **Merged / wired / applied:** **No.** Design lane only. Awaiting Rose re-review + §13 picks.

## 2. Sync integrations — issue #3 (Slice A)

- **State:** authored as `.PROPOSED` / docs (this pass) — **not applied**.
- **Paths:**
  - `docs/sync-integrations/FIELD_MAPS.md`
  - `docs/sync-integrations/stubs/*`
  - `migrations/0014_integration_events_slice_a_v1.sql.PROPOSED`
- **Live outbound / seams ON / cross-app traffic:** **None** (stubs refuse network).
- **Deps on issue #4:** None required to finish Slice A maps/table/stubs.
- **Need from Rose on Slice A:** none to finish authoring; still open Zoho / trigger / naming do not block. Need **shape + apply yes** before SQL runs.

## 3. Field-gap triage — issue #4

- **Triage:** complete → `docs/qualifier-profile-gap/TRIAGE.md`
- **Safe-subset migration:** `migrations/0013_qualifier_profile_alignment_v1.sql.PROPOSED`
- **Enum cross-check:** `docs/qualifier-profile-gap/ENUM_CROSSCHECK.md`
- **Open questions:** `docs/qualifier-profile-gap/OPEN_QUESTIONS.md`
- Sources used: Issue #4 audit table + PR #6 PDF + `634151a` excerpts in issue comment.

## 4. Staff deploy script

- **No change since 2026-08-01** (`fd458156` on `main`).
- Written-and-idle; no GitHub Actions; no Deployments API entries when last checked.
- Trigger = manual SSH only after Rose push-yes.
- Host `https://qualifiers.cagteam.net` → **401** without basic-auth (probed).
- `DEPLOYED_SHA.txt`: not readable without basic-auth credentials from this agent — treat as **unknown / likely never verified here**; no deploy run by this agent.

## 5. LLM stand-up (Rule 7 QMOS watch)

- **No change:** no LLM integration proposed, prototyped, wired, or live in QMOS.
- **Transition inventory (call sites):** **none** in repo (`QualifierManageOS.dc.html`, `qmos-api.js`, stubs).
- Issue #4 notes `verification_notes` / `restriction_summary` as human-authored by default; log if later LLM-written.
- No production model keys in repo.

## 6. Live QMOS state (post-PR #1)

- **Journal tip (docs):** `0012_seed_bulk_v1` @ `2026-08-01 00:08:04.923607+00` (`db5565c`).
- **Row counts / audit-log uniqueness:** **not re-probed this pass** (no staff JWT in agent). Targets remain the 0012 contract (qualifiers 289, licenses 1039, …). Say the word and I’ll pull with a staff session.
- **Debounce:** code on `main` since `0efb682`; live duplicate audit check still outstanding.
- **Schema drift vs 0012:** none authored/applied after 0012; `0013`/`0014` are `.PROPOSED` only.

## 7. Open items

**Actionable on Carmen**
- Land/push PR #2 redlines + issue #3/#4 branches once git write auth works.
- On Rose ask: live Supabase counts + audit uniqueness probe.
- Await Rose yes before any apply/deploy.

**Blocked on Rose**
- PR #2 re-review + §13 picks after C-1/C-2/C-3.
- Issue #4 open questions (numbering, DOB, travel, placement enum SoT, phone/full_name strategy).
- Shape + apply yes for `0013` / `0014`.
- Staff deploy push-yes + SHA.
- Slice B / Zoho / trigger / `auditengine_id` naming (explicitly later).
- Client/partner/public lanes = NO.

**Paused**
- Slice B, intake activation, honest UI stubs (export/add qualifier/etc.), go-live.
