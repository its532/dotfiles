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

function peco-cdr () {
    local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | peco --prompt="cdr >" --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}
zle -N peco-cdr
bindkey '^E' peco-cdr
