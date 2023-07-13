local cmp = require('cmp')
local luasnip = require('luasnip')

-- html snippets in javascript and javascriptreact
luasnip.snippets = {
  html = {}
}
luasnip.snippets.javascript = luasnip.snippets.html
luasnip.snippets.javascriptreact = luasnip.snippets.html
luasnip.snippets.typescriptreact = luasnip.snippets.html

require("luasnip/loaders/from_vscode").load({include = {"html"}})
require("luasnip/loaders/from_vscode").lazy_load()
require('luasnip').filetype_extend("javascriptreact", { "html" })

local select_opts = { behavior = cmp.SelectBehavior.Replace }

cmp.setup({

    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },

    sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'buffer',  keyword_length = 3 },
        { name = 'luasnip', keyword_length = 2 }
    },

    window = {
        -- documentation = cmp.config.window.bordered()
    },

    completion = {
        completeopt = 'menu,menuone,noinsert'
    },

    formatting = {
        fields = { 'menu', 'abbr', 'kind' },
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = '[LSP]',
                luasnip = '[SNIP]',
                buffer = '[BUF]',
                path = '[PATH]',
            }
            item.menu = menu_icon[entry.source.name]
            return item
        end
    },

    mapping = {
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Tab>'] = cmp.mapping.confirm({ select = true, cmp.ConfirmBehavior.Replace }),
        ['<C-n>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item(select_opts)
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item(select_opts)
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
    }
})
