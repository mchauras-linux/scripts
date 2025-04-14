return {
    "simrat39/symbols-outline.nvim",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    cmd = "SymbolsOutline",
    opts = function()
	local Config = require("lazyvim.config")
	local defaults = require("symbols-outline.config").defaults
	local opts = {
	    highlight_hovered_item = true,
	    show_guides = true,
	    auto_preview = false,
	    position = 'right',
	    relative_width = true,
	    width = 20,
	    auto_close = false,
	    show_numbers = false,
	    show_relative_numbers = false,
	    show_symbol_details = true,
	    preview_bg_highlight = 'Pmenu',
	    autofold_depth = nil,
	    auto_unfold_hover = true,
	    fold_markers = { '', '' },
	    wrap = false,
	    keymaps = { -- These keymaps can be a string or a table for multiple keys
		close = {"<Esc>", "q"},
		goto_location = "<Cr>",
		focus_location = "o",
		hover_symbol = "<C-space>",
		toggle_preview = "K",
		rename_symbol = "r",
		code_actions = "a",
		fold = "h",
		unfold = "l",
		fold_all = "W",
		unfold_all = "E",
		fold_reset = "R",
	    },
	    symbols = {
		File = { icon = "", hl = "@text.uri" },
		Module = { icon = "", hl = "@namespace" },
		Namespace = { icon = "", hl = "@namespace" },
		Package = { icon = "", hl = "@namespace" },
		Class = { icon = "𝓒", hl = "@type" },
		Method = { icon = "ƒ", hl = "@method" },
		Property = { icon = "", hl = "@method" },
		Field = { icon = "", hl = "@field" },
		Constructor = { icon = "", hl = "@constructor" },
		Enum = { icon = "ℰ", hl = "@type" },
		Interface = { icon = "ﰮ", hl = "@type" },
		Function = { icon = "", hl = "@function" },
		Variable = { icon = "", hl = "@constant" },
		Constant = { icon = "", hl = "@constant" },
		String = { icon = "𝓐", hl = "@string" },
		Number = { icon = "#", hl = "@number" },
		Boolean = { icon = "⊨", hl = "@boolean" },
		Array = { icon = "", hl = "@constant" },
		Object = { icon = "⦿", hl = "@type" },
		Key = { icon = "🔐", hl = "@type" },
		Null = { icon = "NULL", hl = "@type" },
		EnumMember = { icon = "", hl = "@field" },
		Struct = { icon = "𝓢", hl = "@type" },
		Event = { icon = "🗲", hl = "@type" },
		Operator = { icon = "+", hl = "@operator" },
		TypeParameter = { icon = "𝙏", hl = "@parameter" },
		Component = { icon = "", hl = "@function" },
		Fragment = { icon = "", hl = "@constant" },
	    },
	    symbol_blacklist = {},
	    lsp_blacklist = {},
	}
	local filter = Config.kind_filter

	if type(filter) == "table" then
	    filter = filter.default
	    if type(filter) == "table" then
		for kind, symbol in pairs(defaults.symbols) do
		    opts.symbols[kind] = {
			icon = Config.icons.kinds[kind] or symbol.icon,
			hl = symbol.hl,
		    }
		    if not vim.tbl_contains(filter, kind) then
			table.insert(opts.symbol_blacklist, kind)
		    end
		end
	    end
	end
	return opts
    end,
}
