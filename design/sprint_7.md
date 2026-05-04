# Sprint 7 Plan — AureliusPress

**Dates:** 2026-05-04  
**Team:** 1 engineer (solo)  
**Sprint Goal:** Eliminate all pre-existing test debt, fix the duplicate DOM ID bug, and finish the remaining backlog coverage gaps — leaving the suite fully green for the first time.

---

## Capacity

| Person | Available Days | Est. Points | Notes |
|--------|---------------|-------------|-------|
| Paul | 8 of 10 | 16 pts | 80% capacity; 2-pt buffer for interrupts |
| **Total** | **8** | **16 pts** | 1 pt ≈ ~half day |

> **Buffer rule:** Plan to 16 pts. P1 items are the first cut if blocked.

---

## Sprint Backlog

### P0 — Fix Pre-existing Test Failures (Backlog 8.7)

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S7-01 | Fix document comments/notes request spec failures (~22 failing examples across nested document controllers) | 3 | None | 8.7 |
| S7-02 | Fix admin content block feature spec failures | 2 | None | 8.7 |
| S7-03 | Fix admin user CRUD feature spec failures | 2 | None | 8.7 |

**P0 Total: 7 pts**

### P1 — Carry-overs + Remaining Coverage

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S7-04 | Fix duplicate DOM ID bug: `_engagement_bar` and `_comments_and_notes` both render `dom_id(resource, :engagement)` — carried from S6-09 | 2 | None | — |
| S7-05 | Remove Tyrian Purple mockup scaffold: route, `MockupsController`, view, `tyrian_purple_mockup_spec.rb`, and design docs (`prd_tyrian_purple_ui.md`, `system_design_tyrian_purple_ui.md`, `backlog_tyrian_purple_ui.md`) | 1 | None | 10.1 |
| S7-06 | Feature specs for public catalogue items — authors, sources, quotes read-only views (Backlog 8.6) | 2 | None | 8.6 |

**P1 Total: 5 pts**

---

## Planned Capacity: 16 pts | Sprint Load: 12 pts P0+P1 + 2 pts buffer + 2 pts P2

---

## Out of Scope

| Item | Reason | Backlog Ref |
|------|--------|-------------|
| NanoCSS migration | Deferred; Pico coupling should not deepen in the meantime | — |
| New feature development | Sprint is purely debt + coverage — no new controllers or views | — |

---

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| 41 pre-existing failures span multiple controller namespaces; root causes unknown until investigated | S7-01/02/03 estimates may be off | Run full suite first to triage failures by file; stop and propose if any single file has >10 failures with non-obvious root cause |
| Duplicate DOM ID fix (S7-04) may require partial redesign if Turbo Stream relies on the conflicting ID | Wider refactor than estimated | Check all Turbo Stream targets referencing `dom_id(resource, :engagement)` before changing the ID |
| Tyrian Purple removal touches design docs — confirm nothing references them before deleting | Broken links in docs | `grep` for references before removal |

---

## Definition of Done

- [ ] All document comments/notes request specs green
- [ ] All admin content block feature specs green
- [ ] All admin user CRUD feature specs green
- [ ] Duplicate DOM ID resolved; engagement bar + comments/notes Turbo Streams both target correct IDs
- [ ] Tyrian Purple scaffold fully removed; no remaining references in routes, code, or design docs
- [ ] Feature specs for public catalogue items (authors, sources, quotes) green
- [ ] Full suite green (0 failures, `tyrian_purple_mockup_spec` deleted not excluded)
- [ ] No RuboCop offences on introduced/modified files
- [ ] PR opened against `master`

---

## Key Dates

| Date | Event |
|------|-------|
| Sprint start | Triage full suite; begin S7-01 (document request specs) |
| Mid-sprint | P0 failures resolved; begin P1 carry-overs |
| Code freeze | All P0 + P1 done; suite green |
| Sprint end | 2026-05-04 — PR review + ship |
