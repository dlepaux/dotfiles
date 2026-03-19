---
name: north-star
description: Create, review, or update the project's NORTH-STAR.md — the product vision that guides architectural decisions
user-invocable: true
---

Manage the project's North Star document. This skill operates in three modes depending on context.

## Mode 1 — Create (NORTH-STAR.md does not exist)

### 1. Gather context

- Detect language/framework from manifest files (package.json, go.mod, Cargo.toml, composer.json, pyproject.toml, etc.)
- Scan project structure to understand the domain (directories, key modules, README if present)

### 2. Ask the user

Do NOT generate the file without asking. Ask these questions:

- "What is this product? Who is it for?"
- "What are the top 3 goals right now?"
- "What constraints or non-negotiables exist? (performance, compliance, accessibility, etc.)"
- "What is deliberately out of scope?"

### 3. Generate NORTH-STAR.md

Use the answers to create the file at the project root:

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

## Mode 2 — Review & Validate (NORTH-STAR.md exists, no arguments)

### 1. Read the North Star

Read the current NORTH-STAR.md.

### 2. Analyze codebase alignment

- Scan project structure, key modules, and dependencies
- Review recent git history (`git log --oneline -30`) for direction of recent work
- Compare what the North Star says vs what the code actually does

### 3. Report

Present a brief alignment report:

```
North Star Alignment Report
============================

Vision: <summarize current vision>

Aligned:
- <area where code matches stated goals>

Potential Drift:
- <area where code seems to diverge from stated goals or constraints>

Suggestions:
- <concrete suggestions to update the North Star or adjust the codebase>
```

Ask the user if they want to update the document based on findings.

## Mode 3 — Update (user explicitly asks to update)

### 1. Read current NORTH-STAR.md

### 2. Ask targeted questions

Only ask about sections that need updating — don't re-ask everything:

- "Have the goals changed? What are the current priorities?"
- "Any new constraints or things to rule out?"
- "Anything that should move to or from 'Out of Scope'?"

### 3. Apply changes

Update the file preserving the existing structure. Show a diff of changes before writing.
