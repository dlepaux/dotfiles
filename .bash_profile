# Once the sexy-bash-prompt is setted, you will need to update the Terminal Settings to open shell with /bin/bash !

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


# Sexy bash prompt by twolfson
# https://github.com/twolfson/sexy-bash-prompt
# Forked from gf3, https://gist.github.com/gf3/306785

# Determine what type of terminal we are using for `tput`
if [[ $COLORTERM = gnome-* && $TERM = xterm ]]  && infocmp gnome-256color >/dev/null 2>&1; then export TERM=gnome-256color
elif [[ $TERM != dumb ]] && infocmp xterm-256color >/dev/null 2>&1; then export TERM=xterm-256color
fi

# If we are on a colored terminal
if tput setaf 1 &> /dev/null; then
  # Reset the shell from our `if` check
  tput sgr0

  # If the terminal supports at least 256 colors, write out our 256 color based set
  if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
    USER_COLOR=$(tput setaf 27) #BLUE
    PREPOSITION_COLOR=$(tput setaf 7) #WHITE
    DEVICE_COLOR=$(tput setaf 39) #INDIGO
    DIR_COLOR=$(tput setaf 76) #GREEN
    GIT_STATUS_COLOR=$(tput setaf 154) #YELLOW
  else
  # Otherwise, use colors from our set of 16
    # Original colors from fork
    USER_COLOR=$(tput setaf 5) #MAGENTA
    PREPOSITION_COLOR=$(tput setaf 7) #WHITE
    DEVICE_COLOR=$(tput setaf 4) #ORANGE
    DIR_COLOR=$(tput setaf 2) #GREEN
    GIT_STATUS_COLOR=$(tput setaf 1) #PURPLE
  fi

  # Save common color actions
  BOLD=$(tput bold)
  NORMAL=$PREPOSITION_COLOR
  RESET=$(tput sgr0)
else
# Otherwise, use ANSI escape sequences for coloring
  # Original colors from fork
  USER_COLOR="\033[1;31m" #MAGENTA
  PREPOSITION_COLOR="\033[1;37m" #WHITE
  DEVICE_COLOR="\033[1;33m" #ORANGE
  DIR_COLOR="\033[1;32m" #GREEN
  GIT_STATUS_COLOR="\033[1;35m" #PURPLE
  BOLD=""
  RESET="\033[m"
fi

function get_git_branch() {
  # On branches, this will return the branch name
  # On non-branches, (no branch)
  git symbolic-ref HEAD --short 2> /dev/null || echo "(no branch)"
}

is_branch1_behind_branch2 () {
  # $ git log origin/master..master -1
  # commit 4a633f715caf26f6e9495198f89bba20f3402a32
  # Author: Todd Wolfson <todd@twolfson.com>
  # Date:   Sun Jul 7 22:12:17 2013 -0700
  #
  #     Unsynced commit

  # Find the first log (if any) that is in branch1 but not branch2
  FIRST_LOG="$(git log $1..$2 -1 2> /dev/null)"

  # Exit with 0 if there is a first log, 1 if there is not
  [[ -n $FIRST_LOG ]]
}

branch_exists () {
  # List remote branches           | # Find our branch and exit with 0 or 1 if found/not found
  git branch --remote 2> /dev/null | grep --quiet "$1"
}

parse_git_ahead () {
  # Grab the local and remote branch
  BRANCH="$(get_git_branch)"
  REMOTE_BRANCH=origin/"$BRANCH"

  # $ git log origin/master..master
  # commit 4a633f715caf26f6e9495198f89bba20f3402a32
  # Author: Todd Wolfson <todd@twolfson.com>
  # Date:   Sun Jul 7 22:12:17 2013 -0700
  #
  #     Unsynced commit

  # If the remote branch is behind the local branch
  # or it has not been merged into origin (remote branch doesn't exist)
  if (is_branch1_behind_branch2 "$REMOTE_BRANCH" "$BRANCH" ||
      ! branch_exists "$REMOTE_BRANCH"); then
    # echo our character
    echo 1
  fi
}

parse_git_behind () {
  # Grab the branch
  BRANCH="$(get_git_branch)"
  REMOTE_BRANCH=origin/"$BRANCH"

  # $ git log master..origin/master
  # commit 4a633f715caf26f6e9495198f89bba20f3402a32
  # Author: Todd Wolfson <todd@twolfson.com>
  # Date:   Sun Jul 7 22:12:17 2013 -0700
  #
  #     Unsynced commit

  # If the local branch is behind the remote branch
  if is_branch1_behind_branch2 "$BRANCH" "$REMOTE_BRANCH"; then
    # echo our character
    echo 1
  fi
}

parse_git_dirty () {
  # ?? file.txt # Unstaged new files
  # A  file.txt # Staged new files
  #  M file.txt # Unstaged modified files
  # M  file.txt # Staged modified files
  #  D file.txt # Unstaged deleted files
  # D  file.txt # Staged deleted files

  # If the git status has *any* changes (i.e. dirty)
  if [[ -n "$(git status --porcelain 2> /dev/null)" ]]; then
    # echo our character
    echo 1
  fi
}

function is_on_git() {
  git rev-parse 2> /dev/null
}

function get_git_status() {
  # Grab the git dirty and git behind
  DIRTY_BRANCH="$(parse_git_dirty)"
  BRANCH_AHEAD="$(parse_git_ahead)"
  BRANCH_BEHIND="$(parse_git_behind)"

  # Iterate through all the cases and if it matches, then echo
  if [[ $DIRTY_BRANCH == 1 && $BRANCH_AHEAD == 1 && $BRANCH_BEHIND == 1 ]]; then
    echo "⬢"
  elif [[ $DIRTY_BRANCH == 1 && $BRANCH_AHEAD == 1 ]]; then
    echo "▲"
  elif [[ $DIRTY_BRANCH == 1 && $BRANCH_BEHIND == 1 ]]; then
    echo "▼"
  elif [[ $BRANCH_AHEAD == 1 && $BRANCH_BEHIND == 1 ]]; then
    echo "⬡"
  elif [[ $BRANCH_AHEAD == 1 ]]; then
    echo "△"
  elif [[ $BRANCH_BEHIND == 1 ]]; then
    echo "▽"
  elif [[ $DIRTY_BRANCH == 1 ]]; then
    echo "*"
  fi
}

get_git_info () {
  # Grab the branch
  BRANCH="$(get_git_branch)"

  # If there are any branches
  if [[ $BRANCH != "" ]]; then
    # Echo the branch
    OUTPUT=$BRANCH

    # Add on the git status
    OUTPUT=$OUTPUT"$(get_git_status)"

    # Echo our output
    echo $OUTPUT
  fi
}

# Symbol displayed at the line of every prompt
get_prompt_symbol () {
  # Some prompts display $ for a non-version control dir, ∓ for git, and § for mercurial
  # I have chosen to keep it consistent
  echo "\$"
}

# Define the sexy-bash-prompt
PS1="\[${BOLD}${USER_COLOR}\]\u \
\[$PREPOSITION_COLOR\]at \
\[$DEVICE_COLOR\]\h \
\[$PREPOSITION_COLOR\]in \
\[$DIR_COLOR\]\w\
\[$PREPOSITION_COLOR\]\
\$( is_on_git && \
  echo -n \" on \" && \
  echo -n \"\[$GIT_STATUS_COLOR\]\$(get_git_info)\" && \
  echo -n \"\[$NORMAL\]\")\n\
$(get_prompt_symbol) \[$RESET\]"
