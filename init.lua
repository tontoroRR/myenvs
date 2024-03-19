-- efm-langserver

local options = {
	encoding = "utf-8",
	fileencoding = "utf-8",
	-- encodings = "utf-8,euc-jp,sjis",
	fileencodings = "utf-8,euc-jp,sjis",
	backup = false,
	hlsearch = true,
	ignorecase = true,
	wrap = false,
  swapfile = false,
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

	guifont = "Maple Mono NF:h9.5",
	-- guifont = "HackGen35 Console NF:h9.5",
	-- "UDEV Gothic 35NFLG:h10",
	-- "MS_Gothic:h10",
	-- "Hack Nerd Font Mono:h9.5",
	splitbelow = true,
	splitright = true,
}


-- set colorscheme
vim.cmd.colorscheme 'habamax'
vim.cmd([[highlight Search guifg=#c0856b guibg=#661d05]]) -- fg=chocolate_cream, bg=chocolate_rose

-- set win seperator
vim.opt.fillchars.eob = "\\ "
vim.cmd([[highlight winseparator guifg=fg guibg=bg]])

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.g.mapleader = ";"

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
	{[[<M-\>]], ':vsplit<CR>'}, -- km
	{[[<M-->]], ':split<CR>'}, -- km
	{[[<M-S-->]], '<C-w>='}, -- km
	{'<C-[>', '<Esc>'}, -- km
	-- tab ops
	{'<M-d>', ':tabnext<CR>'}, --km
	-- remove highlight
	{'zz', ':nohlsearch<CR>'}, -- km
	-- test
	-- {'v', 'y', ':w !clip.exe<return><return>'}, -- km
	{'<leader><Space>', ':e#<CR>' }, -- km
	{'<leader>fo', ':tab split<CR>' }, -- km
	{'<leader><leader>', ':BlinkCursor<CR>' }, -- km
}
map_keys(global_keymaps)

-- clipboard
-- if vim.fn.has('wsl') == 1 then
-- vim.opt.clipboard:append{'unnamedplus'} -- deferred-clipboardで設定するからここでは不要
--[[
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
]]

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
	{
    'nvim-lualine/lualine.nvim', 
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
  {
    'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {},
    event = 'VeryLazy', -- lz
  },
  {
    'tpope/vim-scriptease', 'neoclide/coc.nvim',
  },
  { 
    'neoclide/coc.nvim',
    event = 'VeryLazy', -- lz
    branch = 'release',
    config = function()
      m = {
        { 'gd', '<Plug>(coc-definition)<Esc>z.' }, -- km
        { 'gt', '<Plug>(coc-type-definition)<Esc>z.' }, -- km
        { 'gr', '<plug>(coc-references)' }, -- km
      }
      map_keys(m, vim.keymap.set)
    end
  },
  {
    'nvim-neo-tree/neo-tree.nvim', 
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
  {
    'junegunn/fzf', dir = "~/.fzf", build = "./install --all",
    event = 'VeryLazy', -- lz
    enabled = function() return jit.os == 'Linux' end
  },
  {
    'antoinemadec/coc-fzf',
    event = 'VeryLazy', -- lz
    enabled = function() return jit.os == 'Linux' end
  },
  {
    'ktunprasert/gui-font-resize.nvim',
    event = 'VeryLazy', -- lz
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
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-context' },
    build = ':TSUpdate',
    config = function()
      if vim.loop.os_uname().sysname == 'Linux' then
        local configs = require('nvim-treesitter.configs')
        configs.setup({
          ensure_installed = { 'lua', 'python', 'yaml', 'json', 'markdown' },
				  sync_install = false,
				  highlight = { enable = true },
				  indent = { enable = true },
			  })
		  end
	  end
  },
  {
    'sindrets/diffview.nvim',
    event = 'VeryLazy', -- lz
    config = function ()
      require('diffview').setup({
		  -- 思った通りに動かない
		  --[[
		  keymaps = {
		  view = {
		  {'n', "<C-n>", actions.select_next_entry,}, -- "<tab>",
		  {'n', "<C-p>", actions.select_prev_entry,}, -- "<tab>",
		  -- ["<C-p>"] = "<S-tab>",
		  -- { "n", "<tab>", "<C-w>w" },
		  -- { "n", "<S-tab>", false },
		  }
		  }
		  ]]
	    })
    end
  },
  { 'mfussenegger/nvim-dap', dependencies = { 'rcarriga/nvim-dap-ui', }, },
  { 
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy', -- lz
    dependencies = {
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'jvgrootveld/telescope-zoxide',
    },
    config = function()
      local plug = require('telescope.builtin')
      local exts = require('telescope').extensions
      m = {
        {'<Leader>tf', plug.find_files}, -- km
        {'<Leader>tg', plug.live_grep}, -- km
        {'<Leader>tb', plug.buffers}, -- km
        {'<Leader>th', plug.help_tags}, --km
        {'<Leader>td', plug.lsp_type_definitions}, -- km
        {'<Leader>tz', exts.zoxide.list}, -- km
        {'<Leader>tis', plug.git_status}, -- km
      }
      map_keys(m, vim.keymap.set)
      local default_grep_arguments = {
        "rg",
        "--follow",        -- Follow symbolic links
        "--hidden",        -- Search for hidden files
        "--no-heading",    -- Don't group matches by each file
        "--with-filename", -- Print the file path with the matched lines
        "--line-number",   -- Show line numbers
        "--column",        -- Show column numbers
        "--smart-case",    -- Smart case search

        -- Exclude some patterns from search
        "--glob=!**/.git/*",
        "--glob=!**/__pycache__/*",
      }
      local default_picker = {
        hidden = true,
        no_ignore = true,
        no_ignore_parent = true,
        find_command = {
          "rg",
          "--files",        -- Follow symbolic links
          "--hidden",        -- Search for hidden files
          "--glob=!**/.git/*",
          "--glob=!**/__pycache__/*",
          "--glob=!**/*.png",
        },
      }
      require('telescope').setup({
        defaults = {
          vimgrep_arguments = default_grep_arguments,
        },
        pickers = {
          find_files = default_picker,
          live_grep = default_picker,
          buffers = default_picker,
        },
      })
    end
  },
  --[[
  {
    'nvim-telescope/telescope-file-browser.nvim',
    event = 'VeryLazy', -- lz
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
  },
  ]]
  {
	  'fannheyward/telescope-coc.nvim',
    event = 'VeryLazy', -- lz
	  config = function ()
		  require('telescope').setup ({
			  coc = {
				  theme = 'ivy',
				  prefer_locations = true,
			  }
		  })
		  require('telescope').load_extension('coc')
	  end
  },
  {
	  'iamcco/markdown-preview.nvim',
    event = 'VeryLazy', -- lz
	  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
	  ft = { 'markdown' },
	  build = function() vim.fn['mkdp#util#install']() end,
  },
  { 'lambdalisue/suda.vim', event = 'VeryLazy' }, -- sudo Write/Read -- lz
  { 'akinsho/toggleterm.nvim', version = "*", opts = {},
    event = 'VeryLazy', -- lz
    config = function ()
      require('toggleterm').setup()
      m = {
        { '<Leader>so', string.format(":ToggleTerm<CR>") }, --km
        { '<Leader>so', string.format(":ToggleTerm<CR>") }, --km
        { '<Leader>st', string.format(":ToggleTerm direction=tab<CR>") }, --km
        { '<Leader>sf', string.format(":ToggleTerm direction=float<CR>") }, --km
        { 't', '<C-[>', [[<C-\><C-n>]] }, -- km
        { 't', '<M-d>', '<ESC>:tabnext<CR>'}, --km
      }
      map_keys(m)
    end
  },
  {
	  'folke/which-key.nvim', event = 'VeryLazy', -- lz
	  init = function()
		  vim.o.timeout = true
		  vim.o.timeoutlen = 500
	  end,
	  opts = {}
  },
  {
	  'krischik/vim-tail',
    event = 'VeryLazy', -- lz
	  config = function ()
		  vim.g.Tail_Height = 10
		  vim.g.Tail_Center_Win = 1
	  end
  },
  {
    'nvie/vim-flake8',
    event = 'VeryLazy', -- lz
    ft = 'python',
  },
  {
    'tell-k/vim-autopep8',
    event = 'VeryLazy', -- lz
    ft = 'python',
  },
  {
    'nvim-focus/focus.nvim', version = '*',
    config = function ()
      require('focus').setup({
        cusorline = true,
        autoresize = { enable = false },
        winhighlight = true,
        signcolumn = true,
      })

      local ignore_filetypes = { 'neo-tree' }
      local ignore_buftypes = { 'nofile', 'prompt', 'popup' }
      local augroup =
      vim.api.nvim_create_augroup('FocusDisable', { clear = true })

      vim.api.nvim_create_autocmd('WinEnter', {
        group = augroup,
        callback = function(_)
          if vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
            then
              vim.w.focus_disable = true
            else
              vim.w.focus_disable = false
            end
          end,
          desc = 'Disable focus autoresize for BufType',
      })

      vim.api.nvim_create_autocmd('FileType', {
        group = augroup,
        callback = function(_)
          if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.b.focus_disable = true
          else
            vim.b.focus_disable = false
          end
        end,
        desc = 'Disable focus autoresize for FileType',
      })
    end
  },
  {
    'dstein64/vim-startuptime',
    event = 'VeryLazy', -- lz
  },
  {
    'kensyo/nvim-scrlbkun',
    config = function()
      require('scrlbkun').setup()
    end,
  },
  {
    'EtiamNullam/deferred-clipboard.nvim',
    event = 'VeryLazy', -- lz
    config = function()
      require('deferred-clipboard').setup {
        fallback = 'unnamedplus',
        lazy = true,
      }
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

    end
  },
  {
    'RaafatTurki/hex.nvim',
    event = 'VeryLazy', -- lz
    config = function()
      require('hex').setup({})
    end
  },
  {
    'xiyaowong/transparent.nvim',

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

-- autocmd for python
vim.api.nvim_create_autocmd({'BufEnter', 'FileType'}, {
  callback = function ()
    if vim.bo.filetype == 'python' then
      vim.keymap.set('n', '<Leader>pp', ':call Autopep8()<CR>', {noremap = true, silent = true})
      vim.keymap.set('n', '<Leader>pf', ':Flake<CR>', {noremap = true, silent = true})
    else
      vim.keymap.set('n', '<Leader>pp', '') --, {noremap = true, silent = true})
      vim.keymap.set('n', '<Leader>pf', '')
    end
  end,
})
vim.api.nvim_create_autocmd({ 'BufWrite' }, {
    pattern = '*.py',
    command = ':Flake',
})
