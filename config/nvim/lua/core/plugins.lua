local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    { 'ellisonleao/gruvbox.nvim',        priority = 1000 },
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.3',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    'mbbill/undotree',
    'preservim/nerdcommenter',
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',
    -- LSP
    { 'williamboman/mason.nvim',     build = ':MasonUpdate' },
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    -- CPM
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip'
        }
    },
    { "rafamadriz/friendly-snippets" },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {}
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- this is equalent to setup({}) function
    },
    {
        'stevearc/aerial.nvim',
        opts = {},
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    }
}

local opts = {}

require('lazy').setup(plugins, opts)
