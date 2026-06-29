-- Snacks animations
-- Set to `false` to globally disable all snacks animations
vim.g.snacks_animate = false

-- octo.nvim's keymaps are all <localleader>-based; align localleader with leader (space)
-- so they fire on space (e.g. <localleader><space> = space-space to toggle viewed)
vim.g.maplocalleader = " "

-- When no native clipboard tool is reachable (containers, bare SSH) fall back to
-- OSC 52: nvim emits an escape sequence the host terminal turns into a clipboard
-- write, so yanks reach the host clipboard without xclip/wl-copy/pbcopy.
local has_native_clipboard = vim.fn.executable("pbcopy") == 1
  or vim.fn.executable("wl-copy") == 1
  or vim.fn.executable("xclip") == 1
  or vim.fn.executable("xsel") == 1
if not has_native_clipboard then
  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
  }
end
