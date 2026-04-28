# Sprint 5 Plan — AureliusPress

**Dates:** TBD  
**Team:** 1 engineer (solo)  
**Sprint Goal:** Close the test coverage gap unlocked by Sprints 3 & 4, complete the Likes system, and harden CI — so the engine is fully exercised before any new feature work begins.

---

## Capacity

| Person | Available Days | Est. Points | Notes |
|--------|---------------|-------------|-------|
| Paul | 8 of 10 | 16 pts | 80% capacity; 2-pt buffer for interrupts |
| **Total** | **8** | **16 pts** | 1 pt ≈ ~half day |

> **Buffer rule:** Plan to 16 pts. P2 items are the first cut if blocked.

---

## Sprint Backlog

### P0 — Likes System Completion (Phase 5)

The Likes infrastructure (model, policy, routes, controller shell) shipped in Sprint 1. The `update` action was stubbed and never implemented, and Turbo Stream responses were never verified across all likeable types.

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S5-01 | Implement `LikesController#update` (route exists, action missing) | 1 | None | 5.1 |
| S5-02 | Verify Turbo Stream like/unlike responses on all likeable types (documents, content blocks, fragments) | 2 | S5-01 | 5.2 |
| S5-03 | Like count display on public views | 1 | S5-02 | 5.3 |

**P0 Total: 4 pts**

### P0 — Test Coverage Gaps (Phase 8)

Sprint 4 shipped soft deletion, JournalEntry notes, and the settings panel. These feature specs were deferred and are now due.

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S5-04 | Feature specs: JournalEntry CRUD (create, read, update, delete, privacy enforcement) | 2 | None | 8.4 |
| S5-05 | Feature specs: group membership join/leave | 2 | None | 8.5 |
| S5-06 | Feature specs: likes on all resource types | 2 | S5-01 | 8.9 |
| S5-07 | Fix groups controller spec: uses integer `id` but controller does `find_by!(slug:)` — pre-existing failure in 8 examples | 1 | None | — |

**P0 Total: 7 pts (running P0: 11 pts)**

### P1 — CI Quality & Polish (Phase 9)

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S5-08 | SimpleCov coverage target enforcement in CI (fail build below threshold) | 1 | None | 9.5 |
| S5-09 | README — replace Rails boilerplate with real project docs | 1 | None | 9.3 |
| S5-10 | Reactions feature decision: keep (implement) or remove routes/model | 1 | None | 9.4 |

**P1 Total: 3 pts**

### P2 — Stretch: API v1 Expansion

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S5-11 | Catalogue quotes pagination + tag search endpoints (API v1) | 2 | None | — |

**P2 Total: 2 pts**

---

## Planned Capacity: 16 pts | Sprint Load: 14 pts P0+P1 + 2 pts P2 buffer

---

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Turbo Stream like/unlike coverage is broader than expected (many likeable types) | S5-02 grows beyond 2 pts | Cap to documents + fragments in S5; content blocks can slip to S6 |
| Groups controller spec fix uncovers deeper factory/slug issues | S5-07 cascades | Time-box to 1 pt; if broader, open a separate PR |
| SimpleCov baseline is lower than expected, forcing spec catch-up before CI can enforce | S5-08 blocked | Set an achievable threshold first (e.g. 70%) and tighten in S6 |

---

## Definition of Done

- [x] `LikesController#update` implemented and request-spec covered
- [x] Turbo Stream like/unlike verified on at least documents and fragments
- [x] Like counts visible on public views (already in engagement bar)
- [x] JournalEntry CRUD feature spec green
- [x] Group membership join/leave feature spec green
- [x] Likes feature spec green across resource types
- [x] Groups controller spec fixed (slug-aware params)
- [x] SimpleCov threshold enforced in CI
- [x] All new/fixed specs green (`bundle exec rspec`)
- [x] No RuboCop offences
- [x] PR opened against `master`

---

## Key Dates

| Date | Event |
|------|-------|
| Sprint start | S5-01 (Likes update action) + S5-07 (groups spec fix) in parallel — both are quick wins |
| Mid-sprint | Likes done; feature spec trio (S5-04/05/06) in progress |
| Code freeze | All P0 + P1 done |
| Sprint end | PR review + ship |

---

## Sprint 5 Retrospective — 2026-04-28

**What shipped?**
All 10 P0+P1 stories delivered. S5-11 (API v1 expansion, P2 buffer) deferred to Sprint 6 as planned.

**Points delivered:** 13/14 committed (P0+P1). S5-03 was already done before the sprint started (like counts already in the engagement bar). S5-11 (P2) = 0/2 deferred.

**What slowed us down?**
- S5-06 (likes on Catalogue::Quote): Two separate issues hit back-to-back — Capybara `Ambiguous match` from a pre-existing duplicate DOM ID bug (`_comments_and_notes` and engagement bar both use `dom_id(resource, :engagement)`), then a `StaleElementReferenceError` after Turbo Stream replaced the DOM node mid-test. Required two targeted spec rewrites to work around. Spawned a separate bug-fix task for the underlying DOM ID collision.
- CI was running Minitest (`bin/rails test`), not RSpec — the test suite had never run in CI. Fixed as part of S5-08.

**What changes next sprint?**
- Before writing any feature spec involving Turbo Stream, check whether multiple elements on the page share the same DOM ID. Fix the ID upstream; don't work around it in specs.
- Check CI config early — confirm it actually runs the test suite before assuming CI coverage.

**Velocity tracker:**

| Sprint | Planned (committed) | Delivered | Velocity |
|--------|-------------------|-----------|----------|
| Sprint 1 | 16 pts | 16 pts | 16 |
| Sprint 2 | 14 pts | 18 pts | 18 |
| Sprint 3 | 16 pts | 16 pts | 16 |
| Sprint 4 | 14 pts | 14 pts | 14 |
| Sprint 5 | 14 pts | 13 pts | 13 |
| **Rolling avg** | — | — | **15** |

---

## Sprint 6 Preview (what this unlocks)

With test coverage solid and Likes complete:
- Phase 2: Public Comments & Notes on Document types (2.1–2.12) — the largest remaining feature chunk (~4–5 days)
- API v1 expansion (if S5-11 slips)
- Admin pagination extended to remaining index actions (beyond users)
