# System Design: JavaScript Testing Infrastructure

## Overview
This system provides a high-performance unit testing environment for the AureliusPress JavaScript stack, specifically targeting Stimulus controllers. It uses Vitest for execution and JSDOM for browser simulation, bypassing the need for a full Rails server during unit testing.

## Components

### 1. Test Runner: Vitest
- **Rationale**: Extremely fast, native ESM support, and compatible with modern JS features used in Rails 7.
- **Config**: `vitest.config.ts` (or `.js`) in the root directory.

### 2. Environment: JSDOM
- **Rationale**: Provides a standard-compliant browser API (document, window, etc.) within Node.js.

### 3. Stimulus Helpers
- **Location**: `spec/javascript/support/stimulus_helper.js`
- **Responsibility**: Provides a standardized way to register and boot controllers on a clean JSDOM instance for every test.

### 4. Mocking Engine: Vitest Mocks
- **Responsibility**: Mocking global `fetch` calls to verify AJAX request headers and payloads.

## Directory Structure
```text
spec/javascript/
├── controllers/            # Unit tests for Stimulus controllers
│   ├── taxonomy_search_spec.js
│   └── social_engagement_spec.js
├── support/               # Test helpers and mocks
│   └── stimulus_helper.js
└── setup.js               # Global test configuration
```

## Importmapping Strategy
Since we use Rails Importmaps, Vitest needs to be aware of the "pinned" versions. We will use Vitest's `alias` configuration to map pinned imports:
- `@hotwired/stimulus` -> `node_modules/@hotwired/stimulus`
- `@hotwired/turbo` -> `node_modules/@hotwired/turbo`

## Interface Specification

### `ControllerTestHelper` (Trait-like Helper)
- `mount(html)`: Injects HTML into JSDOM and triggers Stimulus observation.
- `controller`: Returns the active controller instance.
- `get(selector)`: Alias for DOM queries.
