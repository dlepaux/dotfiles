#!/bin/bash
# Block reads/writes to .env files (allow .env.example, .env.template, .env.sample)
# Receives JSON on stdin from Claude Code PreToolUse hook

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

[ -z "$FILE_PATH" ] && exit 0

# Allow template files (ending in .example, .template, .sample)
if echo "$FILE_PATH" | grep -qE '\.(example|template|sample)$'; then
  exit 0
fi

# Block any .env file (.env, .env.local, .env.production, .env.anything)
if echo "$FILE_PATH" | grep -qE '(^|/)\.env($|\.)'; then
  echo "Blocked: .env files are protected. Use .env.example instead." >&2
  exit 2
fi

exit 0
