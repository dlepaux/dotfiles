# Zsh login shell — environment setup
# Sourced by all shells (interactive, non-interactive, VSCode, scripts)

# Brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
