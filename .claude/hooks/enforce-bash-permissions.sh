#!/bin/bash
# PreToolUse hook: auto-approve/deny Bash commands from settings.json rules.
# Decomposes compound commands (&&, ;, |) and checks each subcommand.
# Priority: deny (any match → deny all) > allow (all must match) > fall through.
#
# Workaround for https://github.com/anthropics/claude-code/issues/18160

set -uo pipefail

SETTINGS_FILE="$HOME/.claude/settings.json"
LOG_FILE="$HOME/.claude/hooks/enforce-bash-permissions.log"

command -v jq &>/dev/null || exit 0
[ -f "$SETTINGS_FILE" ] || exit 0

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
[ -z "$COMMAND" ] && exit 0

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1: $2 → cmd: $COMMAND" >> "$LOG_FILE"
}

decide() {
  local decision="$1" reason="$2"
  # Log deny and fall-through (ask) decisions for debugging
  if [[ "$decision" != "allow" ]]; then
    log "$decision" "$reason"
  fi
  jq -n --arg d "$decision" --arg r "$reason" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: $d,
      permissionDecisionReason: $r
    }
  }'
  exit 0
}

# Extract Bash() pattern contents from settings.json
# e.g. "Bash(git *)" → "git *", "Bash(pwd)" → "pwd"
extract_patterns() {
  local key="$1"
  jq -r ".permissions.$key // [] | .[]" "$SETTINGS_FILE" \
    | grep -oE '^Bash\(.*\)$' \
    | sed 's/^Bash(//; s/)$//'
}

# Check if a command matches a glob pattern
# Expands ~ to $HOME in patterns for path-based matching
matches_pattern() {
  local cmd="$1" pattern="$2"
  # Expand ~ at the start of pattern to $HOME
  pattern="${pattern/#\~/$HOME}"
  # shellcheck disable=SC2053
  [[ "$cmd" == $pattern ]]
}

# Load patterns once
DENY_PATTERNS=$(extract_patterns deny)
ALLOW_PATTERNS=$(extract_patterns allow)

ALL_ALLOWED=true

# Split on &&, ;, | and check each subcommand
while IFS= read -r subcmd; do
  # Strip leading/trailing whitespace
  subcmd=$(echo "$subcmd" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  [ -z "$subcmd" ] && continue

  # Skip env var assignments at the start (e.g. FOO=bar command)
  subcmd_normalized="$subcmd"
  while [[ "$subcmd_normalized" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]]; do
    subcmd_normalized=$(echo "$subcmd_normalized" | sed 's/^[^ ]* *//')
  done
  [ -z "$subcmd_normalized" ] && continue

  # Expand ~ at the start of the command for matching
  subcmd_expanded="${subcmd_normalized/#\~/$HOME}"

  # Check deny patterns first — any match → deny the whole command
  while IFS= read -r pattern; do
    [ -z "$pattern" ] && continue
    if matches_pattern "$subcmd_expanded" "$pattern"; then
      decide deny "Blocked by deny rule: '$subcmd_normalized' matches Bash($pattern)"
    fi
  done <<< "$DENY_PATTERNS"

  # Check allow patterns — need at least one match for this subcommand
  SUBCMD_ALLOWED=false
  while IFS= read -r pattern; do
    [ -z "$pattern" ] && continue
    if matches_pattern "$subcmd_expanded" "$pattern"; then
      SUBCMD_ALLOWED=true
      break
    fi
  done <<< "$ALLOW_PATTERNS"

  if ! $SUBCMD_ALLOWED; then
    ALL_ALLOWED=false
  fi

done <<< "$(echo "$COMMAND" | sed 's/&&/\n/g; s/;/\n/g; s/|/\n/g')"

if $ALL_ALLOWED; then
  decide allow "All subcommands matched allow rules"
fi

# Fall through: at least one subcommand wasn't explicitly allowed → normal prompt
log "ask" "No matching allow rule (fall-through)"
exit 0
