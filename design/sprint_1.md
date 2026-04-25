# Sprint 1 Plan — AureliusPress

**Dates:** 2026-04-27 — 2026-05-08 (2 weeks)  
**Team:** 1 engineer (solo)  
**Sprint Goal:** Establish the full Pundit authorization layer and complete the Likes system so that every subsequent feature can be built on a secure, tested policy foundation.

---

## Capacity

| Person | Available Days | Est. Points | Notes |
|--------|---------------|-------------|-------|
| Paul | 8 of 10 | 16 pts | 80% capacity; 2-pt buffer for interrupts |
| **Total** | **8** | **16 pts** | 1 pt ≈ ~half day |

> **Buffer rule:** Plan to 16 pts. First stretch item cut if blocked.

---

## Sprint Backlog

### P0 — Must Ship (unblocks everything downstream)

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S1-01 | `AureliusPress::Fragment::CommentPolicy` + policy spec | 2 | None | 1.1, 8.1 |
| S1-02 | `AureliusPress::Fragment::NotePolicy` + policy spec | 2 | None | 1.2, 8.1 |
| S1-03 | `AureliusPress::Community::LikePolicy` + policy spec | 1 | None | 1.3, 8.1 |
| S1-04 | `AureliusPress::Community::GroupPolicy` + policy spec | 1 | None | 1.4, 8.1 |
| S1-05 | `AureliusPress::Community::GroupMembershipPolicy` + policy spec | 1 | S1-04 | 1.5, 8.1 |
| S1-06 | `AureliusPress::Catalogue::AuthorPolicy` + policy spec | 1 | None | 1.6, 8.1 |
| S1-07 | `AureliusPress::Catalogue::SourcePolicy` + policy spec | 1 | None | 1.7, 8.1 |
| S1-08 | `AureliusPress::Catalogue::QuotePolicy` + policy spec | 1 | None | 1.8, 8.1 |
| S1-09 | `AureliusPress::Document::ContentBlockPolicy` + policy spec | 1 | None | 1.9, 8.1 |

**P0 Total: 11 pts**

### P1 — Should Ship (high value, no blockers)

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S1-10 | Implement `LikesController#update` action | 1 | S1-03 (LikePolicy) | 5.1 |
| S1-11 | Verify Turbo Stream responses for like/unlike across all likeable types | 1 | S1-10 | 5.2 |
| S1-12 | Like count display on public document/block views | 1 | S1-11 | 5.3 |

**P1 Total: 3 pts**

### P2 — Stretch (cut if P0/P1 runs long)

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S1-13 | `AureliusPress::Taxonomy::TagPolicy` + policy spec | 1 | None | 1.10, 8.1 |
| S1-14 | `AureliusPress::Taxonomy::CategoryPolicy` + policy spec | 1 | None | 1.11, 8.1 |

**P2 Total: 2 pts**

---

## Planned Capacity: 16 pts | Sprint Load: 16 pts (100% — P2 is the buffer)

---

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Policy scope ambiguity (what can a Group member see?) | Slows S1-04/S1-05 | Review `GroupMembership` model + existing admin policies first; make a decision and document it |
| `LikesController#update` route may have unintended semantics (toggle vs. explicit) | S1-10 breaks existing likes | Read existing `create`/`destroy` actions and the route definition before implementing; write a failing test first |
| Policy specs reveal missing factories | Slows all policy work | Check FactoryBot coverage for Catalogue/Community models before starting; add factories same-day if missing |

---

## Definition of Done

- [ ] Each policy has a corresponding `*_policy_spec.rb` with coverage for all roles (guest, authenticated user, owner, admin)
- [ ] All new specs are green (`bundle exec rspec spec/policies`)
- [ ] `LikesController#update` covered by a feature spec
- [ ] No Rubocop offences introduced (`bundle exec rubocop --format progress`)
- [ ] Brakeman clean (`bundle exec brakeman -q`)
- [ ] PR opened against `master` with description referencing sprint items

---

## Key Dates

| Date | Event |
|------|-------|
| 2026-04-27 (Mon) | Sprint start — begin P0 policy work |
| 2026-04-30 (Thu) | Mid-sprint check-in — P0 should be ~75% done |
| 2026-05-06 (Wed) | Code freeze for P0/P1 |
| 2026-05-07 (Thu) | PR review + polish |
| 2026-05-08 (Fri) | Sprint end / demo / retro |

---

## Sprint 2 Preview (what this unlocks)

With policies in place, Sprint 2 can immediately begin:
- Public Comments controllers + views (backlog 2.1–2.5)
- Public Notes controllers + views (backlog 2.6–2.9)
- JournalEntry controller + views (backlog 3.1–3.3)
- Group Memberships UI (backlog 4.1–4.3)
