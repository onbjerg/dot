"
" Plugins (vim-plug)
"
call plug#begin('~/.config/nvim/plugged')

Plug 'sheerun/vim-polyglot'
Plug 'ryanoasis/vim-devicons'
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-startify'
Plug 'drewtempelmeyer/palenight.vim'

" Initialize plugin system
call plug#end()

"
" Editing experience
"
set encoding=UTF-8

" Display current cursor position on status line.
set ruler

" Don't wrap.
set nowrap

" Highlight current lie
set cursorline

" Enable hybrid line numbers
set number relativenumber

" File type recognition
filetype on
filetype plugin on
filetype indent on

" Whitespace
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2
set wrap
set backspace=indent,eol,start
set autoindent
set smartindent

"
" Theming
"
set background=dark
colorscheme palenight
let g:lightline = { 'colorscheme': 'palenight' }

if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif

"
" Neovide
"
let g:neovide_refresh_rate=144
