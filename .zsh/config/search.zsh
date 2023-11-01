# Ctrl + R = history search
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^F' peco-history-selection

# Ctrl + F = find and vim
function peco-vim() {
    local src=$(git ls-files | peco --query "$LBUFFER" --prompt "vim>")
    if [ -n "$src" ]; then
        BUFFER="vim $src"
        zle accept-line
    fi
    zle -R -c
}
zle -N peco-vim
bindkey '^R' peco-vim

# ここから追加
function peco-src () {
    local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-src
bindkey '^G' peco-src
