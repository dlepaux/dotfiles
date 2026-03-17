---
name: fix-issue
description: Read a GitHub issue, implement the fix, test, and commit
user-invocable: true
argument-hint: "<issue-number-or-url>"
---

Fix GitHub issue $ARGUMENTS.

If no argument is provided, ask the user for an issue number.

## Steps

1. **Read the issue** — Run `gh issue view $ARGUMENTS` to get the full description, labels, and comments
2. **Understand the context** — Read relevant code files, understand the current behavior
3. **Create a branch** — `git checkout -b fix/$ARGUMENTS` (skip if already on a feature branch)
4. **Plan** — Briefly describe your approach before implementing. Ask if the user wants to proceed.
5. **Implement** — Write clean, minimal code that follows the project's patterns
6. **Test** — Run the project's test suite. Add tests if the fix warrants it
7. **Format** — Run the project's formatter/linter
8. **Commit** — Use conventional commit: `fix: <description> (#$ARGUMENTS)`
9. **PR** — Ask the user if they want to create a PR

If the issue is unclear or requires clarification, ask the user before implementing.
