-- efm-langserver
-- scoop/apps/nvim/init.lua
local options = {
  encoding = "utf-8",
  fileencoding = "utf-8",
  -- encodings = "utf-8,euc-jp,sjis",
	fileencodings = "utf-8,euc-jp,sjis",
	backup = false,
	hlsearch = true,
	ignorecase = true,
	wrap = false,
	smartindent = true,
	termguicolors = true,
  syntax = 'on',

	expandtab = true,
	tabstop = 2,
	shiftwidth = 2,
	softtabstop = 2,

  cmdheight = 1,
	number = true,
  cursorline = true,

	guifont = "HackGen35 Console NF:h9.5",
  -- "UDEV Gothic 35NFLG:h10",
  -- "MS_Gothic:h10",
  -- "Hack Nerd Font Mono:h9.5",
  splitbelow = true,
  splitright = true,
}

vim.cmd.colorscheme 'habamax'

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.g.mapleader = " "

-- key mapping
function map_keys (ary_km, cmd) 
  -- ary_km (modes='n,g,v,i,t':'n', key, action, opt(silent)=true/false:true)
  local opts = { noremap = true, silent = true }
  local ns_opts = { noremap = true, silent = false }
  cmd = cmd or vim.keymap.set -- vim.api.nvim_set_keymap

  for i=1, #ary_km do
    km = ary_km[i]
    if #km == 2 then
      modes, key, action, opt = 'n', km[1], km[2], opts
    elseif #km == 3 then
      modes, key, action, opt = km[1], km[2], km[3], opts
    else -- #km == 4
      modes, key, action, opt = km[1], km[2], km[3], (km[4] and opts or ns_opts)
    end
    if type(modes) ~= 'table' then
      modes = {modes}
    end
    for i = 1, #modes do
      cmd(modes[i], key, action, opt)
    end
  end
end

local global_keymaps = {
  -- tile ops
  {'<M-h>', '<C-w>h'}, -- km
  {'<M-j>', '<C-w>j'}, -- km
  {'<M-k>', '<C-w>k'}, -- km
  {'<M-l>', '<C-w>l'}, -- km
  {'<tab>', '<C-w>w'}, -- km
  {'<S-tab>', '<C-w>W'}, -- km
  {'<M-S-h>', '<C-w><'}, -- km
  {'<M-S-k>', '<C-w>+'}, -- km
  {'<M-S-j>', '<C-w>-'}, -- km
  {'<M-S-l>', '<C-w>>'}, -- km
  {[[<M-\>]], ':vsplit<return>'}, -- km
  {[[<M-->]], ':split<return>'}, -- km
  {[[<M-S-->]], '<C-w>='}, -- km
  {'<C-[>', '<Esc>'}, -- km
  -- remove highlight
  {'zz', ':nohlsearch<return>'}, -- km
  -- test
  -- {'v', 'y', ':w !clip.exe<return><return>'}, -- km
  {'<leader>fb', ':e#<CR>' }, -- km
  {'<leader>fo', ':tab split<CR>' }, -- km
  {'<leader><leader>', ':BlinkCursor<CR>' }, -- km
}
map_keys(global_keymaps)

-- clipboard
-- if vim.fn.has('wsl') == 1 then
vim.opt.clipboard:append{'unnamedplus'}
vim.g.clipboard = {
  name = 'clip',
  copy = {
    ['+'] = 'win32yank.exe -i --crlf',
    ['*'] = 'win32yank.exe -i --crlf',
  },
  paste = {
    ['+'] = 'win32yank.exe -o --lf',
    ['*'] = 'win32yank.exe -o --lf',
  },
  cache_enable = 0,
}

-- lazy.vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({
  { 'nvim-lualine/lualine.nvim', 
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      require('lualine').setup {
        options = {
          globalstatus = true,
        },
        sections = {
          lualine_a = { {'filename', file_status = true, path = 2 } },
        },
      }
    end
  },
  { 'tpope/vim-scriptease' },
  { 
    'neoclide/coc.nvim',
    branch = 'release',
    config = function()
      m = {
        { 'gd', '<Plug>(coc-definition)' }, -- km
        { 'gt', '<Plug>(coc-type-definition)' }, -- km
        { 'gr', '<plug>(coc-references)' }, -- km
      }
      map_keys(m, vim.keymap.set)
    end
  },
  { 'nvim-neo-tree/neo-tree.nvim', 
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
      vim.api.nvim_create_augroup("neotree", {})
      vim.api.nvim_create_autocmd("BufEnter", {
        group = "neotree",
        command = "set nornu nu",
      })
      vim.api.nvim_create_autocmd("UiEnter", {
        desc = "Open Neotree automatically",
        group = "neotree",
        callback = function()
          if vim.fn.argc() == 0 then
            vim.cmd "set nornu nonu | Neotree toggle"
          end
        end,
      })
    end,
  },
  { 'junegunn/fzf', dir = "~/.fzf", build = "./install --all",
    enabled = function() return jit.os == 'Linux' end
  },
  { 'junegunn/fzf.vim',
    enabled = function() return jit.os == 'Linux' end
  },
  { 'antoinemadec/coc-fzf',
    enabled = function() return jit.os == 'Linux' end
  },
  { 'ktunprasert/gui-font-resize.nvim',
    config = function()
      require('gui-font-resize').setup({
        default_size = 9.5,
        bounds = { maximum = 50, minimum = 4 }
      })
      m = {
        {'<leader>gj', ":GUIFontSizeDown<CR>" }, -- km
        {'<leader>gk', ":GUIFontSizeUp<CR>" }, -- km
        {'<leader>g0', ":GUIFontSizeSet<CR>"}, -- km
      }
      map_keys(m, vim.keymap.set)
    end
  },
  -- { 'nvim-treesitter/nvim-treesitter', { 'do', ':TSUpdate' } },
  -- { 'nvim-treesitter/nvim-treesitter-context' },
  { 'wellle/context.vim' },
  { 'sindrets/diffview.nvim' },
  { 'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
    },
  },
  { 'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter'
    },
    config = function()
      require('telescope').setup()
      local plug = require('telescope.builtin')
      m = {
        {'<Leader>tf', plug.find_files}, -- km
        {'<Leader>tg', plug.live_grep}, -- km
        {'<Leader>tb', plug.buffers}, -- km
        {'<Leader>th', plug.help_tags}, --km
      }
      map_keys(m, vim.keymap.set)
    end
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function() vim.fn['mkdp#util#install']() end,
  },
  { 'lambdalisue/suda.vim' },
  { 'akinsho/toggleterm.nvim', version = "*", opts = {},
    config = function ()
      require('toggleterm').setup()
      m = {
        { '<Leader>do', string.format(":ToggleTerm<CR>") }, --km
        { '<Leader>dt', string.format(":ToggleTerm direction=tab<CR>") }, --km
        { 't', '<C-[>', [[<C-\><C-n>]] }, -- km
      }
      map_keys(m)
    end
  },
  {
    'folke/which-key.nvim', event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    opts = {}
  },
  --[[
  { 'jrop/mongo.nvim' },
  { 'Shougo/deol.nvim',
    config = function ()
      local cmd = 'pwsh'
      if vim.loop.os_uname().sysname == 'Linux' then
        cmd = "bash"
      end
      m = {
        { '<Leader>do', string.format(":call deol#start({'command': '%s', 'split': 'floating'})<CR>", cmd)}, -- km
        -- {'<Leader>, string.format([[:call deol#edit({'command': '%s', 'split': 'floating'})<return>]\], cmd)}, -- km
        { '<Leader>ds', string.format(":call deol#start({'command': '%s', 'split': 'horizontal'})<CR>", cmd) }, -- km
        { 't', '<C-[>', [[<C-\><C-n>]\] }, -- km
        { 't', '<M-d>', [[<C-\><C-n><S-tab>]\] }, -- km
        { 't', '<C-tab>', [[<C-\><C-n><S-tab>]\] }, -- km
      }
      map_keys(m)
    end
  },
  {
    'thibthib18/mongo-nvim',
    config = function()
      require('mongo-nvim').setup({
        -- connection string to your mongodb
        connection_string = "mongodb://127.0.0.1:27017",
        -- key to use for previewing/picking documents
        -- either a string or custom table of string or functions
        list_document_key = "_id",
        -- delete selected document in document_picker
        delete_document_mapping = nil, -- "<c-d>"
      })
      m = {
        {'<Leader>dbl', ':require("mongo-nvim.telescope.pickers").database_picker()<CR>'}, -- km
      }
      map_keys(m, vim.keymap.set)
    end
  },
  { 'sheerun/vim-polyglot' },
  { 'rust-lang/rust.vim' },
  { 'simrat39/rust-tools.nvim',
    dependencies = { 'neovim/nvim-lspconfig',
      '
    },
  },
  { 'mfussenegger/nvim-dap',
    dap.configurations.rust = {
      name = "Rust Debug",
      type = "lldb",
      request = "launch",
      program = function ()
        return vim.fn.input('', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '{workspaceFolder}'
      stopOnEntry = false,
      args = {}
    }
  },
  { 'theniceboy/vim-calc',
    config = function()
      m = {
        {'<Leader>a', string.format([[:call Calc()<CR>]/], cmd)}
      }
      map_keys(m)
    end
  },
  ]]
})

-- User defined commands
function blink_cursor()
  local t = 300
  for i = 1, 3 do
    vim.opt['cursorline'] = false
    vim.api.nvim_command('redraw')
    vim.wait(t)
    vim.opt['cursorline'] = true
    vim.api.nvim_command('redraw')
    vim.wait(t)
  end
end

vim.api.nvim_create_user_command('BlinkCursor', blink_cursor, {})

