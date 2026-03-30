# Product Requirement Document (PRD): Taxonomy UX & Catalogue API

## 1. Executive Summary
AureliusPress requires a modernized interface for managing Tags and Categories (Taxonomy) across all document and catalogue types. The current static select/input mechanism is inefficient for high-volume content. This project will introduce a high-performance Hotwire-powered search-select component and a tiered API layer to support internal search needs and a public-facing data interface for the stoic catalogue.

## 2. Functional Requirements
### 2.1 Taxonomy UX (Tags & Categories)
- **Search-as-you-type**: Users can type in a text input to find existing tags or categories.
- **AJAX Population**: The form should asynchronously fetch likely matches from the backend.
- **On-the-fly Creation**: If a desired tag/category does not exist, hitting 'Enter' or clicking 'Add' will create it in the database and automatically select it for the current object.
- **Multi-Selection**: Support for multiple tags/categories where applicable.

### 2.2 API Layer
- **Internal Search API**: Endpoints optimized for Stimulus-driven taxonomy lookups.
- **Public Catalogue API**: Secure, read-only JSON interface for `Authors`, `Sources`, and `Quotes`.
- **Versioning**: Initial release as V1 to support future evolution.

### 2.3 Catalogue TDD Audit
- **Full Coverage**: All models in the Catalogue module (`Author`, `Quote`, `Source`, `Authorship`, `AffiliateLink`) must have 100% test coverage for scopes, instance methods, and delegations.

## 3. Technical Constraints & Environment
- **Framework**: Ruby on Rails 7.x, Hotwire (Turbo & Stimulus).
- **Persistence**: PostgreSQL.
- **Governance**: Strict TDD/Agile pipeline. No implementation without a failing test.
- **Hardware**: HP 640 G11 (Intel Ultra 5, 30GB RAM).

## 4. User Flow
### 4.1 Admin Tagging
1. Admin opens a Blog Post for editing.
2. Admin clicks into the "Tags" search input.
3. Admin types "Stoi".
4. A dropdown appears with "Stoicism" and "Stoic Ethics".
5. Admin clicks "Stoicism"; it is added to the post.
6. Admin types "NewConcept". No results found.
7. Admin hits 'Enter'. "NewConcept" is created in the database and added to the post.

### 4.2 Public Quote Fetching
1. External application requests `GET /api/v1/catalogue/quotes`.
2. System returns a paginated JSON response of quotes with their associated authors and sources.

## 5. Non-Functional Requirements
- **Performance**: Search results must return in < 150ms.
- **Reliability**: 100% test pass rate for all new and touched code.
- **Security**: Public API must be read-only. Internal APIs must require admin authentication.

## 6. Success Metrics (Definition of Done)
- [ ] 100% TDD coverage for the Catalogue module.
- [ ] Working Hotwire search-select component in Admin UI.
- [ ] V1 API endpoints for Tags, Categories, and Quotes live and documented.
- [ ] Integration suite remains Green.
