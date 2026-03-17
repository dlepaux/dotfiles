#!/bin/zsh
# Symlink dotfiles to home directory
# Usage: ./install.sh

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Shell configs
ln -sf "$DOTFILES_DIR/.zprofile" ~/.zprofile
ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/.bash_profile" ~/.bash_profile
ln -sf "$DOTFILES_DIR/.gitconfig" ~/.gitconfig

# Starship config
mkdir -p ~/.config
ln -sf "$DOTFILES_DIR/starship.toml" ~/.config/starship.toml

# VSCode MCP config
mkdir -p ~/.vscode
ln -sf "$DOTFILES_DIR/mcp.json" ~/.vscode/mcp.json

# Claude Code settings
mkdir -p ~/.claude
ln -sf "$DOTFILES_DIR/.claude/settings.json" ~/.claude/settings.json

# Secrets template
if [ ! -f ~/.secrets ]; then
  cp "$DOTFILES_DIR/.secrets.example" ~/.secrets
  chmod 600 ~/.secrets
  echo "Created ~/.secrets from template — edit it with your API keys."
fi

# Claude Code MCP servers (merge into ~/.claude.json)
if [ -f ~/.claude.json ]; then
  jq --slurpfile servers "$DOTFILES_DIR/.claude/mcp-servers.json" \
    '.mcpServers = $servers[0]' ~/.claude.json > ~/.claude.json.tmp \
    && mv ~/.claude.json.tmp ~/.claude.json
  echo "Claude Code MCP servers synced."
elif command -v claude &>/dev/null; then
  echo "Run 'claude' once to initialize ~/.claude.json, then re-run install.sh."
else
  echo "Claude Code not installed — skipping MCP server setup."
fi

echo "Dotfiles linked. Open a new terminal tab to apply."
