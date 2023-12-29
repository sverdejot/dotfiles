vim.g.mapleader = " "
-- lazy.nvim config
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- default numbering config
vim.wo.number = true
vim.wo.relativenumber = true

-- plugin setup
require('lazy').setup({
	{'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'},
	{'nvim-telescope/telescope.nvim', tag = '0.1.5',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{'nvim-neo-tree/neo-tree.nvim', branch = "v3.x",
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-tree/nvim-web-devicons',
			'MunifTanjim/nui.nvim',
		}
	}
})

-- telescope settings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})

-- neotree settings
local tree = require('neo-tree.command')
vim.keymap.set('n', '<leader>e', ':Neotree toggle reveal $PWD<CR>', { remap = true, silent = true })
vim.keymap.set('n', '<leader>E', ':Neotree toggle reveal ' ..  vim.loop.cwd() .. '<CR>', { remap = true, silent = true})
