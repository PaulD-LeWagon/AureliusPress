# AureliusPress — Changelog

All notable changes are documented here by sprint.

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
