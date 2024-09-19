-- Initialize packer.nvim for managing plugins
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- File Explorer (like VSCode's sidebar)
  use 'kyazdani42/nvim-tree.lua'

  -- LSP Configurations and Autocompletion
  use 'neovim/nvim-lspconfig'         -- LSP configurations
  use 'hrsh7th/nvim-cmp'              -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'          -- LSP source for nvim-cmp
  use 'hrsh7th/cmp-buffer'            -- Buffer completion
  use 'hrsh7th/cmp-path'              -- File path completion

  -- Syntax Highlighting
  use { 'nvim-treesitter/nvim-treesitter'}

  -- Status Line
  use 'nvim-lualine/lualine.nvim'

  -- Git Integration
  use 'lewis6991/gitsigns.nvim'

  -- Fuzzy Finder
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Theme
  use 'folke/tokyonight.nvim'
end)

-- General Neovim Settings
vim.o.number = true                   -- Show line numbers
vim.o.relativenumber = true           -- Show relative line numbers
vim.o.tabstop = 4                     -- 4 spaces for a tab
vim.o.shiftwidth = 4                  -- Indent by 4 spaces
vim.o.expandtab = true                -- Use spaces instead of tabs
vim.o.smartindent = true              -- Auto-indent new lines
vim.o.ignorecase = true               -- Ignore case in search patterns
vim.o.smartcase = true                -- Override ignorecase if search contains uppercase
vim.o.hlsearch = true                 -- Highlight search results
vim.o.incsearch = true                -- Incremental search
vim.o.clipboard = "unnamedplus"       -- Use system clipboard

-- Nvim Tree Setup (File Explorer)
require('nvim-tree').setup {
  view = {
    width = 30,
    side = 'left',
  },
  filters = {
    dotfiles = true,                  -- Hide dotfiles by default
  }
}
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- LSP and Completion Setup
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      -- You can add snippet support here, if needed
    end,
  },
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  }
})

-- LSP configurations for selected languages
local lspconfig = require'lspconfig'

-- Python (pyright)
lspconfig.pyright.setup{}

-- C/C++ (clangd)
lspconfig.clangd.setup{}

-- HTML
lspconfig.html.setup{}

-- CSS
lspconfig.cssls.setup{}

-- JSON
lspconfig.jsonls.setup{}

-- Bash
lspconfig.bashls.setup{}

-- Tree-sitter Setup (Syntax Highlighting)
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "python", "html", "bash", "json", "css" }, -- Install parsers for these languages
  highlight = {
    enable = true,                    -- Enable Tree-sitter highlighting
  }
}

-- Lualine Setup (Status Line)
require('lualine').setup {
  options = {
    theme = 'tokyonight',             -- Use the 'tokyonight' theme for status line
  }
}

-- Git Signs Setup
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
  },
  on_attach = function()
    -- Define GitSigns highlights to avoid the deprecated message
    vim.api.nvim_set_hl(0, 'GitSignsAdd', { link = 'GitGutterAdd' })
    vim.api.nvim_set_hl(0, 'GitSignsChange', { link = 'GitGutterChange' })
    vim.api.nvim_set_hl(0, 'GitSignsDelete', { link = 'GitGutterDelete' })
  end
}


-- Telescope Setup (Fuzzy Finder)
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', { noremap = true })

-- Set Theme
vim.cmd[[colorscheme tokyonight]]

