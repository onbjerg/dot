packadd! vim-gotham
packadd! termdebug 


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
set tabstop=2
set shiftwidth=2
set softtabstop=2
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

" Polyglot config
let g:rustfmt_autosave = 1


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
" LSP and nvim-cmp
"
lua <<EOF
  -- Setup gitsigns
  require('gitsigns').setup()

  -- Setup lualine
  require('lualine').setup {
    sections = {
      lualine_b = {
        'branch',
        'diff',
        { 'diagnostics', sources = { 'nvim_lsp' } }
      }
    }
  }

  -- Setup nvim-cmp.
  local lspkind = require'lspkind'
  local cmp = require'cmp'
  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }, {
      { name = 'buffer' },
    }),
    formatting = {
      format = lspkind.cmp_format({with_text = false, maxwidth = 50})
    }
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
      }
    })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  require('lspconfig')['eslint'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['rust_analyzer'].setup {
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = { enable = true }
      }
    }
  }
EOF
