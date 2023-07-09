return {
  "dhananjaylatkar/cscope_maps.nvim",
  dependencies = {
    "folke/which-key.nvim", -- optional [for whichkey hints]
    "nvim-telescope/telescope.nvim", -- optional [for picker="telescope"]
    "ibhagwan/fzf-lua", -- optional [for picker="fzf-lua"]
    "nvim-tree/nvim-web-devicons", -- optional [for devicons in telescope or fzf]
  },
  opts = {
    -- maps related defaults
    disable_maps = false, -- "true" disables default keymaps
    skip_input_prompt = false, -- "true" doesn't ask for input

    -- cscope related defaults
    cscope = {
      -- location of cscope db file
      db_file = "./cscope.out",
      -- cscope executable
      exec = "cscope", -- "cscope" or "gtags-cscope"
      -- choose your fav picker
      picker = "fzf-lua", -- "telescope", "fzf-lua" or "quickfix"
      -- "true" does not open picker for single result, just JUMP
      skip_picker_for_single_result = true, -- "false" or "true"
      -- these args are directly passed to "cscope -f <db_file> <args>"
      db_build_cmd_args = { "-bqkv" },
      -- statusline indicator, default is cscope executable
      statusline_indicator = nil,
    },
  },
}
