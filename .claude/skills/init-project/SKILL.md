---
name: init-project
description: Audit project setup and bootstrap missing configuration files (CLAUDE.md, NORTH-STAR.md, .editorconfig, .env.example)
user_invocable: true
---

# Init Project

Audit the current project for missing configuration and guide the user through creating it.

## Steps

### 1. Detect project context

- Identify the language/framework (package.json, Cargo.toml, pyproject.toml, composer.json, go.mod, etc.)
- Identify the test runner, linter, formatter from config files
- Check for CI/CD config (.github/workflows, .gitlab-ci.yml, etc.)
- Check for Docker setup (Dockerfile, docker-compose.yml)

### 2. Audit these files

Check for the existence of each file and report status:

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Project-level Claude instructions (stack, conventions, commands) |
| `NORTH-STAR.md` | Product vision and goals |
| `.editorconfig` | Editor consistency |
| `.env.example` | Environment variable documentation |
| `.gitignore` | Git ignore rules |

### 3. Report findings

Display a checklist:

```
Project: <name> (<language/framework>)

[x] .gitignore — exists
[ ] CLAUDE.md — missing
[ ] NORTH-STAR.md — missing
[x] .editorconfig — exists
[ ] .env.example — missing
```

### 4. For each missing file, ask the user

Do NOT create files without asking. For each missing file, ask targeted questions:

#### CLAUDE.md
- "What are the key commands to build, test, and lint this project?"
- "Any project-specific conventions I should know? (naming, patterns, forbidden practices)"
- "What's the deployment process?"

Use the answers to generate a concise CLAUDE.md following this structure:

```markdown
# Project Name

## Stack
<language, framework, key dependencies>

## Commands
<build, test, lint, format, deploy>

## Conventions
<project-specific rules>

## Architecture
<brief description of key directories/modules>
```

#### NORTH-STAR.md
- "What is this product? Who is it for?"
- "What are the top 3 goals right now?"
- "What constraints or non-negotiables exist? (performance, compliance, accessibility)"

Use the answers to generate:

```markdown
# North Star

## Vision
<one-paragraph product vision>

## Current Goals
1. <goal>
2. <goal>
3. <goal>

## Constraints
- <constraint>

## Out of Scope
- <what we deliberately don't do>
```

#### .env.example
- Scan the codebase for `process.env.`, `os.environ`, `env::var`, `$_ENV` patterns
- List discovered variables and ask the user to confirm
- Generate .env.example with empty values and comments

#### .editorconfig
- Propose defaults based on the detected language (2 spaces for JS/TS, 4 for Python/Rust)
- Ask the user to confirm before creating

### 5. Summary

After creating files, show what was created and remind the user to review them.
