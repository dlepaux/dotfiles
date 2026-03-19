#!/bin/bash
# Tests for enforce-bash-permissions.sh
# Run: bash .claude/hooks/enforce-bash-permissions.test.sh

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOOK="$SCRIPT_DIR/enforce-bash-permissions.sh"
PASS=0
FAIL=0

run_hook() {
  echo "{\"tool_input\":{\"command\":\"$1\"}}" | bash "$HOOK" 2>/dev/null
}

expect() {
  local label="$1" command="$2" expected="$3"
  local output decision

  output=$(run_hook "$command")
  decision=$(echo "$output" | jq -r '.hookSpecificOutput.permissionDecision // "fallthrough"' 2>/dev/null)
  # No output means fall through to normal prompt
  [ -z "$decision" ] || [ "$decision" = "null" ] && decision="fallthrough"

  if [ "$decision" = "$expected" ]; then
    PASS=$((PASS + 1))
  else
    echo "FAIL: $label"
    echo "  command:  $command"
    echo "  expected: $expected"
    echo "  got:      $decision"
    FAIL=$((FAIL + 1))
  fi
}

# --- Simple commands ---
expect "simple allowed command"         "git status"                allow
expect "allowed with args"              "ls -la /tmp"               allow
expect "exact match no wildcard"        "pwd"                       allow
expect "denied command"                 "sudo apt install foo"      deny

# --- Compound commands ---
expect "both allowed (&&)"              "git log && ls -la"         allow
expect "both allowed (;)"              "npm install; npm test"      allow
expect "both allowed (|)"              "ls -la | grep foo"          allow
expect "denied in second (&&)"         "git status && sudo rm -rf /" deny
expect "denied in first (;)"           "sudo rm -rf /; git status"  deny
expect "denied in pipe"                "ls | sudo tee /etc/passwd"  deny

# --- Unknown commands fall through ---
expect "unknown command"               "unknown_binary --flag"      fallthrough
expect "allowed + unknown (&&)"        "git status; unknown_cmd"    fallthrough

# --- Path-based commands ---
expect ".venv command"                 ".venv/bin/python script.py" allow
expect ".venv/bin/pip"                 ".venv/bin/pip install foo"  allow
expect "cargo in PATH"                "cargo build"                 allow

# --- Env var prefix ---
expect "env var + allowed"             "FOO=bar npm test"           allow
expect "multiple env vars"             "A=1 B=2 node index.js"     allow
expect "env var + denied"              "FOO=bar sudo rm -rf /"     deny
expect "env var + unknown"             "FOO=bar unknown_cmd"        fallthrough

# --- Edge cases ---
expect "empty-ish whitespace"          "  git status  "             allow
expect "multi-word pattern"            "openssl rand -hex 32"       allow
expect "compound three parts"          "git status && npm test && ls" allow

# --- Results ---
echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
