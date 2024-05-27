# export paths
export ZSH="$HOME/.oh-my-zsh"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin:$HOME/.cargo/env"

ZSH_THEME=""

plugins=(git tmux zsh-autosuggestions zsh-syntax-highlighting) 

ZSH_TMUX_AUTOSTART=true

source $ZSH/oh-my-zsh.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun completions
[ -s "/Users/sverdejot/.bun/_bun" ] && source "/Users/sverdejot/.bun/_bun"
eval "$(starship init zsh)"

eval "$(atuin init zsh)"
