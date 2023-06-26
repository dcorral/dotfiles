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
  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
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

