# Download this
# curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash

# Then add into your ~/.bash_profile
# All systems
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# MacOS
# Install bash-completion with 'brew install git bash-completion'
if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ]; then
  . `brew --prefix`/etc/bash_completion.d/git-completion.bash
fi
