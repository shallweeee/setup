#! /bin/bash

BASHRC_LOADER='source ~/bin/bashrc'
INPUTRC_LOADER='$include ~/bin/inputrc'
TMUXCONF_LOADER='source ~/bin/tmux.conf'
VIMRC_LOADER='source ~/bin/vimrc'

log() {
  echo -e "\n* $*"
}

setup() {
  local CONFIG="$HOME/$1"
  local LOADER="$2"
  local COMMENT="$3"
  [ -z "$COMMENT" ] && COMMENT='#'

  [ -f "$CONFIG" ] && sed 's/'"$COMMENT"'.*//' "$CONFIG" | grep -q "$LOADER" && return

  log "$1"
  [ -f "$CONFIG" ] && echo >> "$CONFIG"
  echo "$LOADER" >> "$CONFIG"
}

setup_packages() {
  log ${FUNCNAME[0]}

  local PACKAGES="git tig tree vim"
  if which apt >/dev/null; then
    sudo apt install -y $PACKAGES
  else
    echo "Unknown package manager. Please install $PACKAGES manually"
  fi
}

setup_vimplug() {
  [ -f ~/.vim/autoload/plug.vim ] && return

  log "${FUNCNAME[0]}"
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim -c ':PlugInstall' -c ':qa'
}

set_git_config() {
  local tmp=`git config --global $1`
  if [ ! -z "$tmp" ]; then
    echo "  $1 already has '$tmp'"
    return
  fi

  local value="$2"
  if [ -z "$value" -o "${value:0:5}" = Enter ]; then
    read -p "Enter ${1#*.} for git(Enter to skip): " value
  fi

  if [ -z "$value" ]; then
    echo "  skipped"
  else
    git config --global $1 "$value"
  fi
}

setup_gitconfig() {
  log "${FUNCNAME[0]}"

  set_git_config alias.br branch
  set_git_config alias.ci commit
  set_git_config alias.co checkout
  set_git_config alias.st status

  set_git_config user.email "Enter your email for git(Enter to skip): "
  set_git_config user.name "Enter your name for git(Enter to skip): "
}

change_branch() {
  log "${FUNCNAME[0]}"

  cd "$(dirname $0)"
  git checkout -b "$(uname -n)"
}

setup_packages
setup .bashrc "$BASHRC_LOADER"
setup .inputrc "$INPUTRC_LOADER"
setup .tmux.conf "$TMUXCONF_LOADER"
setup .vimrc "$VIMRC_LOADER" '"'
setup_vimplug
setup_gitconfig
change_branch
