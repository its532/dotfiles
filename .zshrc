# plugin
source ~/.zsh/config/plugin.zsh

fpath=(path/to/zsh-completions/src $fpath)

# alias

# system
alias n="nvim"
alias vim="vim"
alias v=vim
alias vz="vim ~/.zshrc" alias vv="vim ~/.vimrc" alias sz="source ~/.zshrc"
alias bz='bat ~/.zshrc'
alias cat='bat'
alias ls='eza -lh --group-directories-first --icons'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias cd='z'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

# docker
alias d='docker'
alias dc='docker-compose'
alias dimg='docker image'
alias dct='docker container'
alias lzd='lazydocker'

# git
alias gcm='git commit -m'
alias g="git"
alias gs="git status"
alias lzg='lazygit'

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
export EDITOR=nvim
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
function select-git-switch() {
  target_br=$(
    git branch -a |
      fzf --exit-0 --layout=reverse --info=hidden --no-multi --preview-window="right,65%" --prompt="CHECKOUT BRANCH > " --preview="echo {} | tr -d ' *' | xargs git log --graph --decorate --abbrev-commit --color=always" |
      head -n 1 |
      perl -pe "s/\s//g; s/\*//g; s/remotes\/origin\///g"
  )
  if [ -n "$target_br" ]; then
    BUFFER="git switch $target_br"
    zle accept-line
  fi
}
zle -N select-git-switch
bindkey "^b" select-git-switch

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

function gadd() {
    local selected
    local convert_to_eucjp=false

    # Check if -e argument is passed
    if [[ $1 == "-e" ]]; then
        convert_to_eucjp=true
    fi

    if $convert_to_eucjp; then
      selected=$(unbuffer git status -s | fzf -m --ansi --preview="echo {} | awk '{print \$2}' | xargs git diff --color | nkf" | awk '{print $2}')
    else
      selected=$(unbuffer git status -s | fzf -m --ansi --preview="echo {} | awk '{print \$2}' | xargs git diff --color" | awk '{print $2}')
    fi

    if [[ -n "$selected" ]]; then
        # Convert selected files into an array to handle spaces and newlines properly
        IFS=$'\n' selected=(${(f)selected})

        # Trim leading and trailing spaces from each file name
        for i in {1..${#selected[@]}}; do
            selected[i]=$(echo "${selected[i]}" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        done

        # Print selected files for debugging
        echo "Files to be processed: ${selected[@]}"

        # Get a list of staged files
        staged_files=$(git diff --name-only --cached)

        for file in "${selected[@]}"; do
            # Check if the file is already staged
            if echo "$staged_files" | grep -q "^$file$"; then
                # If the file is staged, unstage it
                git reset "$file"
                echo "Unstaged: $file"
            else
                # If the file is not staged, stage it
                git add "$file"
                echo "Staged: $file"
            fi
        done
    fi
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
export PATH="/opt/homebrew/opt/php@7.2/bin:$PATH"


# 外部ファイルから環境変数を読み込む
if [ -f ~/.obsidian.env ]; then
  export $(grep -v '^#' ~/.obsidian.env | xargs)
fi


# pnpm
export PNPM_HOME="/Users/itsuki.kikuyama/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/Users/itsuki.kikuyama/.bun/_bun" ] && source "/Users/itsuki.kikuyama/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# papasshで使用するPATH
export PATH=${PATH}:/Users/itsuki.kikuyama/.local/bin

export CLAUDE_CODE_USE_BEDROCK=1
export ANTHROPIC_MODEL='apac.anthropic.claude-sonnet-4-20250514-v1:0'
export AWS_REGION='ap-northeast-1'
export AWS_PROFILE=oneaws-colorme
