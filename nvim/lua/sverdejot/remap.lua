-- default vim remaps
vim.g.mapleader = " "

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- pane navigation
vim.keymap.set("n", "<C-Left>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Navigate left" })
vim.keymap.set("n", "<C-Down>", "<cmd>TmuxNavigateDown<cr>", { desc = "Navigate down" })
vim.keymap.set("n", "<C-Up>", "<cmd>TmuxNavigateUp<cr>", { desc = "Navigate up" })
vim.keymap.set("n", "<C-Right>", "<cmd>TmuxNavigateRight<cr>", { desc = "Navigate right" })

-- lsp autosuggestions
vim.keymap.set("i", "<C-Y>", "<C-y>")
