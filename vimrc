call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
call plug#end()

set grepprg=grep\ --exclude=tags\ --exclude-dir=.git\ -n\ $*\ /dev/null

nmap <F12> :!git 
nmap <F11> yiw:grep <C-R>0 -wrn .
