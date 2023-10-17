return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    local icons = require("lazyvim.config").icons
    local Util = require("lazyvim.util").ui

    return {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          {
            "branch",
            icon = { "", color = { fg = "yellow" } },
          },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
          },
        },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          -- { "filename", path = 2, symbols = { modified = "  ", readonly = "", unnamed = "", newfile = "[New]" } },
          {
            "filename",
            path = 2,
            symbols = { modified = "[+]", readonly = "[-]", unnamed = "[No Name]", newfile = "[New]" },
          },
					-- stylua: ignore
					{
						function() return require("nvim-navic").get_location() end,
						cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
					},
        },
        lualine_x = {
					-- stylua: ignore
					{
						function() return require("noice").api.status.command.get() end,
						cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
						color = Util.fg("Statement"),
					},
          "encoding",
					-- stylua: ignore
					{
						function() return require("noice").api.status.mode.get() end,
						cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
						color = Util.fg("Constant"),
					},
					-- stylua: ignore
					{
					function() return "  " .. require("dap").status() end,
						cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
						color = Util.fg("Debug"),
					},
          { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = Util.fg("Special") },
        },
        lualine_y = {
          { "location", separator = "", padding = { left = 0, right = 0 } },
          { "%L", icon = "☰", separator = "", padding = { left = 1, right = 1 } },
          { "progress", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            -- Ref for formats: https://www.gammon.com.au/scripts/doc.php?lua=os.date
            return " " .. os.date("%b %d, %I:%M %p")
          end,
        },
      },
      extensions = { "neo-tree", "lazy" },
    }
  end,
}
