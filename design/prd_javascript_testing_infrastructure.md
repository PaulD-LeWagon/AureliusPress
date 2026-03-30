# PRD: JavaScript Testing Infrastructure

## Executive Summary
AureliusPress relies on sophisticated frontend interactions (Turbo 8, Stimulus) for content management, but currently lacks a dedicated unit testing suite for these components. This leads to "inert" UI failures that are difficult to diagnose in full-stack RSpec feature tests. We will implement a dedicated JavaScript testing suite in `spec/javascript` to provide immediate feedback on script health and functionality.

## Functional Requirements
1. **Connectivity Verification**: Ensure every JavaScript file in `app/javascript` correctly loads without syntax or resolution errors.
2. **Stimulus Unit Testing**: Test individual Stimulus controllers in isolation (e.g., `taxonomy-search`, `social-engagement`) by mocking the DOM.
3. **Automated Discovery**: The test suite must automatically find and run tests located in `spec/javascript`.
4. **CI Integration**: Provide a single command to execute the entire JS test suite.

## Technical Constraints & Environment
- **Runtime**: Vitest is the preferred runner for its speed and modern ESM support.
- **Environment**: JSDOM or Happy DOM to simulate the browser environment.
- **Project Context**: Must work with the existing Rails 7.2 + Importmaps structure.

## User Flow
1. Developer adds a new Stimulus controller in `app/javascript/controllers/`.
2. Developer adds a corresponding spec in `spec/javascript/controllers/`.
3. Developer runs `yarn test` to verify logic before even opening a browser.

## Success Metrics (Definition of Done)
- A green `spec/javascript` suite protecting all core controllers.
- 100% of JS files verified for successful initialization.
- Ability to catch regressions (like missing headers or failed fetches) in isolation.
