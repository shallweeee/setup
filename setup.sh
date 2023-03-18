#! /bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

BASHRC_LOADER='source ~/bin/bashrc'
INPUTRC_LOADER='$include ~/bin/inputrc'
TMUXCONF_LOADER='source ~/bin/tmux.conf'
VIMRC_LOADER='source ~/bin/vimrc'
SUDO=

log() {
  echo -e "\n* $*"
}

check_sudo() {
  [ $(id -u) -eq 0 ] && SUDO= || SUDO=sudo
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

  local PACKAGES="curl git tig tree vim xclip"
  if which apt >/dev/null; then
    #$SUDO apt update
    $SUDO apt install -y $PACKAGES
  else
    echo "Unknown package manager. Please install $PACKAGES manually"
  fi
}

setup_alternatives() {
  which update-alternatives >/dev/null || return

  local items=('editor /usr/bin/vim.basic')
  for tmp in "${items[@]}"; do
    local item=($tmp)
    [ -f ${item[1]} ] && $SUDO update-alternatives --set ${item[0]} ${item[1]}
  done
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
  git_config include.path '~/bin/gitconfig'
  git_config core.excludesfile '~/bin/gitignore_global'
}

change_branch() {
  log $FUNCNAME

  pushd $SCRIPT_DIR
  git checkout -b "$(uname -n)"
  popd
}

link_wincmds() {
  uname -r | grep -q microsoft-standard || return
  log $FUNCNAME

  $SCRIPT_DIR/win
}

setup_completion() {
  mkdir -p ~/.bash_completion.d
  grep -q .bash_completion.d ~/.bash_completion 2> /dev/null || echo 'for bc in ~/.bash_completion.d/*; do . $bc; done' >> ~/.bash_completion

  pushd ~/.bash_completion.d
  curl -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/bash/docker -o docker
  sed -i '/complete -F/s/\<docker.exe\>/doc/' docker
  curl -L https://raw.githubusercontent.com/docker/compose/master/contrib/completion/bash/docker-compose -o docker-compose
  sed -i '/complete -F/s/\<docker-compose.exe\>/dc/' docker-compose
  curl -L https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o git
  sed -i '/___git_complete git __git_main/a ___git_complete gitall __git_main' git
  popd
}

check_sudo
setup_packages
setup_alternatives
setup .bashrc "$BASHRC_LOADER"
setup .inputrc "$INPUTRC_LOADER"
setup .tmux.conf "$TMUXCONF_LOADER"
setup .vimrc "$VIMRC_LOADER" '"'
setup_vimplug
setup_gitconfig
#change_branch
link_wincmds
setup_completion
