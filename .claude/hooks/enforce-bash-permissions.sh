#!/bin/bash
# Auto-approve/deny Bash commands by reading settings.json allow/deny lists.
# Workaround for https://github.com/anthropics/claude-code/issues/18160
# (settings.json glob matching fails on special characters like parentheses).
#
# Deny rules checked first, then allow, then falls through to normal prompt.

set -e

SETTINGS_FILE="$HOME/.claude/settings.json"

if ! command -v jq &>/dev/null; then
  exit 0
fi

[ ! -f "$SETTINGS_FILE" ] && exit 0

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

[ -z "$COMMAND" ] && exit 0

# Extract first real command word, skipping env var assignments (VAR=val)
first_word=$(echo "$COMMAND" | awk '{for(i=1;i<=NF;i++){if(index($i,"=")==0){print $i;exit}}}')

[ -z "$first_word" ] && exit 0

decide() {
  local decision="$1" reason="$2"
  jq -n --arg d "$decision" --arg r "$reason" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: $d,
      permissionDecisionReason: $r
    }
  }'
  exit 0
}

# Extract first words from Bash(...) patterns in settings.json
# e.g. "Bash(git *)" → "git", "Bash(openssl rand *)" → "openssl"
extract_commands() {
  local key="$1"
  jq -r ".permissions.$key // [] | .[]" "$SETTINGS_FILE" \
    | grep -oE '^Bash\([^ )]+' \
    | sed 's/^Bash(//' \
    | sort -u
}

# --- DENY (checked first) ---
while IFS= read -r denied; do
  [ -z "$denied" ] && continue
  if [ "$first_word" = "$denied" ]; then
    decide deny "Blocked by settings.json deny rule: $first_word"
  fi
done <<< "$(extract_commands deny)"

# --- ALLOW ---
while IFS= read -r allowed; do
  [ -z "$allowed" ] && continue
  if [ "$first_word" = "$allowed" ]; then
    decide allow "Auto-approved by settings.json allow rule: $first_word"
  fi
done <<< "$(extract_commands allow)"

# Fall through: normal permission prompt
exit 0
