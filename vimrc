" minimal setting
set nocompatible
filetype plugin on

" plugin manager
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'vim-scripts/matchit.zip'
Plug 'davidhalter/jedi-vim'
Plug 'mattn/emmet-vim'
call plug#end()

set grepprg=grep\ --exclude=tags\ --exclude-dir=.git\ -n\ $*\ /dev/null

set hls
set vb t_vb=
set et ts=2 sw=2

nmap <F12> :!git 
nmap <F11> yiw:grep <C-R>0 -wrn .
nmap <C-J> :cn<CR>
nmap <C-K> :cp<CR>

" emmet
let g:user_emmet_expandabbr_key='<Tab>'
imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

if has('autocmd')
  au FileType python setlocal makeprg=flake8\ %
  au FileType python setlocal errorformat=%f:%l:%c:\ %m
endif
