packadd! vim-gotham
packadd! termdebug 

lua require('gitsigns').setup()

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
set list
set showbreak=↪
set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨

"
" Theming
"
syntax enable
colorscheme gotham

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
" Lightline configuration
"
set noshowmode
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'cocstatus': 'coc#status'
      \ },
      \ 'colorscheme': 'gotham',
      \ }

function! LightlineFilename()
	return expand('%:t') !=# '' ? @% : '- NO NAME -'
endfunction

" Polyglot config
let g:rustfmt_autosave = 1

" Use autocmd to force lightline update on COC changes
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

"
" FZF
"
" Use silver searcher and ignore VCS files
let $FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
" Spawn FZF in new window
let g:fzf_layout = { 'window': 'enew' }
" Bind fzf to ctrl+p
nnoremap <C-P> :Files<CR>

"
" LSP
"
lua << EOF
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.eslint.setup{}
EOF
