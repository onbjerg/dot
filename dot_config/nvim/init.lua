require 'paq' {
  -- Let Paq manage itself
  'savq/paq-nvim';

  -- Core
  'nvim-treesitter/nvim-treesitter';

  -- UI
  {'ibhagwan/fzf-lua', run = './install --bin'};
  'lewis6991/gitsigns.nvim';
  'nvim-lualine/lualine.nvim';
  'noib3/nvim-cokeline';
  'kyazdani42/nvim-web-devicons';
  'SmiteshP/nvim-gps';

  -- LSP
  'neovim/nvim-lspconfig';
  'onsails/lspkind-nvim';

  -- Languages
  'sheerun/vim-polyglot';

  -- Autocomplete
  'hrsh7th/nvim-cmp';
  'hrsh7th/cmp-buffer';
  'hrsh7th/cmp-cmdline';
  'hrsh7th/cmp-nvim-lsp';
  'hrsh7th/cmp-path';
  'saadparwaiz1/cmp_luasnip';
  'L3MON4D3/LuaSnip';

  -- Themes
  'Shatur/neovim-ayu';

  -- Misc
  'svermeulen/vimpeccable';
  'nvim-lua/plenary.nvim';
}

vim.o.encoding = 'UTF-8'

-- Display current position on status line
vim.o.ruler = true

-- Don't wrap lines
vim.o.wrap = false

-- Highlight current line
vim.o.cursorline = true

-- Configure search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true

-- Use relative line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Set leader to ,
vim.g.mapleader = ' '

-- File type recognition
vim.cmd([[
  filetype on
  filetype plugin on
  filetype indent on
]])

-- Indentation
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.opt.backspace = {'indent', 'eol', 'start'}
vim.o.autoindent = true
vim.o.smartindent = true

-- Show whitespace
vim.o.list = true
vim.o.showbreak = '↪'
vim.opt.listchars = {
  tab = '→ ',
  eol = '↲',
  nbsp = '␣',
  trail = '•',
  extends = '⟩',
  precedes = '⟨'
}

-- Theming
vim.o.termguicolors = true

vim.cmd([[
  syntax enable
  colorscheme ayu-dark
]])

-- FZF
local vimp = require('vimp')

require('fzf-lua').setup {
  files = {
    cmd = 'ag --hidden --ignore .git -g ""'
  },
  winopts = {
    preview = {
      default = 'bat',
    },
  },
  previewers = {
    git_diff = {
      pager = 'delta',
    }
  },
}

vimp.nnoremap('<C-p>', function()
  -- Ctrl + P for files
  require('fzf-lua').files()
end)

vimp.nnoremap('<C-f>', function()
  -- Ctrl + F to search current file
  require('fzf-lua').grep()
end)

vimp.nnoremap('<leader>f', function()
  -- Leader + F to search entire project
  require('fzf-lua').grep_project()
end)

-- Terminal
vimp.nnoremap('<leader>t', ':terminal<CR>')
vimp.tnoremap('<esc>', '<C-\\><C-n>')
vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'

-- Buffers
vimp.nnoremap('<leader>,', ':bp<cr>')
vimp.nnoremap('<leader>.', ':bn<cr>')
vimp.nnoremap('<leader>c', ':bd<cr>')

-- Buffer line
require('cokeline').setup()

-- Add gitsigns
require('gitsigns').setup()

-- Status line
vim.o.showmode = false

local gps = require('nvim-gps')
gps.setup()

require('lualine').setup {
  options = {
    theme = 'ayu_dark'
  },
  sections = {
    lualine_b = {
      'branch',
      'diff',
      { 'diagnostics', sources = { 'nvim_lsp' } },
    },
    lualine_c = {
      'filename',
      { gps.get_location, cond = gps.is_available },
    },
    lualine_y = {},
  }
}

-- Autocomplete
local lspkind = require'lspkind'
local cmp = require'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable,
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
}

cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Configure LSP
local lspconfig = require('lspconfig')
local caps = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)
lspconfig['eslint'].setup {
  capabilities = caps
}
lspconfig['rust_analyzer'].setup {
  capabilities = caps,
  settings = {
    ["rust-analyzer"] = {
      procMacro = {
        enable = true
      },
      rustfmt = {
        extraArgs = {"+nightly"}
      }
    }
  }
}
lspconfig['solc'].setup {}

-- Format on save
vim.cmd([[
  autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 1000)
]])
