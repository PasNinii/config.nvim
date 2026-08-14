-- Snacks animations
-- Set to `false` to globally disable all snacks animations
vim.g.snacks_animate = false

-- octo.nvim's keymaps are all <localleader>-based; align localleader with leader (space)
-- so they fire on space (e.g. <localleader><space> = space-space to toggle viewed)
vim.g.maplocalleader = " "

-- An installed clipboard tool still fails silently when its display server is
-- out of reach, so mirror nvim's own gate (provider/clipboard.vim) and require
-- the matching display variable. OSC 52 hands the write to the host terminal
-- instead, which works in containers, over SSH, and from a tmux server whose
-- inherited $DISPLAY has gone stale.
local has_native_clipboard = vim.fn.executable("pbcopy") == 1
  or (vim.env.WAYLAND_DISPLAY ~= nil and vim.fn.executable("wl-copy") == 1)
  or (vim.env.DISPLAY ~= nil and (vim.fn.executable("xclip") == 1 or vim.fn.executable("xsel") == 1))
if not has_native_clipboard then
  local osc52 = require("vim.ui.clipboard.osc52")
  -- OSC 52 reads go unanswered through tmux, so paste replays the register
  -- nvim last wrote rather than querying the terminal and timing out.
  local function paste()
    return vim.split(vim.fn.getreg('"'), "\n")
  end
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end
