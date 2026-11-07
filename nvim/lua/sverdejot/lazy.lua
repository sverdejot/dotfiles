local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Treesitter (main branch: parsers compiled with the tree-sitter CLI)
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
			{
				"nvim-treesitter/nvim-treesitter-context",
				opts = { enable = true, mode = "topline", line_numbers = true },
			},
		},
	},

	-- Picker (replaces telescope)
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
		config = function(_, opts)
			local fzf = require("fzf-lua")
			fzf.setup(opts)
			fzf.register_ui_select()
		end,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
	},

	-- Colorscheme
	{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true },

	{ "mbbill/undotree" },

	-- LSP: servers installed by mason, configs from nvim-lspconfig, enabled natively (see after/plugin/lsp.lua)
	{ "mason-org/mason.nvim", opts = {} },
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = { "gopls", "templ" },
			automatic_enable = false, -- enabled explicitly in after/plugin/lsp.lua
		},
	},
	{ "neovim/nvim-lspconfig" },

	-- Completion (replaces nvim-cmp + LuaSnip)
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = { "rafamadriz/friendly-snippets" },
		opts = {
			keymap = {
				preset = "default", -- <C-y> accept, <C-n>/<C-p> navigate, <C-e> abort
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
			},
			appearance = { nerd_font_variant = "mono" },
			completion = {
				menu = { border = "rounded" },
				documentation = { auto_show = true, window = { border = "rounded" } },
			},
			signature = { enabled = true, window = { border = "rounded" } },
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
	},

	{ "echasnovski/mini.pairs", opts = {} },

	{ "christoomey/vim-tmux-navigator", lazy = false },

	-- Git
	{ "tpope/vim-fugitive" },
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			on_attach = function(buf)
				local gs = require("gitsigns")
				local o = { buffer = buf }
				vim.keymap.set("n", "]h", function() gs.nav_hunk("next") end, o)
				vim.keymap.set("n", "[h", function() gs.nav_hunk("prev") end, o)
				vim.keymap.set("n", "<leader>hs", gs.stage_hunk, o)
				vim.keymap.set("n", "<leader>hr", gs.reset_hunk, o)
				vim.keymap.set("n", "<leader>hp", gs.preview_hunk, o)
				vim.keymap.set("n", "<leader>hb", function() gs.blame_line({ full = true }) end, o)
			end,
		},
	},

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
	},

	{ "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.dashboard").config)
		end,
	},

	{
		"romgrk/barbar.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "lewis6991/gitsigns.nvim" },
		init = function() vim.g.barbar_auto_setup = false end,
		config = function()
			require("barbar").setup({
				clickable = true,
				tabpages = false,
				insert_at_end = true,
				icons = {
					button = "",
					buffer_index = true,
					filetype = { enabled = true },
					visible = { modified = { buffer_number = false } },
					gitsigns = {
						added = { enabled = true, icon = "+" },
						changed = { enabled = true, icon = "~" },
						deleted = { enabled = true, icon = "-" },
					},
				},
			})

			local map = vim.keymap.set
			local opts = { silent = true }
			map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", opts)
			map("n", "<A-.>", "<Cmd>BufferNext<CR>", opts)
			map("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", opts)
			map("n", "<A->>", "<Cmd>BufferMoveNext<CR>", opts)
			for i = 1, 9 do
				map("n", "<A-" .. i .. ">", "<Cmd>BufferGoto " .. i .. "<CR>", opts)
			end
			map("n", "<A-0>", "<Cmd>BufferLast<CR>", opts)
			map("n", "<A-p>", "<Cmd>BufferPin<CR>", opts)
			map("n", "<A-c>", "<Cmd>BufferClose<CR>", opts)
			map("n", "<A-b>", "<Cmd>BufferCloseAllButCurrent<CR>", opts)
		end,
	},

	-- Formatting
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports", "gofmt" },
				python = { "ruff_format" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
			},
			format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
		},
	},

	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "lewis6991/async.nvim", "nvim-treesitter/nvim-treesitter" },
		opts = {},
	},

	-- Debugging
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"mason-org/mason.nvim",
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")

			ui.setup()
			require("dap-go").setup()
			require("nvim-dap-virtual-text").setup({})

			vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<space>gb", dap.run_to_cursor)
			vim.keymap.set("n", "<space>?", function() ui.eval(nil, { enter = true }) end)
			vim.keymap.set("n", "<space>cc", dap.continue)
			vim.keymap.set("n", "<space>si", dap.step_into)
			vim.keymap.set("n", "<space>so", dap.step_over)
			vim.keymap.set("n", "<space>st", dap.step_out)
			vim.keymap.set("n", "<space>sb", dap.step_back)
			vim.keymap.set("n", "<space>sr", dap.restart)

			dap.listeners.before.attach.dapui_config = ui.open
			dap.listeners.before.launch.dapui_config = ui.open
			dap.listeners.before.event_terminated.dapui_config = ui.close
			dap.listeners.before.event_exited.dapui_config = ui.close
		end,
	},
}, {
	checker = { enabled = true, notify = false }, -- check for plugin updates in background
	change_detection = { notify = false },
})
