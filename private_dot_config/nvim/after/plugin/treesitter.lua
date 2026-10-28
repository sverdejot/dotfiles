local parsers = {
	"c", "lua", "vim", "vimdoc", "query", "go", "gomod", "gosum", "gowork", "dockerfile",
	"gitignore", "json", "proto", "sql", "yaml", "markdown", "markdown_inline", "python",
	"typescript", "tsx", "javascript", "bash", "gleam", "elixir", "templ",
}
require("nvim-treesitter").install(parsers)

-- highlight + indent for any filetype with an available parser (installs missing ones on demand)
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("UserTreesitter", {}),
	callback = function(ev)
		local lang = vim.treesitter.language.get_lang(ev.match)
		if not lang then return end
		if not pcall(vim.treesitter.start, ev.buf, lang) then
			if vim.tbl_contains(require("nvim-treesitter").get_available(), lang) then
				require("nvim-treesitter").install(lang):await(function()
					pcall(vim.treesitter.start, ev.buf, lang)
				end)
			end
			return
		end
		vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

-- textobjects
require("nvim-treesitter-textobjects").setup({
	select = { lookahead = true },
	move = { set_jumps = true },
})

local select = require("nvim-treesitter-textobjects.select")
for key, query in pairs({
	af = "@function.outer", ["if"] = "@function.inner",
	ac = "@class.outer", ic = "@class.inner",
	aa = "@parameter.outer", ia = "@parameter.inner",
}) do
	vim.keymap.set({ "x", "o" }, key, function() select.select_textobject(query, "textobjects") end)
end

local move = require("nvim-treesitter-textobjects.move")
local moves = {
	["]f"] = { move.goto_next_start, "@function.outer" },
	["]c"] = { move.goto_next_start, "@class.outer" },
	["]F"] = { move.goto_next_end, "@function.outer" },
	["]C"] = { move.goto_next_end, "@class.outer" },
	["[f"] = { move.goto_previous_start, "@function.outer" },
	["[c"] = { move.goto_previous_start, "@class.outer" },
	["[F"] = { move.goto_previous_end, "@function.outer" },
	["[C"] = { move.goto_previous_end, "@class.outer" },
}
for key, m in pairs(moves) do
	vim.keymap.set({ "n", "x", "o" }, key, function() m[1](m[2], "textobjects") end)
end

local swap = require("nvim-treesitter-textobjects.swap")
vim.keymap.set("n", "<leader>a", function() swap.swap_next("@parameter.inner") end)
vim.keymap.set("n", "<leader>A", function() swap.swap_previous("@parameter.inner") end)
