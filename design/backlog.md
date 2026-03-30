# Agile Backlog: Taxonomy & API Sprint

## Use Case Format
"As a [user], I want to [action] so that [value]."

## MUST HAVE (Essential for Sprint success)
### 1. Catalogue TDD Audit
- **Use Case**: As a Developer, I want full test coverage for all Catalogue models so that the codebase is stable and regression-free.
- **Acceptance Criteria**:
    - [ ] `Author` model spec covers `ordered`, `with_quotes`, `with_affiliate_links` scopes and `bio_summary`.
    - [ ] `Quote` model spec covers `source_authors` delegation and `sluggable_text` generation.
    - [ ] `Source` model spec covers `ordered_by_title` and `ordered_by_type` scopes.

### 2. Internal Taxonomy API (Search)
- **Use Case**: As an Admin, I want to search tags and categories as I type so that I can quickly assign metadata to content.
- **Acceptance Criteria**:
    - [ ] `GET /aurelius-press/api/v1/taxonomy/tags?q=[query]` returns JSON of matching tags.
    - [ ] `GET /aurelius-press/api/v1/taxonomy/categories?q=[query]` returns JSON of matching categories.
    - [ ] API is versioned and secured for admin access.

### 3. Hotwire Taxonomy Search-Select
- **Use Case**: As an Admin, I want a unified search-select UI for taxonomy so that I don't have to toggle between static selects and text inputs.
- **Acceptance Criteria**:
    - [ ] Stimulus controller debounces search requests to the API.
    - [ ] Clicking a result adds it to the selection.
    - [ ] Hitting 'Enter' with a non-existent tag creates it via the API and selects it.

## SHOULD HAVE (Significant value)
### 4. Public Quote API V1
- **Use Case**: As a Public User/Consumer, I want a JSON interface for the Quote catalogue so that I can integrate stoic wisdom into other apps.
- **Acceptance Criteria**:
    - [ ] `GET /aurelius-press/api/v1/catalogue/quotes` returns paginated JSON.
    - [ ] Response includes nested Source and Author data.

## COULD HAVE (Desired but not critical)
### 5. Advanced Search Filters
- **Use Case**: As a Public User, I want to filter the Quote API by author or category so that I can find specific wisdom.
- **Acceptance Criteria**:
    - [ ] API supports `?author=[slug]` and `?category=[slug]` filters.

## WON'T HAVE (This time)
- **6. Write access for Public API**: No POST/PUT/DELETE for the public catalogue.
- **7. Global Site Search**: This sprint is focused specifically on taxonomy lookups and the catalogue API.
