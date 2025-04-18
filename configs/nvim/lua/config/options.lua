-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
--

-- vim.opt.guicursor = ""
--
-- -- line numbers
-- vim.opt.nu = true
-- -- vim.opt.relativenumber = true
--
-- vim.opt.tabstop = 8
-- vim.opt.softtabstop = 8
-- vim.opt.shiftwidth = 8
-- vim.opt.expandtab = false
--
-- vim.opt.smartindent = true
--
-- vim.opt.wrap = false
--
vim.opt.swapfile = false
-- vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
--
-- vim.opt.hlsearch = true
-- vim.opt.incsearch = true
--
-- vim.opt.termguicolors = true
--
-- -- vim.opt.scrolloff = 8
-- vim.opt.scrolloff = 10
-- vim.opt.signcolumn = "yes"
-- vim.opt.isfname:append("@-@")
--
-- vim.opt.updatetime = 50
--
-- vim.opt.colorcolumn = "80"
--
-- vim.g.mapleader = " "
--
-- -- Cursor Hightlight
-- vim.opt.cursorline = true

-- This file is automatically loaded by plugins.config
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.guicursor = "a:blinkon1"
opt.autowrite = true -- Enable auto write
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 3 -- Hide * markup for bold and italic
-- opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.confirm = false
opt.cursorline = true -- Enable highlighting of the current line
-- opt.expandtab = true -- Use spaces instead of tabs
opt.expandtab = false -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
-- vim.g.autoformat = "yes"
-- bopt.ignorecase = true -- Ignore case
opt.ignorecase = false -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 0
-- opt.list = true -- Show some invisible characters (tabs...
opt.list = false -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 10 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true -- Round indent
-- opt.shiftwidth = 2 -- Size of an indent
-- opt.shiftwidth = 8 -- Size of an indent
opt.shiftwidth = 4 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
-- opt.tabstop = 2 -- Number of spaces tabs count for
opt.tabstop = 8 -- Number of spaces tabs count for
opt.softtabstop = 8
opt.termguicolors = true -- True color support
opt.background = "dark"
opt.textwidth= 80
opt.colorcolumn = "80"
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap

if vim.fn.has("nvim-0.9.0") == 1 then
  opt.splitkeep = "screen"
  opt.shortmess:append({ C = true })
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
