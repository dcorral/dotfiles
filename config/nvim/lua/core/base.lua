vim.g.mapleader = ' '
vim.g.coc_global_extensions = {
    "coc-css",
    "coc-tsserver",
    "coc-clangd",
    "coc-html",
    "coc-solidity",
    "coc-snippets",
    "coc-rust-analyzer",
    "coc-pyright",
    "coc-highlight",
    "coc-lists",
    "coc-emmet",
    "coc-tslint",
    "coc-eslint",
    "coc-lua"
}

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.o.background = "dark"

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.colorcolumn = "100"
vim.opt.mouse = ""

