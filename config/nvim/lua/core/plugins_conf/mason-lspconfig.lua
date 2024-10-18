local buildin = require("mason").setup()
require("mason-lspconfig").setup {
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
        "solidity",
        "sqlls",
        "tsserver",
        "yamlls",
        "cmake"
    },
    automatic_installation = false,
    handlers = nil,
}

local on_attach = function(client, bufnr)
    if client.name == "solidity" then
        client.server_capabilities.renameProvider = false
    end
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require("mason-lspconfig").setup_handlers {
    function(server_name)
        require("lspconfig")[server_name].setup {
            capabilities = capabilities
        }
        require("lspconfig")['emmet_ls'].setup({
            -- on_attach = on_attach,
            filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte",
                "pug", "typescriptreact", "vue" },
            init_options = {
                html = {
                    options = {
                        -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                        ["bem.enabled"] = true,
                    },
                },
            }
        })
        require("lspconfig")['solidity'].setup({
            on_attach = on_attach,
            cmd = { 'nomicfoundation-solidity-language-server', '--stdio' },
            filetypes = { 'solidity' },
            root_dir = require("lspconfig.util").find_git_ancestor,
            single_file_support = true,
        })
    end,
}
