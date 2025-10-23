-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>e", ":Ex<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-n>", vim.cmd.cnext, { desc = "Next Quickfix" })
vim.keymap.set("n", "<C-p>", vim.cmd.cprev, { desc = "Previous Quickfix" })

-- Copilot
vim.keymap.set("n", "<leader>am", ":CopilotChatModels<CR>", { desc = "Open Copilot Git" })
