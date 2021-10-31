if [ -f ~/.zplug/init.zsh ]; then
else
	if [ -d ~/.zplug ]; then
	else
		mkdir ~/.zplug
	fi
	git clone https://github.com/zplug/zplug ~/.zplug
fi

source ~/.zplug/init.zsh

# zplug
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "b4b4r07/enhancd", use:init.sh
zplug "zsh-users/zsh-autosuggestions"

# install plugins
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load

# enhancd
export ENHANCD_FILTER=peco
export ENHANCD_DISABLE_DOT=1
export ENHANCD_DISABLE_HOME=1
