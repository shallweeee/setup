set nocompatible
set encoding=utf-8
filetype plugin indent on

" :PlugInstall
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'vim-scripts/matchit.zip'
Plug 'vimwiki/vimwiki', {'branch': 'dev'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'SirVer/ultisnips'
Plug 'prettier/vim-prettier', {'do': 'yarn install --frozen-lockfile --production'}
Plug 'mattn/emmet-vim'
call plug#end()

set ai si
set history=200
set wildmode=longest,list
set splitright
set hls
set vb t_vb=
set grepprg=grep\ --exclude=tags\ --exclude-dir=.git\ -n\ $*\ /dev/null

nmap <F12> :!git 
nmap <F11> yiw:grep <C-R>0 -wrn .
nmap <C-J> :cn<CR>
nmap <C-K> :cp<CR>
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

if has('autocmd')
  au FileType python setlocal makeprg=flake8\ %
  au FileType python setlocal errorformat=%f:%l:%c:\ %m
  au FileType typescriptreact,typescript,javascriptreact,javascript,css,html,json setlocal et ts=2 sw=2
endif

" Vimwiki
source ~/bin/vimrc.vimwiki

" Coc
"let g:coc_start_at_startup = v:false
source ~/bin/vimrc.coc
" :CocInstall coc-pyright coc-tsserver coc-ultisnips
" ~/.config/coc/extensions/package.json

" UltiSnips
source ~/bin/vimrc.ultisnips
