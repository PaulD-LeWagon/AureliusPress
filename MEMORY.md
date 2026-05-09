# AureliusPress Project Memory

## Current Context
- **Active Phase:** Technical Debt / CI Repair
- **Current Sprint:** Sprint 8 (`docs/design/3.2 SPRINT-PLAN-8.md`)
- **Key Focus:** Fixing Capybara UI feature specs for ContentBlock deletion (`S8-01` to `S8-04`) and initializing JavaScript testing infrastructure with Vitest.

## Recent Milestones
- Completed the core Phase 1–7 CMS features (Blog Posts, Taxonomic search, Pundit Authorization, Groups, Likes).
- Retrofitted documentation to the Indie Agentic Dev Studio format in `docs/design/`.

## Important Known Issues
- Content Blocks are not successfully disappearing from the DOM in Capybara system tests when soft-deleted / destroyed via Turbo Streams.
- The GitHub Actions CI pipeline requires review to ensure it correctly fails on RSpec failures.
