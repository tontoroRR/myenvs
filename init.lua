-- efm-langserver

local options = {
  encoding = "utf-8",
  fileencoding = "utf-8",
  -- encodings = "utf-8,euc-jp,sjis",
  fileencodings = "utf-8,euc-jp,sjis",
  fileformats = 'unix,dos',
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
  splitbelow = true,
  splitright = true,
}

-- set lua, python
vim.g.lua_host_prog = '/home/vagrant/.asdf/installs/lua/5.1.5/bin/lua'
vim.g.python3_host_prog = '/home/vagrant/.asdf/shims/python3'

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
function map_keys (keymaps, cmd) 
  -- keymaps (modes='n,g,v,i,t':'n', key, action, opt(silent)=true/false:true)
  local opts = { noremap = true, silent = true }
  local ns_opts = { noremap = true, silent = false }
  cmd = cmd or vim.keymap.set -- vim.api.nvim_set_keymap

  for _, keymap in ipairs(keymaps) do
    local modes = keymap[3] and keymap[1] or 'n'
    local key = keymap[3] and keymap[2] or keymap[1]
    local action = keymap[3] or keymap[2]
    local opt = (#keymap == 3 or keymap[4]) and opts or ns_opts

    modes = type(modes) == 'table' and modes or { modes }
    for _, mode in ipairs(modes) do
      cmd(mode, key, action, opt)
    end
  end
end

local global_keymaps = {
  -- tile ops
  {'<M-h>', '<C-w>h'},
  {'<M-j>', '<C-w>j'},
  {'<M-k>', '<C-w>k'},
  {'<M-l>', '<C-w>l'},
  {'<tab>', '<C-w>w'},
  {'<S-tab>', '<C-w>W'},
  {'<M-S-h>', '<C-w><'},
  {'<M-S-k>', '<C-w>+'},
  {'<M-S-j>', '<C-w>-'},
  {'<M-S-l>', '<C-w>>'},
  {[[<M-\>]], ':vsplit<CR>'},
  {[[<M-->]], ':split<CR>'},
  {[[<M-S-->]], '<C-w>='},
  {'<C-[>', '<Esc>'},
  -- tab ops
  {'<M-d>', ':tabnext<CR>'},
  -- remove highlight
  {'zz', ':nohlsearch<CR>'},
  -- test
  -- {'v', 'y', ':w !clip.exe<return><return>'},
  {'<leader><Space>', ':e#<CR>' },
  {'<leader>fo', ':tab split<CR>' },
  -- {'<leader><leader>', ':BlinkCursor<CR>' },
}
map_keys(global_keymaps)

-- clipboard
-- deferred-clipboardで設定する

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
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
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
      require('neo-tree').setup({
        window = {
          mappings = {
            ['e'] = function() vim.api.nvim_exec('Neotree focus filesystem left', true) end,
            ['b'] = function() vim.api.nvim_exec('Neotree focus buffers left', true) end,
            ['g'] = function() vim.api.nvim_exec('Neotree focus git_status left', true) end,
            ['..'] = function() vim.api.nvim_exec('cd ..', true) end,
          },
        },
      })
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy', -- lz
    config = function()
      require('gitsigns').setup {
      }
    end,
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
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context',
      { 'nushell/tree-sitter-nu' },
    },
    event = 'VeryLazy',
    build = ':TSUpdate',
    config = function()
      if vim.loop.os_uname().sysname == 'Linux' then
        local configs = require('nvim-treesitter.configs')
        configs.setup({
          ensure_installed = { 'nu', 'json', 'vim', 'lua', 'python', 'yaml', 'json', 'markdown' },
          sync_install = false,
          highlight = {
            enable = true,
          },
          indent = { enable = true },
        })
      end
      -- fold
      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
    end
  },
  { 'mfussenegger/nvim-dap', dependencies = { 'rcarriga/nvim-dap-ui', }, },
  { 
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy', -- lz
    dependencies = {
      -- 'nvim-telescope/telescope-file-browser.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'jvgrootveld/telescope-zoxide',
      'LukasPietzschmann/telescope-tabs',
    },
    config = function()
      local plug = require('telescope.builtin')
      local exts = require('telescope').extensions
      require('telescope').load_extension 'telescope-tabs'
      local tabs = require('telescope-tabs')

      m = {
        {'<Leader>tb',  plug.buffers}, -- km
        {'<Leader>td',  plug.lsp_type_definitions}, -- km
        {'<Leader>tf',  plug.find_files}, -- km
        {'<Leader>tg',  plug.live_grep}, -- km
        {'<Leader>th',  plug.help_tags}, --km
        {'<Leader>tis', plug.git_status}, -- km
        {'<Leader>to',  plug.oldfiles}, -- km
        {'<Leader>tt',  tabs.list_tabs}, -- km exts.'telescope-tabs'.list_tabs()
        {'<Leader>tz',  exts.zoxide.list}, -- km
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
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', },
  {
    'stevearc/profile.nvim',
    config = function ()
      local should_profile = os.getenv("NVIM_PROFILE")
      if should_profile then
        require("profile").instrument_autocmds()
        if should_profile:lower():match("^start") then
          require("profile").start("*")
        else
          require("profile").instrument("*")
        end
      end

      local function toggle_profile()
        local prof = require("profile")
        if prof.is_recording() then
          prof.stop()
          vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
            if filename then
              prof.export(filename)
              vim.notify(string.format("Wrote %s", filename))
            end
          end)
        else
          prof.start("*")
        end
      end
      vim.keymap.set("", "<Leader>p", toggle_profile)
    end
  },
  {
    'fannheyward/telescope-coc.nvim',
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
    'tontoroRR/cder.nvim',
    branch = 'support_windows',
    event = 'VeryLazy', -- lz
    config = function ()
      m = {
        {'<Leader>tc',  ':Telescope cder<CR>'}, -- km
      }
      map_keys(m, vim.keymap.set)
      local fd_param = '--type directory --type symlink --exclude .git'
      if vim.loop.os_uname().sysname == 'Windows_NT' then
        require('telescope').setup({
          extensions = {
            cder = {
              command_executer = { 'cmd.exe', '/c' },
              previewer_command = 'eza -a -F --icons --color -1', -- uutils ls -a',
              pager_commnd = 'bat --plain --paging=always --pager="less -RS"',
              dir_command = { 'fd.exe', '--type=d', '--type=l', '.', },
            }
          },
        })
      else
        require('telescope').setup({
          extensions = {
            cder = {
              dir_command = { 'fdfind', '--type=d', '--type=l', '--exclude=.git', '.', },
              previewer_command = 'exa -a --icons --color=auto -F -1',
            },
          },
        })
      end
      require('telescope').load_extension 'cder'
    end
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
      local powershell_options = {
      }
    end
  },
  {
    'folke/which-key.nvim',
    dependencies = { 'echasnovski/mini.icons', version = false },
    event = 'VeryLazy', -- lz
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
  { 'nvie/vim-flake8', event = 'VeryLazy', ft = 'python', }, -- lz
  { 'tell-k/vim-autopep8', event = 'VeryLazy', ft = 'python', },-- lz
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
      copy_command = 'win32yank.exe -i --crlf'
      paste_command = 'win32yank.exe -o --lf'
      if vim.loop.os_uname().sysname == 'Linux' then
        copy_command = 'xsel -ib'
        paste_command = 'xsel -ob'
      end
      vim.g.clipboard = {
        name = 'clip',
        copy = {
          ['+'] = copy_command,
          ['*'] = copy_command,
        },
        paste = {
          ['+'] = paste_command,
          ['*'] = paste_command,
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
    'iamcco/markdown-preview.nvim',
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  { 'xiyaowong/transparent.nvim', event = 'VeryLazy', },
  { 'famiu/nvim-reload', event = 'VeryLazy', },
  {
    'famiu/bufdelete.nvim',
    config = function()
      m = {
        { '<Leader>d', ':Bdelete<CR>' }, --km
      }
      map_keys(m)
    end
  },
  {
    'tontoroRR/oil.nvim',
    -- branch = 'support_windows',
    event = 'VeryLazy',
    config = function()
      require('oil').setup()
      m = {
        { '<Leader>o', ':Oil --float .<CR>' }, -- km
      }
      map_keys(m, vim.keymap.set)
    end,
  },
  {
    'j-morano/buffer_manager.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', },
    event = 'VeryLazy',
    config = function()
      local opts = {noremap = true}
      local map = vim.keymap.set
      -- Setup
      require('buffer_manager').setup({
        select_menu_item_commands = {
          v = { key = '<C-v>', command = 'vsplit' },
          h = { key = '<C-h>', command = 'split' },
        },
      })
      -- Navigate buffers bypassing the menu
      local bmui = require("buffer_manager.ui")
      local keys = '1234567890'
      for i = 1, #keys do
        local key = keys:sub(i,i)
        map('n', string.format('<leader>%s', key),
          function () bmui.nav_file(i) end,
          opts
        )
      end
      -- Just the menu
      map({ 't', 'n' }, '<Leader>;', bmui.toggle_quick_menu, opts)
      -- Open menu and search
      map({ 't', 'n' }, '<Leader>:', function ()
        bmui.toggle_quick_menu()
        -- wait for the menu to open
        vim.defer_fn(function ()
          vim.fn.feedkeys('/')
        end, 50)
      end, opts)
      -- Next/Prev
      map('n', '<M-j>', bmui.nav_next, opts)
      map('n', '<M-k>', bmui.nav_prev, opts)
      -- Reorder buffers
      -- vim.api.nvim_command([[
      -- autocmd FileType buffer_manager vnoremap J :m '>+1<CR>gv=gv
      -- autocmd FileType buffer_manager vnoremap K :m '>-2<CR>gv=gv
      -- ]])
      vim.api.nvim_create_autocmd({'BufEnter', 'FileType'}, {
        callback = function()
          -- print(vim.bo.filetype)
          if vim.bo.filetype == 'buffer_manager' then
            vim.keymap.set('n', '<M-j>', ":m '>+1<CR>gv=gv", {noremap = true, silent = true})
            vim.keymap.set('n', '<M-k>', ":m '>-2<CR>gv=gv", {noremap = true, silent = true})
          end
        end,
      })
    end,
  },
  -- TODO: LAST OF PLUGIN
  -- { 'andweeb/presence.nvim', event = 'VeryLazy', },
  --[[
  { 'sheerun/vim-polyglot' },
  { 'rust-lang/rust.vim' },
  { 'feline-nvim/feline.nvim', },
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
  ]]
  --[[
  {
    'junegunn/fzf',
    dir = "~/.fzf",
    build = "./install --all",
  },
  { 'junegunn/fzf.vim' },
  {
    'antoinemadec/coc-fzf',
    event = 'VeryLazy',
  },
  ]]--
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

--[[
function xxx()
  local buf = vim.api.nvim_buf_get_name(0)
  local profile = 'D:\Users\masaaki\Documents\PowerShell\Microsoft.PowerShell_profile.ps1'
  -- local 
end
]]

vim.api.nvim_create_user_command('BlinkCursor', blink_cursor, {})
-- vim.api.nvim_create_user_command('EditProfile', edit_profile, {})

-- autocmd for python
vim.api.nvim_create_autocmd({'BufEnter', 'FileType'}, {
  callback = function ()
    if vim.bo.filetype == 'python' then
      vim.keymap.set('n', '<Leader>pp', ':call Autopep8()<CR>', {noremap = true, silent = true})
      vim.keymap.set('n', '<Leader>pf', ':Flake<CR>', {noremap = true, silent = true})
      vim.keymap.set('n', '<Leader>px', ':w!<CR>:split|ter python %<CR>a', {noremap = true, silent = true})
    else
      vim.keymap.set('n', '<Leader>pp', '')
      vim.keymap.set('n', '<Leader>pf', '')
      vim.keymap.set('n', '<Leader>px', '')
    end
  end,
})
vim.api.nvim_create_autocmd({ 'BufWrite' }, {
  pattern = '*.py',
  command = ':Flake',
})

-- Use powershell for windows
if vim.loop.os_uname().sysname == 'Windows_NT' then
  local pwsh_options = {
    shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
    shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
    shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
    shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    shellquote = "",
    shellxquote = "",
  }

  --[[
  for k, v in pairs(pwsh_options) do
    vim.opt[k] = v
  end
  ]]
end
