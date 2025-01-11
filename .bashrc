# sourcing univeral aliases
source ~/.config/global-rc/.global-aliases
source ~/.config/global-rc/.global-rc


###################
# inits
###################

export HISTCONTROL=ignoredups:erasedups # no duplicate entries
export HISTSIZE=1000
export HISTFILESIZE=999
shopt -s histappend # do not overwrite history

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"


###################
# aliases
###################

# dotfiles and stuff
alias restrap="choco export -o='$DOTFILES/bootstrap/windows/packages.config'"

# match zsh functions alias
alias functions='declare -F'


####################
# binds
####################

# set above other keybindings to prevent overwriting
# testing vim bindings
set -o vi

# bind 'set show-all-if-ambiguous on' # if you prefer list of options
bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'
#ignore upper and lowercase when TAB completion
bind "set completion-ignore-case on"

bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'


####################
# Credit and Resources
####################

# - Derek Taylor: https://gitlab.com/dwt1/dotfiles/-/blob/master/.bashrc?ref_type=heads
# - Brodie Robertson: https://github.com/BrodieRobertson/dotfiles/blob/master/.zshrc