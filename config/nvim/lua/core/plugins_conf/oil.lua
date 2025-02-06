require("oil").setup({
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    columns = {
        "icon"
    },
    view_options = {
        show_hidden = true
    }
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
