# plugin
source ~/.zsh/config/plugin.zsh
i
fpath=(path/to/zsh-completions/src $fpath)

# alias

# system
alias vim="nvim"
alias v=vim
alias vz="vim ~/.zshrc"
alias vv="vim ~/.vimrc"
alias sz="source ~/.zshrc"
alias bz='bat ~/.zshrc'
alias cat='bat'
alias l='exa'
alias ls=l
alias ll='exa -l'

# docker
alias d='docker'
alias dc='docker-compose'
alias dimg='docker image'
alias dct='docker container'

# git
alias gcm='git commit -m'
alias g="git"

# history
export HISTFILE=~/.zsh-history
export HISTSIZE=100000
export SAVEHIST=1000000

# share .zshhistory
setopt inc_append_history
setopt share_history

[[ -d ~/.rbenv  ]] && \
  export PATH=${HOME}/.rbenv/bin:${PATH} && \
  eval "$(rbenv init -)"

# ここから追加
export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin
export EDITOR=/usr/local/bin/nvim
export PATH=$HOME/.nodebrew/current/bin:$PATH

export PYENV_ROOT="$HOME/.pyenv" 
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


# peco
source ~/.zsh/config/search.zsh

# autojump
[[ -s /Users/itsuki.kikuyama/.autojump/etc/profile.d/autojump.sh ]] && source /Users/itsuki.kikuyama/.autojump/etc/profile.d/autojump.sh

autoload -U compinit && compinit -u

export FZF_DEFAULT_OPTS='--height 70% --layout=reverse --border'

# fgb - checkout git branch
fgb() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# flog - git commit browser
flog() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(#C0C0C0)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
              (grep -o '[a-f0-9]\{7\}' | head -1 |
              xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
              {}
              FZF-EOF
             "
}

fadd() {
  local out q n addfiles
  while out=$(
      git status --short |
      awk '{if (substr($0,2,1) !~ / /) print $2}' |
      fzf-tmux --multi --exit-0 --expect=ctrl-d); do
    q=$(head -1 <<< "$out")
    n=$[$(wc -l <<< "$out") - 1]
    addfiles=(`echo $(tail "-$n" <<< "$out")`)
    [[ -z "$addfiles" ]] && continue
    if [ "$q" = ctrl-d ]; then
      git diff --color=always $addfiles | less -R
    else
      git add $addfiles
    fi
  done
}

# fvim: ファイル名検索+Vimで開くファイルをカレントディレクトリからfzfで検索可能に
fvim() {
  local file
  file=$(
         rg --files --hidden --follow --glob "!**/.git/*" | fzf \
            --preview 'bat  --color=always --style=header,grid --line-range :100 {}' --preview-window=right:60%
     )
  nvim "$file"
}
alias fv="fvim"

# fzfでdockerコンテナに入る
fdce() {
  local cid
  cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')
  [ -n "$cid" ] && docker exec -it "$cid" /bin/bash
}

eval "$(oh-my-posh init zsh --config ~/its.omp.json)"
eval "$(zoxide init zsh)"
  
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
setopt no_beep

export PATH="$HOME/.composer/vendor/bin:$PATH"
