# Sprint 8 Plan — AureliusPress

**Dates:** TBD
**Team:** 1 engineer (solo)
**Sprint Goal:** Fix newly discovered test failures related to ContentBlock deletion and review/fix the GitHub Actions CI configuration.

---

## Sprint Backlog

### P0 — Fix ContentBlock Deletion Test Failures

Four feature specs are currently failing when attempting to delete a ContentBlock. The assertion `expect(page).not_to have_css(".rich-text-block")` is failing because the element remains on the page.

| # | Item | Pts | Dependencies | Notes |
|---|---|---|---|---|
| S8-01 | Fix Admin BlogPost ContentBlock delete spec failure | 1 | None | `spec/features/aurelius_press/admin/document/blog_post/content_block_management_spec.rb:106` |
| S8-02 | Fix Admin Page ContentBlock delete spec failure | 1 | None | `spec/features/aurelius_press/admin/document/page/content_block_management_spec.rb:106` |
| S8-03 | Fix Public BlogPost ContentBlock delete spec failure | 1 | None | `spec/features/aurelius_press/public/document/blog_post/content_block_management_spec.rb:107` |
| S8-04 | Fix Public Page ContentBlock delete spec failure | 1 | None | `spec/features/aurelius_press/public/document/page/content_block_management_spec.rb:107` |

**Proposed Plan of Action:**
1. **Investigate Content Block deletion mechanism:** Determine if Content Blocks are using hard deletion or if they are affected by the soft-deletion (`discard` gem) implemented for Fragments in Sprint 4.
2. **Verify Turbo Stream Responses:** Check `destroy.turbo_stream.erb` for ContentBlocks (or the fallback redirect). Ensure it correctly removes the corresponding DOM element. If soft-deleted, ensure the view filters out discarded records, or the Turbo Stream explicitly removes it from the UI.
3. **Review the DOM IDs:** Verify that the `div` being targeted by the Turbo Stream or the Capybara assertion `.rich-text-block` is correctly identified and removed during the `DELETE` action.
4. **Fix the implementation:** Update the controller, Turbo Stream views, or model scopes to correctly remove the element from the DOM upon deletion and make the tests pass.

### P1 — Infrastructure & CI

| # | Item | Pts | Dependencies | Notes |
|---|---|---|---|---|
| S8-05 | Review and fix GitHub Actions CI configuration | 2 | None | As noted in Sprint 7 retro, the CI pipeline needs review to ensure it accurately runs the RSpec suite, correctly handles dependencies, and properly reports status. |

---

## Capacity

*To be planned*

---

## Definition of Done
- [ ] All 4 ContentBlock deletion feature specs pass successfully.
- [ ] The full test suite remains green.
- [ ] GitHub Actions CI workflow is reviewed, tested, and reliably passing on pushes/PRs.
