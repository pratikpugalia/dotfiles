# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Java env (jenv)
eval "$(jenv init -)"

# Git aliases
alias gl='git pull'
alias gp='git push'
alias gs='git status'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'

# OpenClaw completions
source "$HOME/.openclaw/completions/openclaw.zsh"

# Added by Devin
export PATH="/Users/pratikpugalia/.local/bin:$PATH"
