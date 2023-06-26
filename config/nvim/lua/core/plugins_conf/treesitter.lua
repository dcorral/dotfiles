require'nvim-treesitter.configs'.setup {
  ensure_installed = {
      "javascript", 
      "typescript", 
      "cpp", 
      "rust", 
      "python",
      "bash",
      "make",
      "markdown",
      "yaml",
      "toml",
      "json",
      "html",
      "css",
      "scss", 
      "c",
      "lua", 
      "vim", 
      "vimdoc", 
      "query" 
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  }
}

