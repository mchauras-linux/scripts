-- ~/.config/neovim/lua/user/options.lua

-- convert tabs to spaces
vim.opt.expandtab = true

-- automatic indentation 
vim.opt.smartindent = true

-- the number of spaces inserted for each indentation
vim.opt.shiftwidth = 2

-- allow neovim to access the system clipboard
vim.opt.clipboard = "unnamedplus"

-- highlight all matches on previous search pattern
vim.opt.hlsearch = true

-- ignore case in search patterns
vim.opt.ignorecase = true

-- allow the mouse to be used in neovim
vim.opt.mouse = "a"

-- insert 2 spaces for a tab
vim.opt.tabstop = 2

-- highlight the current line
vim.opt.cursorline = true

-- set numbered lines
vim.opt.number = true

-- faster completion (4000ms default)
vim.opt.updatetime = 250

-- the encoding written to a file
vim.opt.fileencoding = "utf-8"
