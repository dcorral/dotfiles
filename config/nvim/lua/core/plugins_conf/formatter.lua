local conform = require("conform")

-- Initial setup
conform.setup({
    formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
    },
})

-- Global variable to control format on save
vim.g.format_on_save = true

-- Function to toggle format on save
function ToggleFormatOnSave()
    vim.g.format_on_save = not vim.g.format_on_save
    print("Format on save: " .. (vim.g.format_on_save and "enabled" or "disabled"))
end

-- Keybinding to toggle format on save
vim.keymap.set('n', '<leader>ts', ToggleFormatOnSave, { desc = "Toggle format on save" })

-- Keybinding for manual formatting
vim.keymap.set({ "n", "v" }, "<leader>f", function()
    conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
    })
end, { desc = "Format file or range (in visual mode)" })

-- Autocommand to format on save if enabled
vim.api.nvim_exec([[
    augroup FormatAutogroup
        autocmd!
        autocmd BufWritePre * lua if vim.g.format_on_save then require('conform').format({ lsp_fallback = true, async = false, timeout_ms = 500 }) end
    augroup END
]], false)
