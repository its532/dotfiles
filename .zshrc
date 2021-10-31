# plugin
source ~/.zsh/config/plugin.zsh

fpath=(path/to/zsh-completions/src $fpath)

# git-promptの読み込み
source ~/.zsh/git/git-prompt.sh

# git-completionの読み込み
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git/git-completion.bash
autoload -Uz compinit && compinit

# プロンプトのオプション表示設定
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto

# プロンプトの表示設定(好きなようにカスタマイズ可)
setopt PROMPT_SUBST ; PS1='%F{green}%n@%m%f: %F{cyan}%~%f %F{red}$(__git_ps1 "(%s)")%f
\$ '

# history
export HISTFILE=~/.zsh-history
export HISTSIZE=100000
export SAVEHIST=1000000

# share .zshhistory
setopt inc_append_history
setopt share_history

# peco
source ~/.zsh/config/search.zsh
