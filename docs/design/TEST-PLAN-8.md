# 4.1 Test Plan 8

This test plan is mapped to `3.2 SPRINT-PLAN-8.md`.

## 1. Content Block Deletion Spec Fixes
**Target:** Restore green status to the failing Capybara feature specs.

### Execution Steps:
1. Run `bundle exec rspec spec/features/aurelius_press/admin/document/blog_post/content_block_management_spec.rb:106`
2. Investigate whether the `DELETE` request is returning a Turbo Stream that correctly targets the DOM ID of the content block wrapper (`.rich-text-block`).
3. If it's a soft delete, ensure the view filters out discarded blocks.
4. Verify the exact same logic applies to Pages and Public UI feature specs.

**Expected Outcome:** 
All 4 feature specs pass, meaning the DOM successfully removes the targeted element on click.

## 2. CI Pipeline Verification
**Target:** Ensure `.github/workflows/ci.yml` is robust.

### Execution Steps:
1. Trigger a push to a test branch.
2. Verify the workflow sets up PostgreSQL correctly.
3. Verify the workflow successfully runs `bundle exec rspec` and `yarn test` (once implemented).

**Expected Outcome:** 
A green checkmark on GitHub PRs mirroring the local `1277 examples, 0 failures` state.

## 3. JavaScript Test Suite Initialization
**Target:** Prove the JS test runner is functional.

### Execution Steps:
1. Run `yarn test`.
2. Verify Vitest boots, uses JSDOM, and successfully parses `spec/javascript/controllers/taxonomy_search_spec.js`.

**Expected Outcome:**
At least one simple assertion (e.g., verifying a function exists) passes.
