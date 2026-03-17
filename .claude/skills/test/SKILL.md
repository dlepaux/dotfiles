---
name: test
description: Detect project type and run the appropriate test suite
user-invocable: true
argument-hint: "[test-filter]"
---

Detect the project type and run the appropriate test command.

If $ARGUMENTS is provided, use it as a test filter/pattern.

## Detection

Check which config files exist at the project root, then verify the test command is actually configured:

1. `package.json` with a `test` script → `npm test` (or `npm test -- $ARGUMENTS`)
2. `composer.json` → `composer test` (or `./vendor/bin/phpunit $ARGUMENTS`)
3. `Cargo.toml` → `cargo test $ARGUMENTS`
4. `go.mod` → `go test ./... $ARGUMENTS`
5. `pyproject.toml` / `setup.py` → `pytest $ARGUMENTS`
6. `Makefile` with a `test` target → `make test`
7. `docker-compose.yml` with a test service → check and suggest

If `package.json` exists but has no `test` script, skip it and check the next option.

If tests fail, read the output and provide:
- The failing test name
- The assertion that failed
- The likely root cause
