# ::シンボリックリンク::
DOT_DIR="$HOME/dotfiles"

# clone
# git clone git@github.com:fkubota/dotfiles.git ${DOT_DIR}
git clone https://github.com/its532/dotfiles.git ${DOT_DIR}

ln -sf ${DOT_DIR}/zsh/config/plugin.zsh ~/.config/zsh/config/plugin.zsh
ln -sf ${DOT_DIR}/zsh/config/search.zsh ~/.config/zsh/config/search.zsh
ln -sf ${DOT_DIR}/zsh/git/_git ~/.config/zsh/git/_git
ln -sf ${DOT_DIR}/zsh/git/git-completion.bash ~/.config/zsh/git/git-completion.bash
ln -sf ${DOT_DIR}/zsh/git/git-prompt.sh ~/.config/zsh/git/git-prompt.sh

ln -sf ${DOT_DIR}/.zshrc ~/.zshrc
