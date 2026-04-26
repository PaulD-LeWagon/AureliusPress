# AureliusPress — Implementation Backlog

> Generated: 2026-04-24 | Last updated: 2026-04-26  
> Estimated overall completion: ~80–85% (Phases 1–4 complete)

Items are ordered by dependency — foundational work first, user-facing features after, polish last.

---

## Phase 1 — Authorization Foundation (Pundit Policies)

Must come first: controllers downstream depend on policies being in place.

| # | Item | Priority | Notes |
|---|---|---|---|
| 1.1 | `AureliusPress::Fragment::CommentPolicy` | Critical | Covers public & admin comment access |
| 1.2 | `AureliusPress::Fragment::NotePolicy` | Critical | Covers public & admin note access |
| 1.3 | `AureliusPress::Community::LikePolicy` | Critical | Scope create/destroy to authenticated users |
| 1.4 | `AureliusPress::Community::GroupPolicy` | High | Group visibility + membership rules |
| 1.5 | `AureliusPress::Community::GroupMembershipPolicy` | High | Join/leave permissions |
| 1.6 | `AureliusPress::Catalogue::AuthorPolicy` | High | Public read; admin write |
| 1.7 | `AureliusPress::Catalogue::SourcePolicy` | High | Public read; admin write |
| 1.8 | `AureliusPress::Catalogue::QuotePolicy` | High | Public read; admin write |
| 1.9 | `AureliusPress::Document::ContentBlockPolicy` | High | Owner/group write; public read |
| 1.10 | `AureliusPress::Taxonomy::TagPolicy` | Medium | Admin CRUD; public read |
| 1.11 | `AureliusPress::Taxonomy::CategoryPolicy` | Medium | Admin CRUD; public read |

---

## Phase 2 — Public Comments & Notes (Controllers + Views)

Depends on Phase 1 policies. Implement public-facing interaction layer.

### 2a — Document Comments (nested under each document type)

| # | Item | Priority | Notes |
|---|---|---|---|
| 2.1 | `AureliusPress::Document::AtomicBlogPosts::CommentsController` | High | `index`, `create`, `destroy` |
| 2.2 | `AureliusPress::Document::BlogPosts::CommentsController` | High | `index`, `create`, `destroy` |
| 2.3 | `AureliusPress::Document::Pages::CommentsController` | High | `index`, `create`, `destroy` |
| 2.4 | Views: comment form partial + comment list partial (shared) | High | Reuse across document types |
| 2.5 | Turbo Stream responses for comment create/destroy | High | Inline update without full page reload |

### 2b — Document Notes (nested under each document type)

| # | Item | Priority | Notes |
|---|---|---|---|
| 2.6 | `AureliusPress::Document::AtomicBlogPosts::NotesController` | High | `index`, `create`, `destroy` |
| 2.7 | `AureliusPress::Document::BlogPosts::NotesController` | High | `index`, `create`, `destroy` |
| 2.8 | `AureliusPress::Document::Pages::NotesController` | High | `index`, `create`, `destroy` |
| 2.9 | Views: note form partial + note list partial (shared) | High | Reuse across document types |

### 2c — Content Block Comments & Notes

| # | Item | Priority | Notes |
|---|---|---|---|
| 2.10 | `AureliusPress::Document::BlogPosts::ContentBlocks::CommentsController` | Medium | Inline block-level comments |
| 2.11 | `AureliusPress::Document::BlogPosts::ContentBlocks::NotesController` | Medium | Inline block-level notes |
| 2.12 | Views: inline comment/note partials for content blocks | Medium | |

### 2d — Catalogue Comments & Notes

| # | Item | Priority | Notes |
|---|---|---|---|
| 2.13 | `AureliusPress::Catalogue::Authors::CommentsController` | Medium | |
| 2.14 | `AureliusPress::Catalogue::Sources::CommentsController` | Medium | |
| 2.15 | `AureliusPress::Catalogue::Quotes::CommentsController` | Medium | |
| 2.16 | `AureliusPress::Catalogue::Authors::NotesController` | Medium | |
| 2.17 | `AureliusPress::Catalogue::Sources::NotesController` | Medium | |
| 2.18 | `AureliusPress::Catalogue::Quotes::NotesController` | Medium | |
| 2.19 | Views for catalogue comments/notes | Medium | |

---

## Phase 3 — JournalEntry Document Type ✅ DONE

**Completed:** 2026-04-26 (Sprint 3)

| # | Item | Priority | Status | Notes |
|---|---|---|---|---|
| 3.1 | `AureliusPress::Document::JournalEntriesController` | High | ✅ done | Full CRUD (private by default) |
| 3.2 | Views: index, show, new, edit, _form partial | High | ✅ done | |
| 3.3 | `JournalEntry`-specific validations & business rules | High | ✅ done | validation + controller enforce private_to_owner |
| 3.4 | Nested content blocks for JournalEntry (if applicable) | Medium | ✅ done | content_blocks_attributes permitted |
| 3.5 | Nested comments/notes for JournalEntry | Medium | todo | Sprint 4 |

---

## Phase 4 — Group Memberships UI ✅ DONE

**Completed:** 2026-04-26 (Sprint 3)

| # | Item | Priority | Status | Notes |
|---|---|---|---|---|
| 4.1 | Uncomment `resources :group_memberships` in routes.rb | High | ✅ done | Added to public community namespace |
| 4.2 | `AureliusPress::Community::GroupMembershipsController` | High | ✅ done | create/destroy (join/leave) |
| 4.3 | Views: group membership UI (join/leave buttons) | High | ✅ done | Turbo Stream toggle + _membership_button partial |
| 4.4 | Group show page: list members | Medium | ✅ done | |
| 4.5 | Group index page: discoverable groups | Medium | ✅ done | public_group scoped |

---

## Phase 5 — Likes System Completion

| # | Item | Priority | Notes |
|---|---|---|---|
| 5.1 | Implement `LikesController#update` | High | Route exists but action is missing |
| 5.2 | Verify Turbo Stream responses for like/unlike on all likeable types | High | Documents, content blocks, fragments |
| 5.3 | Like count display on public views | Medium | |

---

## Phase 6 — Admin Settings Panel

Currently fully commented out (`resources :settings` in routes).

| # | Item | Priority | Notes |
|---|---|---|---|
| 6.1 | Define settings scope: what is configurable? | High | Decide before implementing |
| 6.2 | `AureliusPress::Admin::SettingsController` | Medium | |
| 6.3 | Settings model / store (e.g. `RailsSettings` gem or custom) | Medium | |
| 6.4 | Admin settings views | Medium | |

---

## Phase 7 — Soft Deletion

Noted as a `@todo` in the admin Comments and Notes controllers.

| # | Item | Priority | Notes |
|---|---|---|---|
| 7.1 | Add `discarded_at` / `deleted_at` to `fragments` table | Medium | Migration required |
| 7.2 | Integrate `discard` gem (or equivalent) on `Fragment` | Medium | |
| 7.3 | Update admin moderation controllers to use soft delete | Medium | |
| 7.4 | Filter soft-deleted fragments from public queries | Medium | |

---

## Phase 8 — Test Coverage Gaps

Fill gaps in parallel with feature work above (each phase should ship with tests).

| # | Item | Priority | Notes |
|---|---|---|---|
| 8.1 | Policy specs for all new Pundit policies (Phase 1) | Critical | Write alongside policies |
| 8.2 | Feature specs: public comment create/destroy (Phase 2) | High | |
| 8.3 | Feature specs: public note create/destroy (Phase 2) | High | |
| 8.4 | Feature specs: JournalEntry CRUD (Phase 3) | High | |
| 8.5 | Feature specs: group membership join/leave (Phase 4) | High | |
| 8.6 | Feature specs: public catalogue items (authors/sources/quotes) | Medium | Read-only but currently untested |
| 8.7 | Controller specs: all new controllers from Phases 2–5 | Medium | |
| 8.8 | Routing specs: newly uncommented routes (Phase 4) | Medium | |
| 8.9 | Feature specs: likes on all resource types | Medium | |
| 8.10 | Feature specs: admin settings (Phase 6) | Low | |

---

## Phase 9 — Polish & Non-Functional

| # | Item | Priority | Notes |
|---|---|---|---|
| 9.1 | Pagination on admin index actions (noted in controller `@todo`) | Medium | |
| 9.2 | `JournalEntry` privacy enforcement (always private) | Medium | ✅ done | Sprint 3 |
| 9.3 | `README.md` — replace boilerplate with real project docs | Low | |
| 9.4 | Reactions feature decision | Low | Routes commented out; decide keep/remove |
| 9.5 | SimpleCov coverage target enforcement in CI | Low | |

---

## Summary

| Phase | Focus | Items | Est. Effort |
|---|---|---|---|
| 1 | Pundit Policies | 11 | ~2 days |
| 2 | Public Comments & Notes | 19 | ~4–5 days |
| 3 | JournalEntry | 5 | ~2 days |
| 4 | Group Memberships UI | 5 | ~1.5 days |
| 5 | Likes Completion | 3 | ~0.5 days |
| 6 | Admin Settings | 4 | ~2 days |
| 7 | Soft Deletion | 4 | ~1 day |
| 8 | Test Coverage | 10 | ~3 days |
| 9 | Polish | 5 | ~1 day |
| **Total** | | **66** | **~17–18 days** |
