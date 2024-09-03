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
require('lazy').setup({
	{
		'nvim-treesitter/nvim-treesitter', 
		run = ':TSUpdate',
		build = ':TSUpdate',
		 dependencies = {
        {"nvim-treesitter/nvim-treesitter-textobjects"}, -- Syntax aware text-objects
        {
            "nvim-treesitter/nvim-treesitter-context", -- Show code context
            opts = {enable = true, mode = "topline", line_numbers = true}
        }
    },
	},
	{'nvim-telescope/telescope.nvim', tag = '0.1.5',

	dependencies = { 
		'nvim-lua/plenary.nvim' 
	}
},
{'nvim-neo-tree/neo-tree.nvim', branch = "v3.x",
dependencies = {
	'nvim-lua/plenary.nvim',
	'nvim-tree/nvim-web-devicons',
	'MunifTanjim/nui.nvim',
}
	},
	{ 'codingpotions/codely-vim-theme' },
	{ 'mbbill/undotree' },
	{'sainnhe/gruvbox-material'},
	{
		'williamboman/mason.nvim',
		opts = {
			ensure_installed = {
				'gopls',
				'templ',
			}
		}
	},
	{'williamboman/mason-lspconfig.nvim'},
	{'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
	{'neovim/nvim-lspconfig'},
	{'hrsh7th/cmp-nvim-lsp'},
	{'hrsh7th/nvim-cmp'},
	{'L3MON4D3/LuaSnip'},
	{'echasnovski/mini.pairs'},
	{'ellisonleao/gruvbox.nvim', config = true},
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
	{ 'tpope/vim-fugitive' },
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' }
	},
	{
		'goolord/alpha-nvim', 
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require('alpha').setup(require('alpha.themes.dashboard').config)
		end
	},
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons", -- patched fonts support 
			"lewis6991/gitsigns.nvim" -- display git status
		},
		init = function() vim.g.barbar_auto_setup = false end,
		config = function()
			local barbar = require("barbar")

			barbar.setup({
				clickable = true, -- Enables/disables clickable tabs
				tabpages = false, -- Enable/disables current/total tabpages indicator (top right corner)
				insert_at_end = true,
				icons = {
					button = "",
					buffer_index = true,
					filetype = {enabled = true},
					visible = {modified = {buffer_number = false}},
					gitsigns = {
						added = {enabled = true, icon = "+"},
						changed = {enabled = true, icon = "~"},
						deleted = {enabled = true, icon = "-"}
					}
				}
			})

			-- key maps

			local map = vim.api.nvim_set_keymap
			local opts = {noremap = true, silent = true}

			-- Move to previous/next
			map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", opts)
			map("n", "<A-.>", "<Cmd>BufferNext<CR>", opts)
			-- Re-order to previous/next
			map("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", opts)
			map("n", "<A->>", "<Cmd>BufferMoveNext<CR>", opts)
			-- Goto buffer in position...
			map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opts)
			map("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opts)
			map("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opts)
			map("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opts)
			map("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opts)
			map("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opts)
			map("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opts)
			map("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opts)
			map("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opts)
			map("n", "<A-0>", "<Cmd>BufferLast<CR>", opts)
			-- Pin/unpin buffer
			map("n", "<A-p>", "<Cmd>BufferPin<CR>", opts)
			-- Close buffer
			map("n", "<A-c>", "<Cmd>BufferClose<CR>", opts)
			map("n", "<A-b>", "<Cmd>BufferCloseAllButCurrent<CR>", opts)
		end
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- cmp_nvim_lsp
			"neovim/nvim-lspconfig", -- lspconfig
			"onsails/lspkind-nvim", -- lspkind (VS pictograms)
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = "make install_jsregexp",
				dependencies = {"rafamadriz/friendly-snippets"}, -- Snippets
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
					-- https://github.com/rafamadriz/friendly-snippets/blob/main/snippets/go.json
				end
			}, {"saadparwaiz1/cmp_luasnip", enabled = true}
		},
		config = function()
			local luasnip = require("luasnip")
			local types = require("luasnip.util.types")

			-- Display virtual text to indicate snippet has more nodes
			luasnip.config.setup({
				ext_opts = {
					[types.choiceNode] = {
						active = {virt_text = {{"⇥", "GruvboxRed"}}}
					},
					[types.insertNode] = {
						active = {virt_text = {{"⇥", "GruvboxBlue"}}}
					}
				}
			})
		end
	},
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup()
    end,
  },
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require "dap"
			local ui = require "dapui"

			require("dapui").setup()
			require("dap-go").setup()

			vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<space>gb", dap.run_to_cursor)
			vim.keymap.set("n", "<space>?", function()
				require("dapui").eval(nil, { enter = true})
			end)

			vim.keymap.set("n", "<space>cc", dap.continue)
			vim.keymap.set("n", "<space>si", dap.step_into)
			vim.keymap.set("n", "<space>so", dap.step_over)
			vim.keymap.set("n", "<space>st", dap.step_out)
			vim.keymap.set("n", "<space>sb", dap.step_back)
			vim.keymap.set("n", "<space>sr", dap.restart)

			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
		end
	},
})
