call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'vim-scripts/matchit.zip'
call plug#end()

set grepprg=grep\ --exclude=tags\ --exclude-dir=.git\ -n\ $*\ /dev/null

set hls
set et ts=2 sw=2

nmap <F12> :!git 
nmap <F11> yiw:grep <C-R>0 -wrn .
