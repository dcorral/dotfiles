local cmp = require('cmp')
local luasnip = require('luasnip')

local select_opts = { behavior = cmp.SelectBehavior.Replace }

-- local has_words_before = function()
--     local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
--     return col ~= 0 and
--         vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(
--             col, col):match("%s") == nil
-- end

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
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item(select_opts)
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<C-j>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.scroll_docs(4)
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<C-k>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.scroll_docs(-4)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }
})
