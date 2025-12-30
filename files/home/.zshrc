# omubuntu ZSH configuration
# Opinionated defaults for a delightful shell experience

# History
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Modern tool aliases (Rust replacements)
alias ls='eza --icons'
alias ll='eza -la --icons --git'
alias la='eza -a --icons'
alias lt='eza --tree --icons'
alias cat='bat --paging=never'
alias grep='rg'
alias find='fd'

# Git aliases
alias g='git'
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline -20'
alias gp='git pull'
alias gc='git commit'
alias gco='git checkout'
alias gb='git branch'

# Tool aliases
alias vim='nvim'
alias v='nvim'
alias lg='lazygit'

# Initialize tools
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

# FZF integration
[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh

# PATH
export PATH="$HOME/.local/bin:$PATH"

# Editor
export EDITOR="nvim"
export VISUAL="nvim"
