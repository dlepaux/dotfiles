---
name: issue
description: Create a well-structured GitHub issue with context, acceptance criteria, and labels
user_invocable: true
args: "<title or description of the issue>"
---

# Create GitHub Issue

Create a structured GitHub issue on the current repository.

## Steps

### 1. Determine repository

- Use `git remote get-url origin` to identify the GitHub repo
- If not a GitHub repo, stop and inform the user

### 2. Gather context

From the user's argument, determine:
- **Type**: bug, feature, enhancement, chore, docs
- **Scope**: which part of the codebase is affected

If the argument is vague, ask clarifying questions:
- "Can you describe the expected vs actual behavior?" (for bugs)
- "What problem does this solve?" (for features)

### 3. Draft the issue

Structure the issue body as:

For **bugs**:
```markdown
## Description
<what's happening>

## Steps to Reproduce
1. <step>

## Expected Behavior
<what should happen>

## Actual Behavior
<what happens instead>

## Context
- Environment: <OS, browser, version>
- Related files: <paths>
```

For **features/enhancements**:
```markdown
## Description
<what and why>

## Acceptance Criteria
- [ ] <criterion>
- [ ] <criterion>

## Technical Notes
<implementation hints, related code, constraints>
```

### 4. Confirm with user

Show the draft title and body. Ask:
- "Does this look right? Any changes before I create it?"
- "Any labels to add?" (suggest relevant ones based on type: `bug`, `enhancement`, `documentation`)

### 5. Create the issue

Use the GitHub MCP tools to create the issue:
- `mcp__github__issue_write` with method `create`
- Apply labels if specified
- Return the issue URL to the user
