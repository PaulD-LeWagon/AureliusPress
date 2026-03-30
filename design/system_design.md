# System Design: Taxonomy UX & API Architecture

## 1. Overview
This design specifies the architectural structure for the AureliusPress V1 API and the Hotwire-powered Taxonomy selection component.

## 2. API Architecture
### 2.1 Namespace & Versioning
- **Root**: `AureliusPress::Api::V1`
- **Path**: `/aurelius-press/api/v1/`
- **Base Controller**: Inherits from `AureliusPress::ApplicationController` and handles JSON rendering defaults.

### 2.2 Controllers
- `AureliusPress::Api::V1::Taxonomy::TagsController < BaseController`
    - Action: `index(params[:q])` - Returns JSON of tags.
    - Action: `create(params[:name])` - Creates and returns a tag.
- `AureliusPress::Api::V1::Taxonomy::CategoriesController < BaseController`
    - Action: `index(params[:q])` - Returns JSON of categories.
- `AureliusPress::Api::V1::Catalogue::QuotesController < BaseController`
    - Action: `index` - Returns paginated list of quotes using `jbuilder`.

## 3. Hotwire UX Component
### 3.1 Stimulus Controller: `taxonomy-search`
- **Targets**: `input`, `results`, `selection_list`.
- **Actions**:
    - `search()`: Triggered by `input` event (debounced).
    - `select(event)`: Triggered by clicking a result in the list.
    - `create(event)`: Triggered by 'Enter' in the input if no result is highlighted.
- **Data Attributes**: `url` (API endpoint), `param` (query parameter name).

### 3.2 Turbo Integration
- Use **Turbo Streams** to append newly created tags/categories to the UI without a full page reload if necessary, or simply update the hidden `tag_ids` array and shown selection list.

## 4. Module Extensions (TRAITS/CONCERNS)
### 4.1 `Sluggable` Enhancement [EXISTING]
- Ensure reliable slug generation for newly created tags and categories.

## 5. Persistence Layer (Data Flow)
1. User types in search input.
2. Stimulus controller sends fetch request to `Api::V1::Taxonomy::TagsController`.
3. Controller queries `AureliusPress::Taxonomy::Tag.where("name ILIKE ?", "%#{params[:q]}%")`.
4. JSON results returned to Stimulus.
5. Stimulus renders results in a dropdown.
6. User selects existing OR hits Enter (triggering a POST to `create`).
7. Resulting Tag object is added to the document's `tag_ids` collection (hidden field).

## 6. Testing Strategy (TDD)
### 6.1 Unit Tests (Models)
- Test missing scopes/methods in Catalogue models.
- Test `Tag` and `Category` creation logic.

### 6.2 Request Specs (API)
- Test each V1 endpoint for correct JSON structure and response codes.
- Test authentication/authorization.

### 6.3 System Specs (System UI)
- Test the full Hotwire flow from typing to selection to save.
