# Issue #4 — Open questions for Rose

1. **Audit numbering:** table rows `#1–#59` vs “52 fields / 35 gaps” and original OUT list `#57–#60` for portal fields. Which numbering is canonical for citations in migrations?
2. **DOB (#8):** proposing Reject/out-of-QMOS for staff OS unless counsel requires — confirm.
3. **Travel Willingness (#40):** bucketed ComplianceConnect-owned (portal); QMOS keeps `remote_ok` / `in_person_required`. Confirm vs adding spec enum on `availability`.
4. **Disciplinary flag (#47) / Internal risk rollup (#48) / Document completeness (#51):** useful QMOS views but outside your safe-subset cut — OK to defer?
5. **CCA Qualifier Number (#2):** proposing Reject (keep `Q-###` only) — confirm.
6. **Enum SoT for placement status (#41):** portal picklist vs live QMOS vocabulary — pick one before any rename migration.
7. **`phone` → `mobile_phone`:** prefer rename column + view alias `phone`, or add `mobile_phone` and backfill from `phone` leaving `phone` deprecated?
8. **`full_name`:** prefer Postgres generated column vs view-only `v_qualifiers_public_fields` expansion? (Generated column needs PG version support in Supabase.)
9. **Rule 7:** confirm `verification_notes` + `restriction_summary` should be logged in LLM transition inventory as **human-authored by default** (no LLM call sites today).
10. **Outbound:** safe-subset adds no emitters; confirm no `qualifier.profile-updated.v1` until a later seam yes (Contract C ready when it does).
