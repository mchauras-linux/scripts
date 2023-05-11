local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.ensure_installed({
    'tsserver',
    'eslint',
    -- 'sumneko_lua',
    'lua_ls',
    'rust_analyzer',
    'clangd',
})

local cmp = require('cmp')
local cmp_select = { behaviour = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

lsp.set_preferences({
    sign_icons = {}
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.on_attach(function(client, bufnr)
--    print("help")
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)

    -- Displays hover information about the symbol under the cursor
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)

    -- Gets all the symbols in the current workspace
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)

    -- View Diagnostic
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)

    -- Asks the user for a code action to execute (if one is avaialble at the
    -- current cursor position). If range is given, prompts the user for a
    -- range code action (only works line-wise).
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)

    -- Gets all the references to the symbol under the cursor.
    vim.keymap.set("n", "<leader>vrf", function() vim.lsp.buf.references() end, opts)

    -- Renames all references to the symbol under the cursor. If no {new_name} is given, prompts the user for one.
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)

    -- Displays the signature help information about the symbol under the cursor
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

    -- Gets all the symbols in the current buffer
    vim.keymap.set("n", "<leader>vds", function() vim.lsp.buf.document_symbol() end, opts)

    -- Format the current buffer.
    vim.keymap.set("n", "<leader>vf", function() vim.lsp.buf.format() end, opts)
end)

lsp.setup()
