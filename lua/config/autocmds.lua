-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Jump between diff changes with gj/gk in any diff window (Diffview, fugitive, :diffthis).
-- LazyVim rebinds native ]c/[c (diff-change motions) to treesitter @class jumps as
-- buffer-local maps; that attach often wins inside Diffview before vim.wo.diff is set.
-- `:normal! ]c` ignores all mappings and always fires the built-in motion.
local diff_nav_group = vim.api.nvim_create_augroup("diff_nav_keys", { clear = true })

local function set_diff_nav_keys()
  local buf = vim.api.nvim_get_current_buf()
  if vim.wo.diff then
    vim.keymap.set("n", "gj", function() vim.cmd("normal! ]c") end, { buffer = buf, silent = true, desc = "Next diff change" })
    vim.keymap.set("n", "gk", function() vim.cmd("normal! [c") end, { buffer = buf, silent = true, desc = "Prev diff change" })
  else
    pcall(vim.keymap.del, "n", "gj", { buffer = buf })
    pcall(vim.keymap.del, "n", "gk", { buffer = buf })
  end
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
  group = diff_nav_group,
  callback = set_diff_nav_keys,
})

vim.api.nvim_create_autocmd("OptionSet", {
  group = diff_nav_group,
  pattern = "diff",
  callback = set_diff_nav_keys,
})
