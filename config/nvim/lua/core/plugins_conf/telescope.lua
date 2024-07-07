local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pf', function()
    builtin.find_files({
        find_command = { 'rg', '--files', '--hidden', '--glob', '!.git/*' },
    })
end, {})

vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})

vim.keymap.set('n', '<leader>pd', function()
    builtin.diagnostics({
        attach_mappings = function(_, map)
            local function custom_action(prompt_bufnr)
                local selection = require('telescope.actions.state').get_selected_entry(prompt_bufnr)
                require('telescope.actions').close(prompt_bufnr)
                vim.api.nvim_win_set_cursor(0, {selection.lnum, 0})
                -- Print the diagnostic message for debugging
                print("Selected diagnostic message: " .. selection.value.text)
                -- Copy the diagnostic message to the system clipboard
                vim.fn.setreg('+', selection.value.text)
            end

            -- Map the custom action to <CR> in insert mode
            map('i', '<CR>', custom_action)

            -- Map the custom action to <CR> in normal mode
            map('n', '<CR>', custom_action)

            return true
        end,
    })
end, {})

