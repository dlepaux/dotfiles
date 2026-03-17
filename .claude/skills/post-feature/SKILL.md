---
name: post-feature
description: Post-implementation quality check — re-inspect code after delivering a feature
user-invocable: true
---

Perform a systematic quality check on the recently implemented feature.

## Steps

1. **Identify scope** — Run `git diff main...HEAD --stat` (or `git diff --cached --stat`) to see all changed files and determine the project type

2. **Detect project type** — Check which config files exist (`package.json`, `Cargo.toml`, `composer.json`, `go.mod`, `pyproject.toml`) to determine which tools to run

3. **Format check** — Run only the formatter that matches the detected project type:
   - JS/TS: check for `prettier`, `biome`, or `dprint` in devDependencies, then run the one that's configured
   - Rust: `cargo fmt --check`
   - Python: `black --check .` and `isort --check --profile black .`
   - Go: `gofmt -l .`
   - PHP: check for `php-cs-fixer` or `pint` in vendor, run accordingly

4. **Lint check** — Same detection approach:
   - JS/TS: `npx eslint .` or `npx biome lint .`
   - Rust: `cargo clippy`
   - Python: `ruff check .` or `flake8 .`
   - Go: `golangci-lint run`

5. **Type check** — If applicable (`npx tsc --noEmit`, `mypy .`, `cargo check`)

6. **Test** — Run the full test suite

7. **Code review** — Use the `deep-reviewer` agent on all changed files

8. **Report** — Summarize findings with pass/fail status for each step

## Auto-fix rules

- Auto-fix formatting issues (mechanical)
- Auto-fix mechanical lint errors (unused imports, missing semicolons)
- Ask before changing any logic or structure
