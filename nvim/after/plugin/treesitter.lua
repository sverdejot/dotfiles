require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "go", "dockerfile", "gitignore", "gomod", "gosum", "gowork", "json", "proto", "sql", "yaml" },
	indent = {enable = true},
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
	textobjects = {select = {enable = true, lookahead = true}},
}
