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
  log $FUNCNAME

  local PACKAGES="git tig tree vim"
  if which apt >/dev/null; then
    sudo apt install -y $PACKAGES
  else
    echo "Unknown package manager. Please install $PACKAGES manually"
  fi
}

setup_vimplug() {
  [ -f ~/.vim/autoload/plug.vim ] && return

  log $FUNCNAME
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim -c ':PlugInstall' -c ':qa'
}

git_config() {
  value=$(git config --global "$1")

  if [ -z "$2" ]; then
    log ${FUNCNAME} $1

    prompt="Enter new value to replace '$value': "
    [ -z "$value" ] && prompt="Enter value for $1: "

    read -p "$prompt" value
    [ -z "$value" ] && return
  else
    [ x"$value" = x"$2" ] && return
    value="$2"

    log $FUNCNAME $1
  fi

  git config --global --add "$1" "$value"
}

setup_gitconfig() {
  git_config user.email
  git_config user.name
  git_config include.path $HOME/bin/gitconfig
}

change_branch() {
  log $FUNCNAME

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
