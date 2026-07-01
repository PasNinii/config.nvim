-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>e", ":Ex<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-n>", vim.cmd.cnext, { desc = "Next Quickfix" })
vim.keymap.set("n", "<C-p>", vim.cmd.cprev, { desc = "Previous Quickfix" })

-- tabs: LazyVim's default <leader><tab>... chord is clunky; <leader>t was free.
-- <A-h>/<A-l> mirror the existing <S-h>/<S-l> buffer-cycle keys (same h/l keys,
-- Alt instead of Shift) so they stay put on AZERTY, unlike bracket keys.
vim.keymap.set("n", "<A-l>", vim.cmd.tabnext, { desc = "Next Tab" })
vim.keymap.set("n", "<A-h>", vim.cmd.tabprevious, { desc = "Previous Tab" })
vim.keymap.set("n", "<leader>tn", vim.cmd.tabnew, { desc = "New Tab" })
vim.keymap.set("n", "<leader>tc", vim.cmd.tabclose, { desc = "Close Tab" })
vim.keymap.set("n", "<leader>to", vim.cmd.tabonly, { desc = "Close Other Tabs" })
vim.keymap.set("n", "<leader>tf", vim.cmd.tabfirst, { desc = "First Tab" })
vim.keymap.set("n", "<leader>tl", vim.cmd.tablast, { desc = "Last Tab" })
