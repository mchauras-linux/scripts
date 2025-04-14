-- return  {
--     "catppuccin/nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
-- 	vim.cmd([[colorscheme catppuccin-macchiato]])
--     end,
-- }


-- return {
--     {
-- 	"LazyVim/LazyVim",
-- 	opts = {
-- 	    colorscheme = "catppuccin",
-- 	    flavour = "latte",
-- 	}
--     }
-- }

-- return
--     {
-- 	"catppuccin/nvim",
-- 	lazy = true,
-- 	name = "catppuccin",
-- 	-- transparent_background = true,
-- 	opts = {
-- 	    flavour = "latte",
-- 	    integrations = {
-- 		aerial = true,
-- 		alpha = true,
-- 		cmp = true,
-- 		dashboard = true,
-- 		flash = true,
-- 		gitsigns = true,
-- 		headlines = true,
-- 		illuminate = true,
-- 		indent_blankline = { enabled = true },
-- 		leap = true,
-- 		lsp_trouble = true,
-- 		mason = true,
-- 		markdown = true,
-- 		mini = true,
-- 		native_lsp = {
-- 		    enabled = true,
-- 		    underlines = {
-- 			errors = { "undercurl" },
-- 			hints = { "undercurl" },
-- 			warnings = { "undercurl" },
-- 			information = { "undercurl" },
-- 		    },
-- 		},
-- 		navic = { enabled = true, custom_bg = "lualine" },
-- 		neotest = true,
-- 		neotree = true,
-- 		noice = true,
-- 		notify = true,
-- 		semantic_tokens = true,
-- 		telescope = true,
-- 		treesitter = true,
-- 		treesitter_context = true,
-- 		which_key = true,
-- 	    },
-- 	},
--     }

return {
    -- add gruvbox
    { "ellisonleao/gruvbox.nvim", enabled = true },

    -- Configure LazyVim to load gruvbox
    {
	"LazyVim/LazyVim",
	contrast = "hard",
	opts = {
	    transparent_mode = true,
	    colorscheme = "gruvbox",
	},
    },
}

-- return {
--   "folke/tokyonight.nvim",
--   lazy = true,
--   opts = {
--     transparent = true,
--     style = "night",
--     styles = {
--       sidebars = "transparent",
--       floats = "transparent",
--     },
--   },
-- }

-- return {
--   -- add gruvbox
--   { "sainnhe/gruvbox-material", enabled = true },
--
--   -- Configure LazyVim to load gruvbox
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       gruvbox_material_background = "soft",
--       colorscheme = "gruvbox-material",
--     },
--   },
-- }
--
-- return {
--   -- add gruvbox
--   { "rose-pine/neovim" },
--
--   -- Configure LazyVim to load gruvbox
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "rose-pine",
--     },
--   },
-- }

--   "catppuccin/nvim",
--   lazy = true,
--   name = "catppuccin-mocha",
-- }
