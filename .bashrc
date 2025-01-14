# sourcing univeral aliases
source ~/.config/global-rc/.global-aliases
source ~/.config/global-rc/.global-rc


###################
# inits
###################

export STARSHIP_CONFIG=~/.config/starship/starship-bash.toml
export YAZI_CONFIG_HOME=~/.config/yazi # cuz diff on windows

export HISTCONTROL=ignoredups:erasedups # no duplicate entries
export HISTSIZE=1000
export HISTFILESIZE=999

shopt -s histappend # do not overwrite history
shopt -s cmdhist # save multi-line commands in history as single line

eval "$(fzf --bash)" # fzf key bindings/fuzzy completion
eval "$(starship init bash)"


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
# these override any imports/evals from above

# enable vim bindings w/ visual mode indicator. make sure disable $character in starship.toml or use diff config like i do
set -o vi
bind 'set show-mode-in-prompt on'
bind 'set vi-cmd-mode-string \1\e[33;1m\2╰❯ \1\e[0m\2'
bind 'set vi-ins-mode-string \1\e[34;1m\2╰❯ \1\e[0m\2'
# bind 'set vi-cmd-mode-string "[N]"'
# bind 'set vi-ins-mode-string "[I]"'
# bind 'set vi-cmd-mode-string \1\e[33;1m\2└──[CMD] \1\e[0m\2'
# bind 'set vi-ins-mode-string \1\e[34;1m\2└──[INS] \1\e[0m\2'

bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

# bind 'set show-all-if-ambiguous on' # if you prefer list of options
bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'
bind "set completion-ignore-case on" # ignore case in TAB completion


####################
# Credit and Resources
####################

# - Derek Taylor: https://gitlab.com/dwt1/dotfiles/-/blob/master/.bashrc?ref_type=heads
# - Brodie Robertson: https://github.com/BrodieRobertson/dotfiles/blob/master/.zshrc