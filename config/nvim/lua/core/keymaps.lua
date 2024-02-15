vim.keymap.set('n', '<Esc>', ':noh<CR>')
vim.keymap.set("n", "<leader>pv", '<cmd>Dirbuf<CR>')
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)
vim.keymap.set("n", "<leader>gy", ":.GBrowse!<CR>")
vim.keymap.set("x", "<leader>gy", ":'<'>GBrowse!<CR>")
vim.keymap.set('n', '<C-w>o', [[<Cmd>lua toggle_zoom()<CR>]], { noremap = true, silent = true })


-- LSP
local opts = { noremap = true, silent = true }
local function format()
    if vim.bo.filetype == "solidity" then
        -- Save the current cursor position
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        -- Run 'forge fmt' silently and reload the buffer without prompting
        vim.cmd("silent !forge fmt %")
        vim.cmd('edit!') -- Force reload of the buffer
        -- Restore the cursor position
        vim.api.nvim_win_set_cursor(0, cursor_pos)
    else
        -- Use LSP formatting for other filetypes
        vim.lsp.buf.format({ async = true })
    end
end
-- Function to format using LSP or forge fmt for Solidity
vim.keymap.set('n', '<space>f', format, opts)

vim.keymap.set('n', '<space>d', vim.diagnostic.open_float)
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', function()
            vim.cmd("Telescope lsp_references")
            print('a')
        end, opts)
        -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        -- vim.keymap.set('n', '<space>f', function()
        --     vim.lsp.buf.format { async = true }
        -- end, opts)
    end,
})


-- AERIAL
vim.keymap.set('n', '<leader>h', '<cmd>AerialToggle<CR>')
