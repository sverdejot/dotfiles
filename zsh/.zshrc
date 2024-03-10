# export paths
export ZSH="$HOME/.oh-my-zsh"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# typewritten (prompt) config
ZSH_THEME="spaceship"
#fpath+=$HOME/.zsh/typewritten

#export TYPEWRITTEN_COLOR_MAPPINGS="primary:blue"
#export TYPEWRITTEN_PROMPT_LAYOUT="singleline"
#export TYPEWRITTEN_COLORS="arrow:yellow;symbol:yellow"
#export TYPEWRITTEN_LEFT_PROMPT_PREFIX_FUNCTION=(whoami)
#export TYPEWRITTEN_ARROW_SYMBOL="->"

#autoload -U promptinit; promptinit
#prompt typewritten

# plugins config
plugins=(git tmux zsh-autosuggestions zsh-syntax-highlighting) 

ZSH_TMUX_AUTOSTART=true

source $ZSH/oh-my-zsh.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun completions
[ -s "/Users/sverdejot/.bun/_bun" ] && source "/Users/sverdejot/.bun/_bun"
