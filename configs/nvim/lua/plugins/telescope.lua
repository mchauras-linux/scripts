return {
	"nvim-telescope/telescope.nvim",
	keys = {
		-- add a keymap to browse plugin files
		-- stylua: ignore
		{
			"<leader>sg",
			function()
				require("telescope.builtin").live_grep({})
			end,
			desc = "Grep (root dir)",
		},
		{
			"<leader>/",
			function()
				require("telescope.builtin").live_grep({ cwd = false })
			end,
			desc = "Grep (cwd)",
		},
	},
}
