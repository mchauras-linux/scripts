-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- For changing the background color from the rose-pine
    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            require("rose-pine").setup()
            vim.cmd('colorscheme rose-pine')
        end
    })

    -- use { "catppuccin/nvim", as = "catppuccin" }

    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use('nvim-treesitter/playground')
    use('ThePrimeagen/harpoon')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {                                      -- Optional
                'williamboman/mason.nvim',
            run = function()
                pcall(vim.cmd, 'MasonUpdate')
            end,
        },
        {'williamboman/mason-lspconfig.nvim'}, -- Optional

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},     -- Required
        {'hrsh7th/cmp-nvim-lsp'}, -- Required
        {'L3MON4D3/LuaSnip'},     -- Required
        {'hrsh7th/cmp-buffer'},       -- Optional
        {'hrsh7th/cmp-path'},         -- Optional
        {'saadparwaiz1/cmp_luasnip'}, -- Optional
        {'hrsh7th/cmp-nvim-lua'},     -- Optional
    }
}

-- use {
    --	  'VonHeikemen/lsp-zero.nvim',
    --	  branch = 'v1.x',
    --	  requires = {
        --		  -- LSP Support
        --		  {'neovim/nvim-lspconfig'},             -- Required
        --		  {'williamboman/mason.nvim'},           -- Optional
        --		  {'williamboman/mason-lspconfig.nvim'}, -- Optional
        --
        --		  -- Autocompletion
        --		  {'hrsh7th/nvim-cmp'},         -- Required
        --		  {'hrsh7th/cmp-nvim-lsp'},     -- Required
        --		  {'hrsh7th/cmp-buffer'},       -- Optional
        --		  {'hrsh7th/cmp-path'},         -- Optional
        --		  {'saadparwaiz1/cmp_luasnip'}, -- Optional
        --		  {'hrsh7th/cmp-nvim-lua'},     -- Optional
        --
        --		  -- Snippets
        --		  {'L3MON4D3/LuaSnip'},             -- Required
        --		  {'rafamadriz/friendly-snippets'}, -- Optional
        --	  }
        --  }
        use('nvim-tree/nvim-web-devicons')
        -- Adding support for status line
        use {
            'nvim-lualine/lualine.nvim',
            -- requires = { 'kyazdani42/nvim-web-devicons', opt = true }
            requires = { 'nvim-tree/nvim-web-devicons' }
        }
        use {
            'akinsho/bufferline.nvim',
            tag = "v3.*",
            requires = { 'nvim-tree/nvim-web-devicons' }
        }

        use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })

        use({
            'nvim-tree/nvim-tree.lua',
            requires = { 'nvim-tree/nvim-web-devicons' }
        })

        -- https://github.com/lukas-reineke/indent-blankline.nvim
        --  use('lukas-reineke/indent-blankline.nvim')

        use {
            'christoomey/vim-tmux-navigator',
            lazy = false,
        }
        -- Lua
        use {
            "folke/trouble.nvim",
            requires = "nvim-tree/nvim-web-devicons",
        }

    end)
