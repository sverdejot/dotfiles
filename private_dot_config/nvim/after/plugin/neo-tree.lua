-- neotree remaps
local tree = require('neo-tree.command')
vim.keymap.set('n', '<leader>e', ':Neotree toggle reveal $PWD<CR>', { remap = true, silent = true })
vim.keymap.set('n', '<leader>E', ':Neotree toggle reveal ' ..  vim.uv.cwd() .. '<CR>', { remap = true, silent = true})
