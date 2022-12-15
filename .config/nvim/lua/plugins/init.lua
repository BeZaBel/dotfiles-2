-- This file is part of Itsnexn's dotfiles.
--
-- Repository: https://github.com/itsnexn/dotfiles
-- LICENSE:    MIT (https://opensource.org/licenses/MIT)

local packer_ok, packer = pcall(require, "packer")

if packer_ok then
    local fopen_events = { "BufRead", "BufWinEnter", "BufNewFile" }

    local plugins = {

        { "wbthomason/packer.nvim" },
        { "nvim-lua/plenary.nvim" },
        { "kyazdani42/nvim-web-devicons" },

        -- ============================== UI ===================================
        -- Theme
        {
            "navarasu/onedark.nvim",
            config = function()
                require("onedark").setup({
                    style = "darker",
                    term_colors = false,
                })
                require("onedark").load()
            end
        },
        -- Language Parser
        {
            "nvim-treesitter/nvim-treesitter",
            event = fopen_events,
            module = "nvim-treesitter",
            run = ":TSUpdate",
            config = require("plugins.config.other").treesitter
        },
        {
            "nvim-lualine/lualine.nvim",
            config = require("plugins/config/lualine").init
        },
        {
            "lewis6991/gitsigns.nvim",
            requires = "nvim-lua/plenary.nvim",
            event = fopen_events,
            config = require("plugins.config.other").gitsigns
        },
        {
            "nvchad/nvim-colorizer.lua",
            event = fopen_events,
            config = require("plugins.config.other").colorizer
        },
        {
            "lukas-reineke/indent-blankline.nvim",
            event = fopen_events,
            config = require("plugins.config.other").indent_blankline
        },

        -- ============================= LSP ===================================
        { "neovim/nvim-lspconfig" },
        {
            "williamboman/mason-lspconfig.nvim",
            after = "nvim-lspconfig"
        },
        {
            "williamboman/mason.nvim",
            after = "mason-lspconfig.nvim",
            config = function()
                require("plugins.config.mason")
            end
        },
        {
            "jose-elias-alvarez/null-ls.nvim",
            after = "mason.nvim"
        },
        { "jayp0521/mason-null-ls.nvim",
            after = "null-ls.nvim",
            config = function()
                require("mason-null-ls").setup({ automatic_setup = true })
            end,
        },

        -- ======================== Code Completion ============================
        { "dcampos/nvim-snippy" },
        {
            "hrsh7th/nvim-cmp",
            config = function()
                require("plugins.config.cmp")
            end
        },
        { "dcampos/cmp-snippy", after = "nvim-cmp" },
        {
            "hrsh7th/cmp-nvim-lsp",
            after = "cmp-snippy",
            config = function()
                local lspconfig = require("lspconfig")
                local lsp_defaults = lspconfig.util.default_config

                lsp_defaults.capabilities = vim.tbl_deep_extend(
                    'force',
                    lsp_defaults.capabilities,
                    require('cmp_nvim_lsp').default_capabilities())
            end
        },
        { "hrsh7th/cmp-nvim-lua", after = "cmp-nvim-lsp" },
        { "hrsh7th/cmp-buffer", after = "cmp-nvim-lua" },
        { "hrsh7th/cmp-path", after = "cmp-buffer" },

        -- ========================= Utilities =================================
        {
            "windwp/nvim-autopairs",
            config = require("plugins.config.other").autopairs,
            event = fopen_events
        },
        {
            "folke/trouble.nvim",
            config = require("plugins.config.other").trouble
        },
        { "Asheq/close-buffers.vim" },
        { "andymass/vim-matchup" },
        { "tpope/vim-repeat", event = fopen_events },
        { "tpope/vim-surround", event = fopen_events },
        {
            "folke/which-key.nvim",
            config = require("plugins.config.other").whichkey
        },
        { "godlygeek/tabular", event = fopen_events },
        {
            "kyazdani42/nvim-tree.lua",
            config = require("plugins.config.nvim-tree").init
        },
        {
            "numToStr/Comment.nvim",
            event = fopen_events,
            config = require("plugins.config.other").comment
        },
        {
            "nvim-telescope/telescope.nvim",
            requires = "nvim-lua/plenary.nvim",
            config = require("plugins.config.telescope").init
        },
        {
            "folke/todo-comments.nvim",
            event = fopen_events,
            requires = "nvim-lua/plenary.nvim",
            config = require("plugins/config/todo-comments").init
        },
        {
            "TimUntersberger/neogit",
            event = fopen_events,
            requires = "nvim-lua/plenary.nvim",
            cmd = "Neogit"
        },
        {
            "iamcco/markdown-preview.nvim",
            ft = { "markdown" },
            run = function() vim.fn["mkdp#util#install"]() end,
            setup = require("plugins.config.other").markdown_preview
        },

        -- ======================== Language Support ===========================
        { "ron-rs/ron.vim", ft = "ron" },
        {
            'jakewvincent/mkdnflow.nvim',
            branch = "dev",
            config = require("plugins.config.other").mkdnflow
        },
    }

    packer.init({
        auto_clean = true,
        compile_on_sync = true,
        open_fn = function()
            return require("packer.util").float({ border = "single" })
        end,
        display = {
            open_fn = require('packer.util').float,
        }
    })

    packer.startup { plugins }
else
    error("Packer Is not installed!\nhttps://github.com/wbthomason/packer.nvim")
end
