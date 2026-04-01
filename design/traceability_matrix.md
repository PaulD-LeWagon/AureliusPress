# AureliusPress: Feature Traceability Matrix

This document maps the project's functional requirements to their current implementation and verification status as of Sprint 3.

## 1. Core Platform (Stabilized)

| Feature | Completion | Verification |
| :--- | :---: | :--- |
| **Rails 8 Engine Architecture** | 100% | RSpec Suite (Suite-wide) |
| **Multi-layered Namespacing** | 100% | `AureliusPress::*` namespace audit |
| **Database Schema (PostgreSQL)** | 100% | Active Record Model Specs |
| **Authentication (Devise)** | 100% | Requests & Feature Specs |
| **Authorization (Pundit)** | 100% | RBAC verified in Document CRUD |

## 2. Document Management (Active)

| Feature | Status | Details |
| :--- | :---: | :--- |
| **Atomic Blog Posts (ABP)** | [x] | Full CRUD + Rich Text verification |
| **Standard Blog Posts** | [x] | Full CRUD + Category integration |
| **Static Pages** | [x] | Full CRUD with slug-based routing |
| **Content Blocks (Nested)** | [x] | Trix, Image, Gallery, Video blocks verified |
| **Bulk Operations** | [ ] | **PENDING**: Scenarios are skipped in specs |

## 3. Taxonomy System (Refactored)

| Feature | Status | Details |
| :--- | :---: | :--- |
| **Multi-Category Engine** | [x] | `has_many :through` model refactor verified |
| **SearchSelect UI Component** | [x] | Debounced Stimulus search for Tags/Categories |
| **Taxonomy API (v1)** | [x] | CRUD & Search endpoints verified (100% Green) |
| **On-the-fly Tag Creation** | [x] | Integration via SearchSelect verified |

## 4. Community & Engagement (Stabilized)

| Feature | Status | Details |
| :--- | :---: | :--- |
| **Social Reactions (Emojis)** | [x] | Emoji picker + toggle logic verified |
| **GlobalID Mapping** | [x] | Polymorphic engagement system (Likes/Reactions) |
| **Comment Moderation** | [x] | Admin administrative interface verified |
| **Notes / Fragments** | [x] | Secondary content management verified |

## 5. UI/UX & Aesthetics (Final Polish)

| Feature | Status | Details |
| :--- | :---: | :--- |
| **Auto-Slugify** | [x] | Fixed: Now supports `input` events for paste/auto-fill |
| **PicoCSS (Aesthetics)** | [/] | **UNDER REVIEW**: Checking for visual regressions |
| **Hotwire/Turbo Core** | [x] | Form submissions & deletes verified |

## 6. Backlog & Unimplemented

- [ ] **Structured Logging**: Design mandate for observability.
- [ ] **Bulk Deletion/Update**: Admin UX for bulk actions.
- [ ] **Extended Devise Routing**: Remaining 4 routing specs for edge cases.
- [ ] **Comprehensive JS Testing**: Expanding Vitest to legacy controllers.

---
**Definition of Done (DoD)**: 100% Green RSpec + 100% Green Vitest + Manual Aesthetic Verification.
