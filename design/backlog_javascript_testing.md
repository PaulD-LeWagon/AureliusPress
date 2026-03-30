# Backlog: JavaScript Testing Infrastructure

## Use Cases

### MUST HAVE (Critical Path)
1. **Runner Setup**: As a developer, I want a fast JS test runner (Vitest) so that I can verify logic without the overhead of a full browser boot.
   - **Acceptance Criteria**: `yarn test` runs and finds files in `spec/javascript`.
2. **DOM Mocking**: As a developer, I want a simulated browser environment (JSDOM) so that I can test Stimulus controllers in isolation.
   - **Acceptance Criteria**: Tests can manipulate `document` and `window`.
3. **Taxonomy Search Validation**: As a developer, I want to test the `taxonomy_search` controller so that I can ensure AJAX searches and dropdown updates work independently of the backend.
   - **Acceptance Criteria**: Mocking a JSON response updates the target container.
4. **Social Engagement Validation**: As a developer, I want to test the emoji reaction logic to ensure headers and credentials are sent correctly.
   - **Acceptance Criteria**: Verify correct headers in a mocked `fetch` call.

### SHOULD HAVE (Significant Value)
1. **Slug Logic Validation**: As a developer, I want to test `auto_slugify` to ensure titles are correctly transformed into URL-safe strings.
   - **Acceptance Criteria**: Inputting "Hello World!" results in "hello-world".
2. **Stimulus Lifecycle Probes**: As a developer, I want to verify that controllers `connect()` properly and initialize their targets.

### COULD HAVE (Nice to Have)
1. **Coverage Reporting**: As a developer, I want to see which lines of JS are covered by tests.
2. **RSpec Integration**: A custom RSpec task that runs both Ruby and JS tests.

### WON'T HAVE (Out of Scope)
1. **E2E Visual Regression**: Testing CSS layout/rendering (handled by system specs).
