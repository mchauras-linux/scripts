-- return {
--   "iamcco/markdown-preview.nvim",
--   build = "cd app && npm install",
--   run = function()
--     vim.g.mkdp_filetypes = { "markdown" }
--   end,
--   ft = { "markdown" },
-- }
--

-- return {
--   "iamcco/markdown-preview.nvim",
-- }

-- return {
--   {
--     {
--       "iamcco/markdown-preview.nvim",
--       ft = "markdown",
--       -- build = "cd app && yarn install",
--       build = ":call mkdp#util#install()",
--     },
--   },
-- }

-- If :MarkdownPreview is not working in NeoVim, run the following command
-- manually once to install the plugin:
-- `:call mkdp#util#install()`

return {
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    -- build = "cd app && yarn install",
    build = ":call mkdp#util#install()",
  },
}
