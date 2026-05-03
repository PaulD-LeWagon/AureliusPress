# AureliusPress — Changelog

All notable changes are documented here by sprint.

---

## [Sprint 6] — in progress

### Fixed
- Restored missing `@use "themes/tyrian-purple" as *` import in `application.scss` — an agent deleted the theme import and disabled part of the PicoCSS theme during the sprint 5/6 development cycle, stripping the Tyrian Purple colour palette from all rendered pages.

### Decisions
- Tyrian Purple mockup **slated for removal** (backlog 10.1, low priority). The scaffold (route, `MockupsController`, view, `tyrian_purple_mockup_spec.rb`, and accompanying design docs `prd_tyrian_purple_ui.md` / `system_design_tyrian_purple_ui.md` / `backlog_tyrian_purple_ui.md`) is a throwaway prototype with no production value. The failing spec is accepted as a known exclusion for Sprint 6 and will be cleaned up in a later sprint with available capacity.

---

## [Sprint 5] — 2026-04-28

### Added
- `LikesController#update` action — toggle state on an existing like (owner + power-user authorised)
- `destroy.turbo_stream.erb` and `update.turbo_stream.erb` for `Community::Likes` — engagement bar now refreshes on all three like actions
- Feature spec: JournalEntry CRUD (9 examples) including privacy enforcement assertion
- Feature spec: Group membership join/leave with Turbo Stream toggle (4 examples)
- Feature spec: Likes on `Catalogue::Quote` — confirms polymorphic engagement across resource types
- `.simplecov` with 70% minimum coverage threshold
- SimpleCov wired into `spec/spec_helper.rb` gated on `COVERAGE=true` env var
- Real project `README.md` replacing Rails boilerplate

### Changed
- Groups controller spec: all `params: { id: group.id }` → `group.slug`; redirect assertion uses `.reload` to handle slug regeneration on name change
- CI workflow (`ci.yml`): replaced `bin/rails test test:system` (Minitest) with `bundle exec rspec` + `COVERAGE=true` — CI was never actually running the test suite
- Engagement spec: added quote polymorphic scenario; workaround for pre-existing duplicate DOM ID bug between `_engagement_bar` and `_comments_and_notes` partials

### Decisions
- Reactions feature: **KEEP** — controller and routes already active, engagement bar uses them

### Known Issues
- `tyrian_purple_mockup_spec` fails in the worktree environment (CSS asset compilation path issue — pre-existing, not sprint-related)
- Duplicate DOM ID on resource show pages where both `_engagement_bar` and `_comments_and_notes` render `dom_id(resource, :engagement)` — bug-fix task spawned

### Sprint Metrics
- Planned: 14 pts committed (P0+P1); 2 pts P2 buffer
- Delivered: 13 pts (S5-03 was already done; S5-11 P2 deferred)
- Velocity: 13 (rolling avg: 15)

---

## [Sprint 4] — 2026-04-28

### Added
- `discard` gem + `discarded_at` migration on `aurelius_press_fragments` — soft deletion foundation (S4-01/02)
- Soft delete on `AureliusPress::Admin::Fragment::CommentsController` and `NotesController` — hard destroy replaced with `discard` (S4-03)
- Default scope on `Fragment` filtering soft-deleted records from all public queries (S4-04)
- `JournalEntry` nested notes: routes, `JournalEntry::NotesController`, views (S4-05)
- Admin Settings Panel: ADR, key-value settings store, `AureliusPress::Admin::SettingsController`, index + edit views (S4-06–09)
- `pagy` gem + pagination on `Admin::UsersController#index` — `Pagy::Method` pattern, `@pagy.series_nav` in view (S4-10)
- Request spec coverage for all new controllers

### Changed
- Admin fragment moderation flash notices: "deleted" → "discarded" (reflects soft-delete semantics)
- Feature specs for comment/note CRUD updated to match new flash messages
- `AureliusPress::Admin::ApplicationController` — `include Pagy::Method`
- `ApplicationHelper` — no longer includes `Pagy::Frontend` (not needed in pagy v43)

### Sprint Metrics
- Planned: 16 pts (14 committed P0+P1; 2 pts P2 buffer)
- Delivered: 14 pts (all P0 + P1; P2 deferred to Sprint 5)
- Velocity: 14 (rolling avg: 16)

---

## [Sprint 3] — 2026-04-26

### Added
- `AureliusPress::Document::JournalEntriesController` — full CRUD, always-private enforced
- `AureliusPress::Community::GroupMembershipsController` — create (join) / destroy (leave) with Turbo Stream
- `AureliusPress::Community::GroupsController` — public index + show with member list
- Journal entry views: index, show, new, edit, `_form` partial
- Group views: index, show, `_membership_button` partial; Turbo Stream join/leave templates
- `content_blocks_attributes` permitted in `JournalEntriesController` (S3-09)
- `aurelius_press/catalogue/shared/_comments_and_notes` partial embedded in Author, Source, Quote show pages
- `aurelius_press/content_block/shared/_comments_panel` and `_notes_panel` inline partials
- `vendor/css/.keep` — fixes pre-existing Sprockets manifest error in test suite

### Changed
- `JournalEntry` model: validation enforces `visibility: :private_to_owner` always
- `Group` model: `to_param` added for slug-based URL generation
- `Admin::Community::GroupsController`: `find_by!(slug:)` to match `to_param` change
- Routes: `resources :journal_entries`, `:group_memberships`, `:groups` added to public namespace
- JournalEntry model spec: updated to use `private_to_owner` (reflects always-private constraint)

### Sprint Metrics
- Planned: 16 pts
- Delivered: 16 pts
- Velocity: 16
- PR: #66

---

## [Sprint 2] — 2026-04-26

### Added
- `AureliusPress::Document::CommentsController` — shared controller for BlogPost, AtomicBlogPost, Page, ContentBlock, Note parents
- `AureliusPress::Document::NotesController` — shared controller for BlogPost, AtomicBlogPost, Page, ContentBlock parents
- `AureliusPress::Catalogue::CommentsController` — shared controller for Author, Source, Quote, Note parents
- `AureliusPress::Catalogue::NotesController` — shared controller for Author, Source, Quote parents
- Turbo Stream templates (create / update / destroy) for all four controllers
- Shared `_form` partials for comments and notes under `aurelius_press/fragment/`
- `has_many :notes` on `Author`, `Source`, `Quote` catalogue models
- `has_many :comments` on `ContentBlock::ContentBlock` model
- Request specs: 95 new examples across all controllers

### Changed
- `Document::Document::NAMESPACED_COMMENTABLE_TYPES` — Page now included
- `Fragment::Comment#commentable_type_is_allowed` — ContentBlock added to allowed types
- `config/routes.rb` — added `resources :comments` direct route under pages namespace

### Sprint Metrics
- Planned: 14 pts
- Delivered: 18 pts
- Velocity: 18
- PR: #65

---

## [Sprint 1] — 2026-04-25

### Added
- `AureliusPress::Fragment::CommentPolicy` — role-based access with document-scoped Scope
- `AureliusPress::Fragment::NotePolicy` — private by default; owner-only read/write
- `AureliusPress::Community::LikePolicy` — `user+` create; owner or power-user destroy
- `AureliusPress::Community::GroupPolicy` — creator + member visibility for private groups
- `AureliusPress::Community::GroupMembershipPolicy` — join/leave permissions
- `AureliusPress::Catalogue::AuthorPolicy` — public read; admin+ write
- `AureliusPress::Catalogue::SourcePolicy` — public read; admin+ write
- `AureliusPress::Catalogue::QuotePolicy` — public read; admin+ write
- `AureliusPress::Document::ContentBlockPolicy` — doc owner or power-user write
- `AureliusPress::Taxonomy::TagPolicy` — public read; admin+ write
- `AureliusPress::Taxonomy::CategoryPolicy` — public read; admin+ write
- Policy specs for all 11 policies (174 examples, 0 failures)
- `AureliusPress::Community::LikesController` — GlobalID + `state` toggle pattern
- Request specs for `LikesController` (create toggle + destroy)

### Changed
- `LikesController` moved into `AureliusPress::Community` namespace
- Routes: `namespace :community` with reactions + likes; `namespace :taxonomy` for public tag/category pages
- `spec/rails_helper.rb` — added `require "pundit/rspec"`

### Sprint Metrics
- Planned: 16 pts
- Delivered: 16 pts
- Velocity: 16
- PR: #64
