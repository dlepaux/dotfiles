---
name: deploy-check
description: Pre-deployment checklist — verify everything is ready to ship
user-invocable: true
---

Run a pre-deployment checklist before merging or deploying.

## Checklist

1. **Git status** — No uncommitted changes, clean working tree
2. **Branch** — Up to date with main (`git fetch && git log HEAD..origin/main --oneline`)
3. **Lock file** — Lock file consistent with manifest (verify, do not install)
4. **Build** — Project builds without errors
5. **Tests** — Full test suite passes
6. **Lint** — No lint errors
7. **Types** — No type errors (if applicable)
8. **Environment** — `.env.example` exists and lists all required vars
9. **Secrets scan** — Search for potential hardcoded secrets:
   - Look for strings matching API key patterns (`AKIA`, `sk-`, `ghp_`, `ghs_`)
   - Check for base64-encoded strings longer than 40 chars in source code
   - Verify no `.env` files are staged
10. **CI status** — Run `gh pr checks` or `gh run list --limit 1` to verify CI passes
11. **TODO/FIXME** — List any remaining TODOs in changed files

## Output

Report as a checklist with pass/fail status for each item.
If any item from 1-7 fails, explicitly state **DO NOT DEPLOY** and explain why.
