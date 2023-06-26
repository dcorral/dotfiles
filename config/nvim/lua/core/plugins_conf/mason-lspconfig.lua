local buildin = require("mason").setup()
require("mason-lspconfig").setup{
    ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "bashls",
        "clangd",
        "cssls",
        "dockerls",
        "emmet_ls",
        "eslint",
        "html",
        "jsonls",
        "pylsp",
        "pyright",
        "solc",
        "solidity",
        "sqlls",
        "tsserver",
        "yamlls",
        "cmake"
    },
    automatic_installation = false,
    handlers = nil,
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require("mason-lspconfig").setup_handlers {
    function (server_name)
        require("lspconfig")[server_name].setup {
            capabilities = capabilities
        }
    end,
}
