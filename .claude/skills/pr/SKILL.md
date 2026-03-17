---
name: pr
description: Create a pull request with structured description, test plan, and linked issues
user_invocable: true
args: "[base-branch] — defaults to main"
---

# Create Pull Request

Create a well-structured PR for the current branch.

## Steps

### 1. Gather context

- Run `git log main..HEAD --oneline` (or the specified base branch) to see all commits
- Run `git diff main...HEAD --stat` to see changed files
- Check for linked issues in commit messages (e.g., `#123`, `fixes #456`)
- Check for a PR template at `.github/pull_request_template.md` or `.github/PULL_REQUEST_TEMPLATE/`

### 2. Analyze changes

Categorize the changes:
- **Type**: feature, bugfix, refactor, docs, chore
- **Scope**: which modules/areas are affected
- **Breaking changes**: any API changes, schema migrations, env var additions

### 3. Draft the PR

If a PR template exists, use it. Otherwise use this structure:

```markdown
## Summary
<1-3 bullet points explaining what and why>

## Changes
- <grouped by area/module>

## Linked Issues
<closes #N, fixes #N — if applicable>

## Breaking Changes
<if any, otherwise omit this section>

## Test Plan
- [ ] <how to verify this works>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

**Title**: Keep under 70 characters. Use conventional commit format: `feat: add user authentication`

### 4. Confirm with user

Show the draft title, body, and base branch. Ask:
- "Ready to create? Any changes?"
- "Should I push the branch first?" (if not yet pushed)

### 5. Create

- Push branch with `-u` if needed
- Create PR using `gh pr create`
- Return the PR URL
