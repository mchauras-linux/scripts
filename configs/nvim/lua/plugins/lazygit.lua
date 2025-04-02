return {
    "kdheepak/lazygit.nvim",
    cmd = {
	"LazyGit",
	"LazyGitConfig",
	"LazyGitCurrentFile",
	"LazyGitFilter",
	"LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
	"nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is rercommended in order
    -- to load the plugin when the command is run for the first time
    keys = {
	-- this keyshort was essentially doing same thing but with this, the
	-- appearance is much better
	{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open lazygit" },
    },
}

-- Steps
--	1. Installation: 
--		sudo dnf copr enable atim/lazygit -y
--		sudo dnf install lazygit


-- Go to any window and hit "?". This will show all the key bindings for that
-- window. You can filter those key bindings by pressing "/" for search.

-- From lazygit
-- 1) If you want to learn about lazygit's features, watch this vid:
--      https://youtu.be/CPLdltN7wgE
-- 
-- 2) Be sure to read the latest release notes at:
--      https://github.com/jesseduffield/lazygit/releases
-- 
-- 3) If you're using git, that makes you a programmer! With your help we can make
--    lazygit better, so consider becoming a contributor and joining the fun at
--      https://github.com/jesseduffield/lazygit
--
-- Keybindings: https://github.com/jesseduffield/lazygit/blob/master/docs/keybindings
-- Tutorial: https://youtu.be/VDXvbHZYeKY

