" minimal setting
set nocompatible
filetype plugin on

" plugin manager
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'vim-scripts/matchit.zip'
call plug#end()

set grepprg=grep\ --exclude=tags\ --exclude-dir=.git\ -n\ $*\ /dev/null

set hls
set vb t_vb=
set et ts=2 sw=2

nmap <F12> :!git 
nmap <F11> yiw:grep <C-R>0 -wrn .
nmap <C-J> :cn<CR>
nmap <C-K> :cp<CR>

if has('autocmd')
  autocmd FileType python setlocal makeprg=flake8\ %
  autocmd FileType python setlocal errorformat=%f:%l:%c:\ %m
endif
