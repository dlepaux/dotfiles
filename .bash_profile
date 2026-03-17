# Bash profile — lightweight fallback for when bash is used
# Primary shell is zsh (see .zshrc)

# Brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Git completion
# Install with: brew install git bash-completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi
if [ -f "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ]; then
  . "$(brew --prefix)/etc/bash_completion.d/git-completion.bash"
fi

# Starship prompt
eval "$(starship init bash)"
