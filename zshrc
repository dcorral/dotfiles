if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
export GPG_TTY=$TTY

export TERMINAL=alacritty
export EDITOR=vim
export DOTFILES="$HOME/dotfiles/"
export BINFILES="/usr/local/bin/"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    fzf
    zsh-syntax-highlighting
    zsh-autosuggestions
    rust
)

source $ZSH/oh-my-zsh.sh
unsetopt autocd

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

bindkey -v

alias cd='z'
eval "$(zoxide init zsh)"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="$HOME/.local/bin:$PATH"

export BROWSER="/usr/bin/microsoft-edge-stable"

alias prune-docker='docker image prune && docker image prune -a && docker container prune && docker volume prune'
alias f='forge'
alias dc='docker-compose'
alias server='ssh server-online'
alias bc='bitcoin-cli'
alias bd='bitcoind'
alias bt='btc_toggle'
alias ords='ord server --http-port 4040'
alias ordw='ord wallet'
alias ordt='ord_toggle'
alias kill_mouse='killall -9 move_mouse'
alias invalidate='function _invalidate_block() { bitcoin-cli invalidateblock $(bitcoin-cli getblockhash $1); }; _invalidate_block'
alias invalidate_dir='function _invalidate_block_dir() { bitcoin-cli -datadir=. invalidateblock $(bitcoin-cli -datadir=. getblockhash $1); }; _invalidate_block_dir'
alias reconsider_dir='function _invalidate_block_dir() { bitcoin-cli -datadir=. reconsiderblock $(bitcoin-cli -datadir=. getblockhash $1); }; _invalidate_block_dir'



# [[ -z "$TMUX" ]] && exec tmux

autoload -U compinit
compinit -i

export PATH="$HOME/.huff/bin:$PATH"

