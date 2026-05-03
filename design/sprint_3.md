# Sprint 3 Plan — AureliusPress

**Dates:** TBD  
**Team:** 1 engineer (solo)  
**Sprint Goal:** Deliver JournalEntry as a fully private document type and Group Memberships as a self-service UI so that users can write private content and participate in communities.

---

## Capacity

| Person | Available Days | Est. Points | Notes |
|--------|---------------|-------------|-------|
| Paul | 8 of 10 | 16 pts | 80% capacity; 2-pt buffer for interrupts |
| **Total** | **8** | **16 pts** | 1 pt ≈ ~half day |

> **Buffer rule:** Plan to 16 pts. P2 items are the first cut if blocked.

---

## Sprint Backlog

### P0 — JournalEntry Document Type (Phase 3)

JournalEntry exists as an STI type on `aurelius_press_documents` but has no controller, views, or policy enforcement.

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S3-01 | `AureliusPress::Document::JournalEntriesController` (full CRUD) | 3 | None | 3.1 |
| S3-02 | Views: index, show, new, edit, `_form` partial | 2 | S3-01 | 3.2 |
| S3-03 | Always-private enforcement: policy + model validation | 1 | S3-01 | 3.3, 9.2 |

**P0 Total: 6 pts**

### P0 — Group Memberships UI (Phase 4)

Model and associations exist; routes are commented out.

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S3-04 | Uncomment `resources :group_memberships` in routes.rb | 0.5 | None | 4.1 |
| S3-05 | `AureliusPress::Community::GroupMembershipsController` (create/destroy) | 2 | S3-04 | 4.2 |
| S3-06 | Views: join/leave buttons with Turbo Stream feedback | 1.5 | S3-05 | 4.3 |

**P0 Total: 4 pts (running P0 total: 10 pts)**

### P1 — Group Discovery Pages (Phase 4)

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S3-07 | Group show page: list members | 1.5 | S3-05 | 4.4 |
| S3-08 | Group index page: discoverable groups | 1.5 | None | 4.5 |

**P1 Total: 3 pts**

### P1 — JournalEntry Content Blocks (Phase 3)

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S3-09 | Nested content blocks for JournalEntry (reuse existing system) | 1 | S3-01 | 3.4 |

**P1 Total: 1 pt (running P1 total: 4 pts)**

### P2 — Deferred Views from Sprint 2 (Phase 2)

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S3-10 | Inline comment/note partials for content blocks | 1 | None | 2.12 |
| S3-11 | Views for catalogue comments/notes (Author, Source, Quote) | 1 | None | 2.19 |

**P2 Total: 2 pts**

---

## Planned Capacity: 16 pts | Sprint Load: 16 pts (P2 is the buffer)

---

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| JournalEntry STI may need a dedicated DB column for `always_private` enforcement | Slows S3-03 | Check current `documents` table schema; if `published_at`/`visibility` covers it, no migration needed |
| Group membership routes may conflict with existing nested routes | Slows S3-04/05 | Read full routes.rb before uncommenting; check for naming collisions |
| Turbo Stream join/leave may require a live member count update | S3-06 scope creep | Cap to join/leave button toggle only in Sprint 3; member count display is S3-07 |
| JournalEntry `_form` may need privacy controls removed/hidden (always private) | S3-02 UX complexity | Keep form simple: title + content only; no visibility selector |

---

## Definition of Done — Result

- [x] JournalEntry CRUD fully functional and always-private enforced at policy + model level
- [x] Group join/leave working with Turbo Stream feedback
- [x] Group show page lists members
- [x] Group index lists discoverable (non-private) groups
- [x] All new controllers covered by request specs
- [x] All new specs green (728 examples, 0 failures)
- [x] RuboCop clean
- [x] Brakeman clean
- [x] PR #66 opened against `master`

---

## Key Dates

| Date | Event |
|------|-------|
| Sprint start | Begin S3-01 (JournalEntriesController) |
| Mid-sprint | P0 complete; begin P1 group pages |
| Code freeze | All P0 + P1 done |
| Sprint end | PR review + ship |

---

## Velocity Tracker

| Sprint | Planned | Delivered | Velocity |
|--------|---------|-----------|----------|
| Sprint 1 | 16 | 16 | 16 |
| Sprint 2 | 14 | 18 | 18 |
| Sprint 3 | 16 | 16 | 16 |
| **Rolling avg** | | | **17** |

---

## Retrospective

**What shipped?**
All 11 stories (S3-01 through S3-11). 16 planned pts + 0 carry-over. All P0, P1, and P2 delivered.

**What went smoothly**
- JournalEntry was straightforward — model already had `ContentBlockContainer` and the Sluggable concern; only needed the controller, views, and validation
- Group Memberships controller was clean thanks to the existing `GroupMembershipPolicy`
- Deferred Sprint 2 views (S3-10/11) were pure view work with no surprises

**What surprised us**
- `Group#to_param` was missing — `param: :slug` in routes alone isn't enough; the model needs `to_param` for URL helpers to use slugs
- Admin groups controller broke silently when `to_param` was added (was using integer `find`, not `find_by!(slug:)`) — always check admin controllers when changing `to_param`
- JournalEntry model spec was asserting `visibility: :public_to_www` — the `:with_belt_and_braces` factory trait includes `visible_to_www`; always-private validation surfaced this immediately

**What to carry forward**
- When adding `to_param` to a model, grep for all admin controllers using `find(params[:id])` and update them
- JournalEntry notes (Phase 3, item 3.5) deferred to Sprint 4 — not blocked

---

## Sprint 4 Preview (what this unlocks)

With JournalEntry and Group Memberships shipped, Sprint 4 can target:
- Admin Settings Panel (Phase 6): define scope, build controller + views
- Soft Deletion (Phase 7): `discard` gem integration on fragments
- Nested JournalEntry notes (Phase 3, item 3.5)
- Pagination on admin index actions (Phase 9, item 9.1)
