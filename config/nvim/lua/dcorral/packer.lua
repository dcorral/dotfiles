vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.1',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use 'ellisonleao/gruvbox.nvim'
  use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use 'mbbill/undotree'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'

  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v2.x',
	  requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},             -- Required
		  {                                      -- Optional
			  'williamboman/mason.nvim',
			  run = function()
				  pcall(vim.cmd, 'MasonUpdate')
			  end,
	          },
		  {'williamboman/mason-lspconfig.nvim'}, -- Optional

		  -- Autocompletion
		  {'L3MON4D3/LuaSnip'},     -- Required
          use {
              'hrsh7th/nvim-cmp',
              config = function ()
                  require'cmp'.setup {
                      snippet = {
                          expand = function(args)
                              require'luasnip'.lsp_expand(args.body)
                          end
                      },

                      sources = {
                          { name = 'luasnip' },
                          -- more sources
                      },
                  }
              end
          },
		  {'hrsh7th/cmp-nvim-lsp'}, -- Required
          use { 'saadparwaiz1/cmp_luasnip' }
      }
  }
  use {
	  "williamboman/mason.nvim",
	  run = ":MasonUpdate" -- :MasonUpdate updates registry contents
  }
end)
