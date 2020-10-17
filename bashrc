alias ls='ls --color=auto'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

alias doc='docker'
alias dc='docker-compose'

alias vi='vim'
alias vic='vim -u NONE -N'

[ -z "$TMUX" ] || PATH="$(echo $PATH | sed 's;^'$HOME'/.local/bin:'$HOME'/bin:;;')"
