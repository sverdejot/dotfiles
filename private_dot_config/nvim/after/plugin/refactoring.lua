-- uses vim.ui.select (rendered by fzf-lua)
vim.keymap.set({ "n", "x" }, "<leader>rr", function() require("refactoring").select_refactor() end)
