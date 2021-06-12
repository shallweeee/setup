alias grep='grep --color=auto'
alias ls='ls --color=auto'

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

alias gerrit_push='git push origin HEAD:refs/for/`git branch --show-current`'

alias pip='pip --trusted-host pypi.org --trusted-host files.pythonhosted.org'

alias vi='vim'
alias vifr='vim -u NONE -N' # factory reset

alias doc='docker'
alias dc='docker-compose'
alias dcl='docker-compose logs'
dce() {
  srv=$1
  shift
  [ $# -gt 0 ] && cmd="$@" || cmd=bash
  dc exec $srv $cmd
}
#export -f dce

[ -z "$TMUX" ] || PATH="$(echo $PATH | sed 's;^'$HOME'/.local/bin:'$HOME'/bin:;;')"
