-- dnf install ripgrep => Do this for the live grep to work
-- dnf install npm => To install node.js. This facilitates the plugin installation
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-gf>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("grep > ") });
end)
-- vim.keymap.set('n', '<leader>lg', function()    
--    builtin.live_grep({ search = vim.fn.input("live_grep > ") });
-- end)
vim.keymap.set('n', '<leader>lg', builtin.live_grep, {})
