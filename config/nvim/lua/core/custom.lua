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
