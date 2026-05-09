# Sprint 4 Plan — AureliusPress

**Dates:** TBD  
**Team:** 1 engineer (solo)  
**Sprint Goal:** Deliver soft deletion for user-generated content and the Admin Settings Panel foundation, so that moderation can safely remove content without data loss and site behaviour can be configured at runtime.

---

## Capacity

| Person | Available Days | Est. Points | Notes |
|--------|---------------|-------------|-------|
| Paul | 8 of 10 | 16 pts | 80% capacity; 2-pt buffer for interrupts |
| **Total** | **8** | **16 pts** | 1 pt ≈ ~half day |

> **Buffer rule:** Plan to 16 pts. P2 items are the first cut if blocked.

---

## Sprint Backlog

### P0 — Soft Deletion (Phase 7)

Admin moderation controllers have a `@todo` for soft delete. Currently `destroy` hard-deletes fragments.

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S4-01 | Add `discarded_at` to `aurelius_press_fragments` table (migration) | 1 | None | 7.1 |
| S4-02 | Integrate `discard` gem on `AureliusPress::Fragment::Fragment` | 1 | S4-01 | 7.2 |
| S4-03 | Update admin `Comments` + `Notes` controllers to use soft delete | 2 | S4-02 | 7.3 |
| S4-04 | Filter soft-deleted fragments from all public queries (default scope) | 1 | S4-02 | 7.4 |

**P0 Total: 5 pts**

### P0 — Nested JournalEntry Notes (Phase 3 carry-over)

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S4-05 | `JournalEntry` nested notes (routes + controller + views) | 2 | None | 3.5 |

**P0 Total: 2 pts (running P0: 7 pts)**

### P1 — Admin Settings Panel (Phase 6)

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S4-06 | Define settings scope: what is configurable? (ADR + decision doc) | 1 | None | 6.1 |
| S4-07 | Settings store (key-value table or `rails-settings-cached` gem) | 2 | S4-06 | 6.3 |
| S4-08 | `AureliusPress::Admin::SettingsController` | 2 | S4-07 | 6.2 |
| S4-09 | Admin settings views (index + edit) | 1 | S4-08 | 6.4 |

**P1 Total: 6 pts**

### P1 — Pagination (Phase 9)

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S4-10 | Pagination on admin index actions (pagy or kaminari) | 1 | None | 9.1 |

**P1 Total: 1 pt (running P1 total: 7 pts)**

### P2 — Stretch: README + Reactions decision (Phase 9)

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S4-11 | Replace `README.md` boilerplate with real project docs | 1 | None | 9.3 |
| S4-12 | Reactions feature decision: keep (implement) or remove routes/model | 1 | None | 9.4 |

**P2 Total: 2 pts**

---

## Planned Capacity: 16 pts | Sprint Load: 16 pts (P2 is the buffer)

---

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| `discard` gem conflicts with existing associations (has_many :comments etc.) | Breaks soft delete scoping | Add `default_scope` to Fragment only; check all join queries |
| Settings scope creep (too many configurable keys) | Slows S4-06/07/08 | Cap to ≤5 settings in Sprint 4: site name, site description, registration open/closed, default visibility, comments enabled globally |
| `rails-settings-cached` gem version incompatibility | Slows S4-07 | Check Gemfile compatibility before choosing; custom key-value table is the fallback |
| Pagination gem choice affects all index views | S4-10 requires view changes | Pick pagy (lightweight); add pagy helper to ApplicationController; update one admin controller + view, then repeat |

---

## Definition of Done

- [x] Soft-deleted fragments hidden from public views, visible to admins
- [x] Admin can soft-delete comments/notes; hard delete is gone from admin moderation
- [x] JournalEntry notes CRUD functional
- [x] Settings store defined, seeded, readable and writable via admin UI
- [x] At least one admin index action paginated
- [x] All new controllers covered by request specs
- [x] All new specs green (`bundle exec rspec`)
- [x] No RuboCop offences
- [x] PR opened against `master`

---

## Key Dates

| Date | Event |
|------|-------|
| Sprint start | Begin S4-01 (migration) + S4-06 (settings scope decision) in parallel |
| Mid-sprint | Soft deletion + JournalEntry notes done; begin settings panel |
| Code freeze | All P0 + P1 done |
| Sprint end | PR review + ship |

---

## Sprint 4 Retrospective — 2026-04-28

**What shipped?**
All 10 stories (S4-01 through S4-10). Both P0 epics (Soft Deletion + JournalEntry Notes) and the full P1 epic (Admin Settings Panel + Pagination) delivered. P2 stretch items (README, Reactions decision) intentionally deferred to Sprint 5 — they were always the buffer.

**Points delivered:** 14/14 committed (P0 + P1). P2 = 0/2 (deferred by design).

**What slowed us down?**
- `pagy` gem resolved to v43.5.3, which has a completely rewritten API (no `Pagy::Backend` / `Pagy::Frontend` modules). Required reading gem source to find the correct `Pagy::Method` + `@pagy.series_nav` pattern. ~1hr overage on S4-10.
- Feature specs for comment/note soft-deletion were using "deleted successfully" flash; the discard gem changed the controller notice to "discarded successfully". Quick fix but required a targeted debug pass.

**What changes next sprint?**
- Before adding any gem, check its version's API against the installed version — don't assume the README matches what bundler resolves to.
- When soft-delete changes a flash message, update the feature specs in the same commit as the controller change.

**Velocity tracker:**

| Sprint | Planned (committed) | Delivered | Velocity |
|--------|-------------------|-----------|----------|
| Sprint 1 | 16 pts | 16 pts | 16 |
| Sprint 2 | 14 pts | 18 pts | 18 |
| Sprint 3 | 16 pts | 16 pts | 16 |
| Sprint 4 | 14 pts | 14 pts | 14 |
| **Rolling avg** | — | — | **16** |

---

## Sprint 5 Preview (what this unlocks)

With soft deletion and settings shipped, Sprint 5 can target:
- SimpleCov coverage target enforcement in CI (Phase 9, item 9.5)
- Feature specs: JournalEntry CRUD (Phase 8, item 8.4)
- Feature specs: group membership join/leave (Phase 8, item 8.5)
- Feature specs: likes on all resource types (Phase 8, item 8.9)
- API v1 expansion (catalogue quotes pagination, tag search)
