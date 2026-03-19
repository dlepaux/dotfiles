#!/bin/bash
# Shell environment sourced by Claude Code before every Bash command.
# Set via CLAUDE_ENV_FILE in .zshenv

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null

# Rust — rustup + cargo-installed binaries
[ -d "/opt/homebrew/opt/rustup/bin" ] && export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
