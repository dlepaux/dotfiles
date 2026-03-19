# Zsh environment — sourced by ALL zsh instances (scripts, IDE, Claude Code, etc.)
# Only PATH and env vars here — no interactive stuff (completions, prompts, aliases)

# Claude Code — env file sourced before every Bash command
export CLAUDE_ENV_FILE="$HOME/.claude/bash_env.sh"

# Brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

# Rust — rustup is keg-only via Homebrew, binaries not in /opt/homebrew/bin
# Must be before brew prefix so rustup-managed toolchain takes priority
[ -d "/opt/homebrew/opt/rustup/bin" ] && export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
# Also load cargo env for tools installed via `cargo install`
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env" || true
