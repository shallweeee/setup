#! /bin/bash

BASH_LOADER='
[ -f ~/bin/bashrc ] && . ~/bin/bashrc'

VIM_LOADER='
if filereadable(expand("~/bin/vimrc"))
  so ~/bin/vimrc
endif'

log() {
  echo -e "\n* $*"
}

setup_packages() {
  log ${FUNCNAME[0]}

  local PACKAGES="git vim"
  if which apt >/dev/null; then
    sudo apt install -y $PACKAGES
  else
    echo "Unknown package manager. Please install $PACKAGES manually"
  fi
}

setup_bashrc() {
  grep -q '~/bin/bashrc' ~/.bashrc 2>/dev/null && return

  log "${FUNCNAME[0]}"
  echo "$BASH_LOADER" >> ~/.bashrc
}

setup_vimrc() {
  grep -q '~/bin/vimrc' ~/.vimrc 2>/dev/null && return

  log "${FUNCNAME[0]}"
  echo "$VIM_LOADER" >> ~/.vimrc
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
setup_bashrc
setup_vimrc
setup_vimplug
setup_gitconfig
change_branch
