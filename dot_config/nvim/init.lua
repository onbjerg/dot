-- Telescope?
--  - symbols
--  - command palette
-- Better LSP bindings?
--  - peek definition
--  - autocomplete
--  - code actions
-- check out:
-- https://github.com/phaazon/hop.nvim
-- https://github.com/weilbith/nvim-code-action-menu
-- todo: replace this with lazy.nvim
-- todo: split into multiple files
require 'paq' {
  -- Let Paq manage itself
  'savq/paq-nvim';

  -- Core
  'nvim-treesitter/nvim-treesitter';
  'stevearc/oil.nvim';
  'numtostr/FTerm.nvim';

  -- UI
  'nvim-telescope/telescope.nvim';
  {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'};
  'lewis6991/gitsigns.nvim';
  'nvim-lualine/lualine.nvim';
  'nvim-lua/lsp-status.nvim';
  'willothy/nvim-cokeline';
  'kyazdani42/nvim-web-devicons';
  'SmiteshP/nvim-navic';
  'rcarriga/nvim-notify';

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
  'saecki/crates.nvim';
  {'iamcco/markdown-preview.nvim', run = function() vim.fn["mkdp#util#install"]() end};
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

-- File manager
require('oil').setup()

-- Floating terminal
require 'FTerm'.setup({
    border = 'double',
    dimensions = {
      width = 0.9,
      height = 0.9,
    },
})

-- Telescope
require('telescope').setup {
  defaults = {
    vimgrep_arguments = {
      "ag",
      "--nocolor",
      "--no-heading",
      "--filename",
      "--numbers",
      "--column",
      "--smart-case",
    },
    file_previewer = require('telescope.previewers').cat.new,
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    }
  }
}
require('telescope').load_extension('fzf')

local vimp = require('vimp')
local builtin = require('telescope.builtin')

-- Ctrl + P for files
vimp.nnoremap('<C-p>', builtin.find_files)

-- Leader + P for commands
vimp.nnoremap('<leader>p', builtin.commands)

-- Leader + F to search entire project
vimp.nnoremap('<leader>f', builtin.live_grep)

-- Leader + R for workspace symbols
vimp.nnoremap('<leader>r', builtin.lsp_workspace_symbols)

-- Terminal
vimp.nnoremap('<leader>t', '<CMD>lua require("FTerm").toggle()<CR>')
vimp.tnoremap('<leader>t', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'

-- Buffers
vimp.nnoremap('<leader>,', ':bp<cr>')
vimp.nnoremap('<leader>.', ':bn<cr>')
vimp.nnoremap('<leader>c', ':bd!<cr>')

-- Buffer line
require('cokeline').setup()

-- Add gitsigns
require('gitsigns').setup()

-- Status line
vim.o.showmode = false

local navic = require('nvim-navic')
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
      { navic.get_location, cond = navic.is_available },
    },
    lualine_d = {
      "require'lsp-status'.status()",
    },
    lualine_y = {},
  }
}

-- Autocomplete
local crates = require('crates').setup()
local lspkind = require'lspkind'
local cmp = require'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'crates' },
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
local caps = require('cmp_nvim_lsp').default_capabilities()

local lsp_status = require('lsp-status')
lsp_status.register_progress()

lspconfig['eslint'].setup {
  capabilities = caps
}
lspconfig['rust_analyzer'].setup {
  capabilities = caps,
  on_attach = function(client, bufnr)
    navic.attach(client, bufnr)
    lsp_status.on_attach(client, bufnr)
  end,
  settings = {
    ["rust-analyzer"] = {
      procMacro = {
        enable = true
      },
      rustfmt = {
        extraArgs = {"+nightly"}
      },
      checkOnSave = {
        command = "clippy",
        extraArgs = {"+nightly"}
      }
    }
  }
}

-- Notifications
local notify = require('notify')
vim.notify = notify

vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client)
  local lvl = ({
      'ERROR',
      'WARN',
      'INFO',
      'DEBUG',
  })[result.type]
  notify({ result.message }, lvl, {
      title = 'LSP | ' .. client.name,
      timeout = 10000,
      keep = function ()
        return lvl == 'ERROR' or lvl == 'WARN'
      end,
  })
end

-- Format on save
vim.cmd([[
  autocmd BufWritePre *.rs lua vim.lsp.buf.format()
]])
