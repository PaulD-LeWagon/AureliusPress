# Turbo Audit — AureliusPress

**Date:** 2026-05-09  
**Branch at audit:** Sprint-9  
**Suite at audit:** 1296 examples, 0 failures

> **Purpose:** Catalogue every CRUD endpoint in the application. For each, determine whether it should use Turbo Streams, a Turbo Frame, or remain a full-page redirect. Identify gaps, bugs, and deferrable improvements. Findings feed directly into Sprint 9 and the backlog.

---

## Methodology

For each controller action that mutates state (`create`, `update`, `destroy`), we answer two questions:

1. **What does it do today?**  `turbo_stream` / `redirect_to` / `head :no_content`
2. **What should it do?** Based on the UX context (inline engagement vs. CMS form vs. admin moderation).

**Decision rule:**
- **Inline, page-embedded interactions** (comments, notes, likes, reactions, group join/leave, content block removal) → **Turbo Stream** — the user never leaves the current page.
- **Admin CMS / full-record CRUD** (creating/editing/deleting documents, authors, tags, users) → **full-page redirect** — the user expects to navigate to the result. Turbo Drive handles this as a pushState navigation; no Turbo Stream needed.
- **Engagement bar updates** (likes, reactions inside a `turbo_frame_tag`) → **Turbo Stream replacing the frame** — the frame wraps the bar, so the stream must target the frame's DOM ID to re-render the counts.

---

## Status Legend

| Symbol | Meaning |
|--------|---------|
| ✅ Done | Turbo Stream/Frame in place and correct |
| ✅ Correct | Full-page redirect is intentional and correct for this context |
| ❌ Missing | Should be Turbo Stream; no template exists |
| 🐛 Bug | Code is broken or will silently fail in Rails 7 + Turbo |
| 🔜 Deferrable | Nice-to-have Turbo Stream; functional as redirect today |

---

## Section 1: Inline / Engagement Controllers (Public namespace)

These are the controllers that users interact with inline on page — they must never cause a full-page reload.

| Controller | Action | Current | Target | Status |
|------------|--------|---------|--------|--------|
| `community/likes` | create | `format.turbo_stream` + `format.html` | Turbo Stream replaces `dom_id(likeable, :engagement)` frame | ✅ Done |
| `community/likes` | update | `format.turbo_stream` + `format.html` | same | ✅ Done |
| `community/likes` | destroy | `format.turbo_stream` + `format.html` | same | ✅ Done |
| `community/reactions` | create | `format.turbo_stream` + `format.html` | Turbo Stream replaces `dom_id(reactable, :engagement)` frame | ✅ Done |
| `community/reactions` | destroy | `head :no_content` | Turbo Stream replaces `dom_id(reactable, :engagement)` frame | ❌ Missing |
| `community/group_memberships` | create | `format.turbo_stream` + `format.html` | Turbo Stream replaces membership button | ✅ Done |
| `community/group_memberships` | destroy | `format.turbo_stream` + `format.html` | Turbo Stream replaces membership button | ✅ Done |
| `document/comments` | create | `format.turbo_stream` + `format.html` | Turbo Stream appends to `dom_id(commentable, :comments)` | ✅ Done |
| `document/comments` | update | `format.turbo_stream` + `format.html` | Turbo Stream replaces `dom_id(comment)` | ✅ Done |
| `document/comments` | destroy | `format.turbo_stream` + `format.html` | Turbo Stream removes `dom_id(comment)` | ✅ Done |
| `document/notes` | create | `format.turbo_stream` + `format.html` | Turbo Stream appends to `dom_id(notable, :notes)` | ✅ Done |
| `document/notes` | update | `format.turbo_stream` + `format.html` | Turbo Stream replaces `dom_id(note)` | ✅ Done |
| `document/notes` | destroy | `format.turbo_stream` + `format.html` | Turbo Stream removes `dom_id(note)` | ✅ Done |
| `catalogue/comments` | create | `format.turbo_stream` + `format.html` | Turbo Stream appends to comments list | ✅ Done |
| `catalogue/comments` | update | `format.turbo_stream` + `format.html` | Turbo Stream replaces comment | ✅ Done |
| `catalogue/comments` | destroy | `format.turbo_stream` + `format.html` | Turbo Stream removes comment | ✅ Done |
| `catalogue/notes` | create | `format.turbo_stream` + `format.html` | Turbo Stream appends to notes list | ✅ Done |
| `catalogue/notes` | update | `format.turbo_stream` + `format.html` | Turbo Stream replaces note | ✅ Done |
| `catalogue/notes` | destroy | `format.turbo_stream` + `format.html` | Turbo Stream removes note | ✅ Done |
| `content_blocks` | destroy | **NO CONTROLLER** | Turbo Stream removes `dom_id(content_block)` wrapper | ❌ Missing |

**Gap summary — Section 1:**

### GAP-1 · `community/reactions#destroy` — returns `head :no_content`

The engagement bar is wrapped in `<%= turbo_frame_tag dom_id(interactable, :engagement) %>`. The `likes` controller correctly responds with a Turbo Stream that replaces this frame. `reactions#create` also correctly does so. However `reactions#destroy` returns `head :no_content`, leaving the frame stale after a direct DELETE. In the primary UI the reaction toggle is handled via `create` (clicking same emoji sets it to `:no_reaction`), so `destroy` is not currently reachable from the engagement bar. But the route exists and the behaviour is inconsistent with the rest of the engagement stack.

**Fix:** Add `app/views/aurelius_press/community/reactions/destroy.turbo_stream.erb` that replaces the engagement frame (mirrors `likes/destroy.turbo_stream.erb`). Update `ReactionsController#destroy` to `respond_to { |f| f.turbo_stream; f.html { redirect_back ... } }`.

**Effort:** 0.5 pts — small enough to bundle into Sprint 9 as part of a cleanup story.

---

### GAP-2 · `content_blocks#destroy` — no controller exists

Routes for `DELETE /[admin/]document/blog-posts/:id/cb/:cb_id` and `DELETE /[admin/]document/pages/:id/cb/:cb_id` exist in `config/routes.rb` but there is no `ContentBlocksController` in either the admin or public namespace. The current workaround (Sprint 8 S8-02) bypasses this entirely, using `execute_script` in feature specs to simulate Stimulus `_destroy` via the parent document form.

**Fix:** The primary S9-01 and S9-02 stories. Create both namespace controllers with `destroy` + Turbo Stream templates; update the Remove button in the view.

**Effort:** 6 pts (S9-01 + S9-02 as currently planned).

---

## Section 2: Public Document CRUD (Owner-facing)

Document `create`/`update` involve rich text, file uploads, and nested ContentBlock forms — full-page navigation after save is correct UX. Document `destroy` navigates to the list index, which is also correct.

| Controller | Action | Current | Target | Status |
|------------|--------|---------|--------|--------|
| `document/blog_posts` | create | `redirect_to show` | Full-page redirect | ✅ Correct |
| `document/blog_posts` | update | `redirect_to show` | Full-page redirect | ✅ Correct |
| `document/blog_posts` | destroy | `redirect_to index` | Full-page redirect | ✅ Correct |
| `document/pages` | create | `redirect_to show` | Full-page redirect | ✅ Correct |
| `document/pages` | update | `redirect_to show` | Full-page redirect | ✅ Correct |
| `document/pages` | destroy | `redirect_to index` | Full-page redirect | ✅ Correct |
| `document/journal_entries` | create | `redirect_to show` | Full-page redirect | ✅ Correct |
| `document/journal_entries` | update | `redirect_to show` | Full-page redirect | ✅ Correct |
| `document/journal_entries` | destroy | `redirect_to index` | Full-page redirect | ✅ Correct |
| `document/atomic_blog_posts` | create | `redirect_to show` | Full-page redirect | ✅ Correct |
| `document/atomic_blog_posts` | update | `redirect_to show` | Full-page redirect | ✅ Correct |
| `document/atomic_blog_posts` | destroy | `redirect_to index` | Full-page redirect | ✅ Correct |

No gaps in this section.

---

## Section 3: Admin CMS Namespace

Admin CRUD is a form-based CMS. The user submits a full record form and expects to land on the result or back on the list. Full-page Turbo Drive navigation is correct. Turbo Streams are not needed here.

| Controller | Actions | Current | Target | Status |
|------------|---------|---------|--------|--------|
| `admin/document/blog_posts` | create/update/destroy | `redirect_to` | Full-page redirect | ✅ Correct |
| `admin/document/pages` | create/update/destroy | `redirect_to` | Full-page redirect | ✅ Correct |
| `admin/document/atomic_blog_posts` | create/update/destroy | `redirect_to` | Full-page redirect | ✅ Correct |
| `admin/catalogue/authors` | create/update/destroy | `redirect_to` | Full-page redirect | ✅ Correct |
| `admin/catalogue/quotes` | create/update/destroy | `redirect_to` | Full-page redirect | ✅ Correct |
| `admin/catalogue/sources` | create/update/destroy | `redirect_to` | Full-page redirect | ✅ Correct |
| `admin/taxonomy/categories` | create/update/destroy | `redirect_to` | Full-page redirect | ✅ Correct |
| `admin/taxonomy/tags` | create/update/destroy | `redirect_to` | Full-page redirect | ✅ Correct |
| `admin/users` | create/update/destroy | `redirect_to` | Full-page redirect | ✅ Correct |
| `admin/community/groups` | create/update/destroy | `redirect_to` | Full-page redirect | ✅ Correct |
| `admin/community/reactions` | create/update/destroy | `redirect_to` | Full-page redirect | ✅ Correct |
| `admin/community/likes` | create/update/destroy | `redirect_to` | Full-page redirect | ✅ Correct (but see BUG-1) |
| `admin/fragment/comments` | destroy (discard) | `redirect_to` | Full-page redirect | ✅ Correct (see DEFER-1) |
| `admin/fragment/notes` | destroy (discard) | `redirect_to` | Full-page redirect | ✅ Correct (see DEFER-1) |
| `admin/settings` | update | `redirect_to` | Full-page redirect | ✅ Correct |

---

### BUG-1 · `admin/community/likes/index.html.erb` — legacy Rails UJS delete syntax

```erb
# app/views/aurelius_press/admin/community/likes/index.html.erb:21
<%= link_to 'Destroy', ..., method: :delete, data: { confirm: 'Are you sure?' } %>
```

`method: :delete` is the Rails 5/6 `rails-ujs` pattern. AureliusPress uses Rails 7 with Turbo; `rails-ujs` is not included in the importmap. This link will fire as a plain GET request (no JS intercept), which will not match the DELETE route — it will either 404 or hit the wrong action.

**Every other delete link in the app correctly uses:**
```erb
data: { turbo_method: :delete, turbo_confirm: "Are you sure?" }
```

**Fix:** One-line change in `admin/community/likes/index.html.erb:21`. Effort: trivial (< 0.5 pts) — bundle into the Sprint 9 cleanup story.

---

## Section 4: Deferrable Improvements

These are not bugs, but Turbo Stream adoption would improve UX. Not blocking; plan into a future sprint when UI polish is prioritised.

| ID | Scope | Current | Improvement | Effort |
|----|-------|---------|-------------|--------|
| DEFER-1 | `admin/fragment/comments#destroy`, `admin/fragment/notes#destroy` | `redirect_to admin index` after soft-delete | Turbo Stream removing the row from the admin table in place | ~2 pts |
| DEFER-2 | All admin index delete actions (authors, sources, quotes, tags, categories, users) | Full-page redirect to index after destroy | Turbo Stream removing the specific `<tr>` row, keeping scroll position | ~5 pts (many controllers, DOM ID wiring needed on each row) |
| DEFER-3 | Public document `destroy` (blog posts, pages, journal entries) | Full-page redirect to index | Turbo Stream removing the card/row from the index list | ~3 pts |

---

## Consolidated Gap / Action Table

| ID | Severity | Controller | Action | Fix Required | Sprint |
|----|----------|------------|--------|--------------|--------|
| GAP-2 | 🔴 Critical | `content_blocks` (admin + public) | destroy | Create controller + Turbo Stream template | **S9-01** |
| GAP-2b | 🔴 Critical | `_content_block_fields.html.erb` | Remove button | Turbo delete link for persisted blocks; update 4 feature specs | **S9-02** |
| BUG-1 | 🟠 Bug | `admin/community/likes` | index view | Fix legacy `method: :delete` → `turbo_method: :delete` | **S9-03** |
| GAP-1 | 🟡 Minor | `community/reactions` | destroy | Add `destroy.turbo_stream.erb`; update controller to `respond_to` | **S9-03** |
| DEFER-1 | 🟢 Nice | `admin/fragment/comments`, `admin/fragment/notes` | destroy | Turbo Stream row removal from admin index | S10+ |
| DEFER-2 | 🟢 Nice | All admin index delete links | destroy | Turbo Stream `<tr>` removal on admin index tables | S10+ |
| DEFER-3 | 🟢 Nice | Public document destroy actions | destroy | Turbo Stream card removal on public index lists | S10+ |

---

## Turbo Frame Inventory

Only one `turbo_frame_tag` is used in the application — the engagement bar:

```erb
# app/views/aurelius_press/community/shared/_engagement_bar.html.erb
<%= turbo_frame_tag dom_id(interactable, :engagement) do %>
```

Every Like and Reaction mutation correctly targets this frame ID via `turbo_stream.replace`. Group membership mutations target the membership button partial using `dom_id(@group, :membership_button)`. Both patterns are correct and consistent.

No `turbo_frame_tag` wrappers exist in admin views — this is correct; admin CMS does not use lazy-loading frames.

---

## Summary

| Category | Count |
|----------|-------|
| ✅ Done — Turbo Stream in place | 18 actions |
| ✅ Correct — Full-page redirect intentional | 27 actions |
| ❌ Missing — must add Turbo Stream | 2 gaps (content_blocks + reactions destroy) |
| 🐛 Bug — broken in Rails 7 | 1 (admin likes legacy UJS) |
| 🔜 Deferrable — functional but improvable | 3 groups |

**Conclusion:** The application's Turbo architecture is largely sound. The engagement stack (likes, reactions, group memberships, comments, notes) is fully Turbo-Streamed. The admin CMS correctly uses full-page redirects. There are two missing Turbo Stream endpoints (ContentBlock destroy × 2 namespaces, and Reactions destroy), one broken delete link, and a class of deferrable admin UX improvements. Sprint 9 addresses the critical and bug items; the deferrable items are logged in the backlog for a future polish sprint.
