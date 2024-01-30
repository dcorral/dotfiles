-- Folds
vim.cmd([[
function! FoldLevel(lnum)
    return ( max([
        \     indent(prevnonblank(a:lnum)),
        \     indent(nextnonblank(a:lnum))
        \ ]) / getbufvar('.', '&tabstop', 1) )
endfunction
]])

vim.cmd([[
augroup remember_folds
  autocmd!
  autocmd BufWinLeave *.* mkview
  autocmd BufWinEnter *.* silent! loadview
augroup END
]])

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'FoldLevel(v:lnum)'
vim.opt.foldlevelstart = 99

-- Whitespaces
vim.cmd([[
augroup trailing_whitespace
  autocmd!
  autocmd ColorScheme * highlight ExtraWhitespace guibg=LightGoldenrod
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/
  autocmd BufWritePre * :%s/\s\+$//e
augroup END
]])

vim.cmd('match ExtraWhitespace /\\s\\+$/')

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = true
})

local session_file_path = "/tmp/nvim_session.vim"

function toggle_zoom()
  local current_win = vim.api.nvim_get_current_win()
  local all_wins = vim.api.nvim_list_wins()

  if #all_wins > 1 then
    -- Save the current session if more than one window is open
    vim.cmd("mksession! " .. session_file_path)

    -- Make the current window the only one on the screen
    vim.cmd("only")
  else
    -- If there is only one window, try restoring the session
    if vim.fn.filereadable(session_file_path) == 1 then
      vim.cmd("source " .. session_file_path)
    end
  end
end

local function replace_with_clipboard()
    -- Check if we're in visual mode and get the visual selection if so
    local mode = vim.fn.mode()
    local isVisual = mode == 'v' or mode == 'V' or mode == ''

    -- Temporarily allow modifications to the buffer
    vim.api.nvim_buf_set_option(0, 'modifiable', true)

    if isVisual then
        vim.cmd([[normal!  "_d]])
        vim.cmd([[normal! "+P]])     -- Paste the clipboard content
    else
        -- Replace the entire buffer content for non-visual modes
        vim.cmd([[%delete _]])     -- Delete all lines, storing them in the black hole register
        vim.cmd([[normal! "+P]])     -- Paste the clipboard content
    end

end

-- Map the function to <leader>m in normal and visual mode
vim.keymap.set('n', '<leader>m', replace_with_clipboard, { noremap = true, silent = true })
vim.keymap.set('x', '<leader>m', replace_with_clipboard, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>M', function()
    vim.cmd('%yank +')
end, { noremap = true, silent = true, desc = "Copy entire buffer to system clipboard" })

