-- vim.pack plugin manager setup (Neovim 0.12+)
-- All plugins are eagerly loaded for maximum responsiveness
-- Single vim.pack.add() call as recommended by vim.pack design

vim.pack.add({
  -- Foundation plugins (load first)
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/neovim/nvim-lspconfig',

  -- Icons (needed by many UI plugins)
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-mini/mini.icons',

  -- Themes (all available, aura-dark activated below)
  'https://github.com/EdenEast/nightfox.nvim',
  'https://github.com/rebelot/kanagawa.nvim',
  { src = 'https://github.com/rose-pine/neovim', name = 'rose-pine' },
  'https://github.com/oskarnurm/koda.nvim',
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  { src = 'https://github.com/Shatur/neovim-ayu', name = 'ayu' },
  'https://github.com/vague-theme/vague.nvim',
  'https://github.com/baliestri/aura-theme',

  -- Snippets (needed by completion)
  'https://github.com/rafamadriz/friendly-snippets',

  -- Completion
  'https://github.com/saghen/blink.cmp',
  'https://github.com/hrsh7th/nvim-cmp',

  -- Lua development
  'https://github.com/folke/lazydev.nvim',

  -- File management
  'https://github.com/stevearc/oil.nvim',

  -- Fuzzy finder
  'https://github.com/ibhagwan/fzf-lua',

  -- Status line
  'https://github.com/nvim-lualine/lualine.nvim',

  -- UI enhancements
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/rcarriga/nvim-notify',
  'https://github.com/folke/noice.nvim',

  -- Keymap helper
  'https://github.com/folke/which-key.nvim',

  -- Git integration
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/kdheepak/lazygit.nvim',

  -- Editing utilities
  'https://github.com/tpope/vim-surround',

  -- Vim practice game
  'https://github.com/ThePrimeagen/vim-be-good',

  -- LaTeX support
  'https://github.com/lervag/vimtex',

  -- Markdown rendering
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
})

-- Configure aura-theme (requires special rtp path)
local aura_path = vim.fn.stdpath('data') .. '/site/pack/core/opt/aura-theme/packages/neovim'
if vim.fn.isdirectory(aura_path) == 1 then
  vim.opt.rtp:append(aura_path)
  vim.cmd('colorscheme aura-dark')
end

-- Tree-sitter languages
require('nvim-treesitter').install {
  'rust', 'javascript', 'zig', 'python', 'java', 'c', 'cpp', 'bash', 'zsh',
  'markdown', 'yaml', 'latex', 'go', 'lua', 'typescript', 'tsx'
}

-- Mini.nvim suite
require('mini.pairs').setup()
require('mini.ai').setup()
require('mini.hipatterns').setup()
require('mini.cursorword').setup()
require('mini.git').setup()
require('mini.diff').setup()
require('mini.snippets').setup()
require('mini.completion').setup()
require('mini.indentscope').setup()

-- Auto-build blink.cmp if needed (only if directory exists and lib not built)
local blink_path = vim.fn.stdpath('data') .. '/site/pack/core/opt/blink.cmp'
local blink_lib = blink_path .. '/target/release/libblink_cmp_fuzzy.dylib'
if vim.fn.isdirectory(blink_path) == 1 and vim.fn.filereadable(blink_lib) ~= 1 then
  vim.notify('Building blink.cmp (one-time)...', vim.log.levels.INFO)
  vim.fn.jobstart({'cargo', 'build', '--release'}, {
    cwd = blink_path,
    on_exit = function(_, code)
      if code == 0 then
        vim.notify('blink.cmp build complete!', vim.log.levels.INFO)
      else
        vim.notify('blink.cmp build failed!', vim.log.levels.ERROR)
      end
    end,
  })
end

require('blink.cmp').setup({
  keymap = { preset = 'default' },
  appearance = {
    nerd_font_variant = 'mono'
  },
  completion = { documentation = { auto_show = false } },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  fuzzy = { implementation = 'prefer_rust_with_warning' }
})

-- Lua development
require('lazydev').setup({
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
})

-- nvim-cmp source for lazydev
local cmp = require('cmp')
local cmp_sources = cmp.get_config().sources or {}
table.insert(cmp_sources, {
  name = 'lazydev',
  group_index = 0,
})
cmp.setup({ sources = cmp_sources })

-- Status line
require('lualine').setup({})

-- UI enhancements
require('noice').setup({
  lsp = {
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = false,
  },
})

-- Keymap helper
require('which-key').setup({})
vim.keymap.set('n', '<leader>?', function()
  require('which-key').show({ global = false })
end, { desc = 'Buffer Local Keymaps (which-key)' })

-- LaTeX
vim.g.vimtex_view_method = 'zathura'

-- Markdown
require('render-markdown').setup({})
