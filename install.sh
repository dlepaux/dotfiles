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

echo "Dotfiles linked. Open a new terminal tab to apply."
