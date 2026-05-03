# AureliusPress — Git Workflow

> Established: 2026-05-03

---

## Branch Strategy

### Rule: Never commit sprint work directly to `master`

`master` is the stable, deployable branch. All sprint and feature work happens on a dedicated branch and is merged via PR.

---

## Sprint Workflow

### 1. Branch naming

Each sprint gets its own branch, created from `master`:

```bash
git checkout master && git pull
git checkout -b sprint/7
```

For hotfixes or standalone features outside a sprint:

```bash
git checkout -b fix/comments-form-missing
git checkout -b feat/catalogue-search
```

### 2. Claude Code worktrees

Claude Code creates worktrees automatically (`.claude/worktrees/<hash>`). These worktrees are on a branch named `claude/<hash>`. At the end of each sprint session, push that branch and open a PR:

```bash
# From inside the worktree
git push -u origin claude/<hash>
gh pr create --base master --title "Sprint N: <goal>"
```

### 3. Merging

- PR is opened against `master` at sprint end (`/ship-current-sprint`)
- Review and merge via GitHub
- Delete the sprint branch after merge
- `master` now has all sprint changes; the running application picks them up

### 4. Why this matters

Running the application from `master` while sprint work lives in a worktree branch means changes (new views, controller fixes, gem additions) are invisible to the running app. This caused the missing comment/note forms bug in Sprint 6: the blog post show view and pages controller fix were committed to the sprint branch but never merged to `master`.

---

## Hotfix Workflow

If a bug must go directly to production (master):

```bash
git checkout master
git checkout -b fix/<description>
# Fix and test
git push -u origin fix/<description>
gh pr create --base master --title "Hotfix: <description>"
# Merge immediately
```

Then rebase the active sprint branch onto the updated master.

---

## PR Template

```
## Summary
- What changed and why (not what — git diff covers that)
- Sprint goal achieved? Y/N

## Test plan
- [ ] bundle exec rspec (all sprint specs green)
- [ ] RuboCop clean (new files)
- [ ] Manual QA: <what was tested>
- [ ] Known exclusions: <e.g. tyrian_purple_mockup_spec>
```

---

## Quick Reference

| Action | Command |
|--------|---------|
| Start sprint branch | `git checkout -b sprint/N` |
| Push worktree branch | `git push -u origin claude/<hash>` |
| Open sprint PR | `gh pr create --base master --title "Sprint N: ..."` |
| Merge PR | Via GitHub UI (squash or merge commit) |
| Delete merged branch | `git branch -d sprint/N` |
