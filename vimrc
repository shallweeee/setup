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
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
call plug#end()

set ai si
set history=200
set wildmode=longest,list
set splitright
set hls
set vb t_vb=
set grepprg=grep\ --exclude=tags\ --exclude-dir='.[!.]*'\ --exclude-dir=__pycache__\ -n\ $*\ /dev/null
set ruler

" 커서 아래의 설정 이름을 값으로 치환
nnoremap <leader>e :let @a = &<C-R>=expand('<cword>')<CR><CR>:exe "norm! ciw" . @a<CR>

nmap <F2> :!mkdir -p %:h<CR><CR>
nmap <F12> :!git 
nmap <F11> yiw:grep <C-R>0 -wrn .
nmap <C-J> :cn<CR>
nmap <C-K> :cp<CR>
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

if has('autocmd')
  au BufReadPre * if expand('%:p:h') =~# '/site-packages/' | setlocal readonly | endif
  au FileType python setlocal makeprg=flake8\ %
  au FileType python setlocal errorformat=%f:%l:%c:\ %m
  au FileType typescriptreact,typescript,javascriptreact,javascript,css,html,json setlocal et ts=2 sw=2
  au FileType java setl sw=2 ts=2 et sts=2 tw=100
  au FileType markdown nmap <F5> <Plug>MarkdownPreviewToggle
endif

" Vimwiki
source ~/bin/vimrc.vimwiki

" Coc
"let g:coc_start_at_startup = v:false
source ~/bin/vimrc.coc
" :CocInstall coc-pyright coc-tsserver coc-ultisnips
" ~/.config/coc/extensions/package.json
" ~/.vim/coc-settings.json

" UltiSnips
source ~/bin/vimrc.ultisnips
