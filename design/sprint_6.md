# Sprint 6 Plan — AureliusPress

**Dates:** TBD  
**Team:** 1 engineer (solo)  
**Sprint Goal:** Close all remaining test coverage gaps, add routing specs for Phase 4 routes, ship the deferred API v1 expansion, and extend admin pagination beyond the users index — leaving the project at full test coverage and production-ready.

---

## Capacity

| Person | Available Days | Est. Points | Notes |
|--------|---------------|-------------|-------|
| Paul | 8 of 10 | 16 pts | 80% capacity; 2-pt buffer for interrupts |
| **Total** | **8** | **16 pts** | 1 pt ≈ ~half day |

> **Buffer rule:** Plan to 16 pts. P2 items are the first cut if blocked.

---

## Sprint Backlog

### P0 — Remaining Test Coverage (Phase 8)

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S6-01 | Feature specs: public comment create/destroy on blog post | 2 | None | 8.2 |
| S6-02 | Feature specs: public note create/destroy on blog post | 2 | None | 8.3 |
| S6-03 | Routing specs: group_memberships + journal_entries routes | 1 | None | 8.8 |
| S6-04 | Feature spec: admin settings index + edit/update | 1 | None | 8.10 |

**P0 Total: 6 pts**

### P1 — API v1 Expansion (S5-11 carry-over)

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S6-05 | `Api::V1::Catalogue::QuotesController#index` — paginated JSON | 2 | None | — |
| S6-06 | `Api::V1::Taxonomy::TagsController#index` — tag search (`?q=`) | 1 | None | — |
| S6-07 | Request specs for both API endpoints | 1 | S6-05/06 | — |

**P1 Total: 4 pts**

### P1 — Admin Pagination (Phase 9 remainder)

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S6-08 | Extend pagy to remaining admin index actions (groups, settings, blog posts, quotes) | 2 | None | 9.1 |

**P1 Total: 2 pts (running P1: 6 pts)**

### P2 — Stretch

| # | Item | Pts | Dependencies | Backlog Ref |
|---|---|---|---|---|
| S6-09 | Fix duplicate DOM ID bug (`_engagement_bar` vs `_comments_and_notes`) | 2 | None | — |
| S6-10 | Update `8.1` backlog entry to reflect existing policy specs | 0 | None | 8.1 |

**P2 Total: 2 pts**

---

## Planned Capacity: 16 pts | Sprint Load: 12 pts P0+P1 + 2 pts buffer + 2 pts P2

---

## Out of Scope

| Item | Reason | Backlog Ref |
|------|--------|-------------|
| Tyrian Purple mockup removal (route, controller, view, spec, design docs) | Low-priority cleanup; spec currently failing but not a Sprint 6 goal — deferred to a later sprint | Backlog 10.1 |

---

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Public comment/note feature specs require JS + real Turbo Stream setup | S6-01/02 grow beyond estimate | Use `:js` tag, follow existing crud_management pattern; cap to blog post only if needed |
| API v1 quotes endpoint — `pagy` v43 API for JSON responses different from HTML | S6-05 blocked | Read the gem source before implementing; stop and propose if API is unclear |
| `tyrian_purple_mockup_spec` will remain failing for the duration of this sprint | 1 known failing spec in suite | Accepted — deferred to backlog 10.1; exclude from sprint DoD |

---

## Definition of Done

- [ ] Feature spec: public comment create/destroy green
- [ ] Feature spec: public note create/destroy green
- [ ] Routing specs for group_memberships + journal_entries green
- [ ] Admin settings feature spec green
- [ ] API v1 quotes endpoint returns paginated JSON
- [ ] API v1 tags search endpoint returns filtered JSON
- [ ] API request specs green
- [ ] Pagy extended to at least 3 more admin index actions
- [ ] All specs green (`bundle exec rspec`) — `tyrian_purple_mockup_spec` exempted (known deferred, backlog 10.1)
- [ ] No RuboCop offences
- [ ] PR opened against `master`

---

## Key Dates

| Date | Event |
|------|-------|
| Sprint start | S6-01/02 (comment/note feature specs) + S6-03 (routing specs) in parallel |
| Mid-sprint | Test gaps closed; begin API + pagination |
| Code freeze | All P0 + P1 done |
| Sprint end | PR review + ship |
