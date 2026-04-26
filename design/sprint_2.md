# Sprint 2 — AureliusPress

**Dates:** 2026-04-26 (single-day accelerated sprint)  
**Team:** 1 engineer (solo)  
**Sprint Goal:** Deliver the full public comments and notes interaction layer for all document types so that authenticated users can engage with content end-to-end.

---

## Capacity

| Person | Available Days | Est. Points | Notes |
|--------|---------------|-------------|-------|
| Paul | 1 | 14 pts planned | Accelerated; stretch carried in |
| **Total** | **1** | **18 pts delivered** | |

---

## Sprint Backlog — Final Status

### P0 — Document Comments

| # | Item | Pts | Status | Notes |
|---|---|---|---|---|
| S2-01 | `AureliusPress::Document::CommentsController` (BlogPost) | 2 | ✅ done | Shared controller; BlogPost parent |
| S2-02 | `AureliusPress::Document::CommentsController` (AtomicBlogPost) | 1 | ✅ done | Same controller; separate route |
| S2-03 | `AureliusPress::Document::CommentsController` (Page) | 1 | ✅ done | Design decision: Pages ARE commentable |
| S2-04 | Turbo Stream templates for Document::CommentsController | 1 | ✅ done | create / update / destroy |
| S2-05 | Shared `_form` partial for comments | 1 | ✅ done | `aurelius_press/fragment/comments/_form` |

**P0 Total: 6 pts**

### P1 — Document Notes

| # | Item | Pts | Status | Notes |
|---|---|---|---|---|
| S2-06 | `AureliusPress::Document::NotesController` (BlogPost) | 2 | ✅ done | Shared controller |
| S2-07 | `AureliusPress::Document::NotesController` (AtomicBlogPost) | 1 | ✅ done | |
| S2-08 | `AureliusPress::Document::NotesController` (Page) | 1 | ✅ done | |
| S2-09 | `AureliusPress::Document::NotesController` (ContentBlock) | 1 | ✅ done | |
| S2-10 | `AureliusPress::Document::CommentsController` (ContentBlock) | 1 | ✅ done | Design decision: ContentBlocks ARE commentable |
| S2-11 | Turbo Stream templates for Document::NotesController | 1 | ✅ done | create / update / destroy |
| S2-12 | Shared `_form` partial for notes | 1 | ✅ done | `aurelius_press/fragment/notes/_form` |

**P1 Total: 8 pts**

### P2 — Catalogue Comments & Notes (stretch)

| # | Item | Pts | Status | Notes |
|---|---|---|---|---|
| S2-13 | `AureliusPress::Catalogue::CommentsController` (Author/Source/Quote) | 1 | ✅ done | Shared controller |
| S2-14 | `AureliusPress::Catalogue::NotesController` (Author/Source/Quote) | 1 | ✅ done | Shared controller; `has_many :notes` added to all 3 models |
| S2-15 | Turbo Stream templates for Catalogue controllers | 1 | ✅ done | Both comment + note controllers |
| S2-16 | Request specs: all new controllers (95 examples) | 1 | ✅ done | 0 failures |

**P2 Total: 4 pts**

---

## Velocity Tracker

| Sprint | Planned | Delivered | Velocity |
|--------|---------|-----------|----------|
| Sprint 1 | 16 | 16 | 16 |
| Sprint 2 | 14 | 18 | 18 |
| **Rolling avg** | | | **17** |

---

## Design Decisions Made This Sprint

| Decision | Context | Outcome |
|---|---|---|
| Pages are commentable | `NAMESPACED_COMMENTABLE_TYPES` excluded Page; specs revealed this when direct comment route was needed | Page added to commentable types; model spec updated |
| ContentBlocks are commentable | No `has_many :comments` existed; `commentable_type_is_allowed` didn't include ContentBlock | Association + allowlist added; ContentBlock comments fully working |

---

## Retrospective

**What went well**
- Single shared controller pattern scaled cleanly to all parent types — one controller per namespace, not one per parent
- Slug-based routing (`find_by!(slug: ...)`) worked consistently across all document and catalogue types
- 18 pts in one session with 0 failures at ship time

**What surprised us**
- Page commentability was a deliberate omission in the original model that needed an explicit design call
- ContentBlock had no `has_many :comments` — the association gap only surfaced when writing specs
- Catalogue models (Author, Source, Quote) were missing `has_many :notes` entirely

**What to improve**
- Define commentable/notable surface area upfront per-sprint to avoid mid-sprint model changes
- ContentBlock route params use integer IDs while all document/catalogue params use slugs — worth documenting as a convention

---

## Definition of Done — Result

- [x] All P0 + P1 + P2 stories shipped
- [x] 95 new request specs, 0 failures (total suite: 269 examples, 0 failures)
- [x] No RuboCop offences
- [x] Brakeman clean
- [x] PR opened against `master`
