-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Disable autoformat for lua files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "c", "sh" },
  callback = function()
    vim.b.autoformat = false
  end,
})

-- Define the highlight group for trailing spaces
vim.cmd([[highlight ExtraWhitespace ctermbg=red guibg=red]])

-- Autocommands to toggle highlighting based on the mode
vim.api.nvim_create_augroup("TrailingSpacesHighlight", { clear = true })
vim.api.nvim_create_autocmd("InsertLeave", {
  group = "TrailingSpacesHighlight",
  pattern = "*",
  command = "match ExtraWhitespace /\\s\\+$/"
})
vim.api.nvim_create_autocmd("InsertEnter", {
  group = "TrailingSpacesHighlight",
  pattern = "*",
  command = "match none"
})

-- Autocmds to highlighting the word under cursor
-- vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
--   callback = function()
--     local word = vim.fn.expand("<cword>")
--     if word and word ~= "" then
--       vim.fn.matchadd("Search", "\\<" .. word .. "\\>")
--     end
--   end,
-- })
