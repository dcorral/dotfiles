local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.ensure_installed({
	'clangd',
	'tsserver',
	'bashls',
	'rust_analyzer',
	'cmake',
	'html',
	'pylsp',
	'emmet_ls',
	'solc',
	'solidity'
})

lsp.setup()
