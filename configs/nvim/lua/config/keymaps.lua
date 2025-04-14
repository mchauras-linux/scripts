-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- move commands. Selected blocks can be moved with "J and "K" with auto indentation
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Move lines with "J" without moving the cursor from the first line. J takes the line below to the same line with a space by default but moves the cursor. This shortcut retains the cursor
vim.keymap.set("n", "J", "mzJ`z")

-- half place jumping. The cursor remains in the middle of the page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep the searched term in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>vwm", function()
  require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
  require("vim-with-me").StopVimWithMe()
end)

-- greatest remap ever
-- This keeps the last last copied data into the buffer that can be pasted multiple times
-- vim.keymap.set("x", "<leader>p", "\"_dP")

-- next greatest remap ever : asbjornHaland
-- leader+p ap to yank a complete paragraph and paste it anywhere in the system but not only local to vim
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format()
end)

-- Navigation
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Copy and Replace in the whole file
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- Make a file executable directly
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- This is the default behavior in VIM but not sure why these were not working 
-- in LazyVim config. Hence, restoritng the original behavior with the below
-- Also, run `help s` to find out the help page with the detailed info.
-- s to use the cl action 
vim.keymap.set("n", "s", "cl")
-- S to delete the lines 
vim.keymap.set("n", "S", "cc")

vim.keymap.set("n", "<C-w><", ":vertical:resize -10<CR>")
vim.keymap.set("n", "<C-w>>", ":vertical:resize +10<CR>")

-- Pressing * or # will not move the cursor from current position
-- use n and N for navigating b/w the matches
-- vim.api.nvim_set_keymap("n", "*", "*``", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "#", "#``", { noremap = true, silent = true })


-- Highlight trailing spaces in red
-- vim.cmd([[highlight ExtraWhitespace ctermbg=red guibg=red]])
-- vim.cmd([[match ExtraWhitespace /\s\+$/]])

-- ## Utils
--  To remote trailing whitespaces, run the following:
-- 	:%s/\s\+$//e
