---
name: review
description: Code review on current changes
user-invocable: true
argument-hint: "[file-or-scope]"
---

Review the current code changes.

If $ARGUMENTS is provided, review that specific file or scope.
Otherwise, review all uncommitted changes.

## Determine review depth

Run `git diff HEAD --stat | tail -1` to count total lines changed.

- If under 200 lines changed, use the `reviewer` agent (quick review).
- If 200+ lines changed, or user asks for a deep review, use the `deep-reviewer` agent.

If `git diff HEAD` shows nothing, try `git diff main...HEAD` for branch-level changes.
If still nothing, inform the user there are no changes to review.

After the review, apply concrete fixes for any issues found when the fix is mechanical (formatting, unused imports, naming). Ask before making logic changes.
