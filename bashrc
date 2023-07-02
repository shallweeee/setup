alias explorer=nautilus

alias grep='grep --color=auto'
alias ls='ls --color=auto'

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

alias gerrit_push='git push origin HEAD:refs/for/`git branch --show-current`'

alias pip='pip --trusted-host pypi.org --trusted-host files.pythonhosted.org'
alias act='conda activate'
alias deact='conda deactivate'

alias vi='vim'
alias vifr='vim -u NONE -N' # factory reset

alias doc='docker'
alias dcl='docker-compose logs'
dce() {
  srv=$1
  shift
  [ $# -gt 0 ] && cmd="$@" || cmd=bash
  dc exec $srv $cmd
}

shopt -s direxpand

# command | c, c < file
alias c='xclip -selection clipboard'
alias v='xclip -selection clipboard -o'

alias urlenc='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'
alias urldec='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'

#[ -z "$TMUX" ] || PATH="$(echo $PATH | sed 's;^'$HOME'/.local/bin:'$HOME'/bin:;;')"
export PATH="~/.local/usr/bin:$PATH"

[ -s ~/.cargo/env ] && . ~/.cargo/env
