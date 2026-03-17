#!/bin/bash
set -euo pipefail

# Auto-format a file based on its extension
# Receives JSON on stdin from Claude Code PostToolUse hook

if ! command -v jq &>/dev/null; then
  exit 0
fi

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

[ -z "$FILE_PATH" ] && exit 0
[ ! -f "$FILE_PATH" ] && exit 0

EXT="${FILE_PATH##*.}"
DIR=$(dirname "$FILE_PATH")

# Resolve DIR to absolute path to prevent infinite loop in find_root
DIR=$(cd "$DIR" 2>/dev/null && pwd) || exit 0

# Find project root by walking up to find a config file
find_root() {
  local dir="$DIR"
  while [ "$dir" != "/" ]; do
    [ -f "$dir/$1" ] && echo "$dir" && return
    dir=$(dirname "$dir")
  done
}

case "$EXT" in
  ts|tsx|js|jsx|json|css|scss|html|yaml|yml|md)
    ROOT=$(find_root "package.json")
    if [ -n "$ROOT" ]; then
      if [ -f "$ROOT/node_modules/.bin/prettier" ]; then
        "$ROOT/node_modules/.bin/prettier" --write "$FILE_PATH" 2>/dev/null || true
      elif [ -f "$ROOT/node_modules/.bin/biome" ]; then
        "$ROOT/node_modules/.bin/biome" format --write "$FILE_PATH" 2>/dev/null || true
      fi
    fi
    ;;
  rs)
    command -v rustfmt &>/dev/null && rustfmt "$FILE_PATH" 2>/dev/null || true
    ;;
  py)
    command -v black &>/dev/null && black -q "$FILE_PATH" 2>/dev/null || true
    command -v isort &>/dev/null && isort -q --profile black "$FILE_PATH" 2>/dev/null || true
    ;;
  go)
    command -v gofmt &>/dev/null && gofmt -w "$FILE_PATH" 2>/dev/null || true
    ;;
  php)
    ROOT=$(find_root "composer.json")
    if [ -n "$ROOT" ] && [ -f "$ROOT/vendor/bin/php-cs-fixer" ]; then
      "$ROOT/vendor/bin/php-cs-fixer" fix "$FILE_PATH" --quiet 2>/dev/null || true
    elif [ -n "$ROOT" ] && [ -f "$ROOT/vendor/bin/pint" ]; then
      "$ROOT/vendor/bin/pint" "$FILE_PATH" --quiet 2>/dev/null || true
    fi
    ;;
esac

exit 0
