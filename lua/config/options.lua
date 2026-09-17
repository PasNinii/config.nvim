-- Upstream pyright exposes auto-import only through completion; the quick fix on an
-- undefined name is a Pylance feature that basedpyright reimplements. LazyVim's python
-- extra reads this to pick the server and disable the other one.
vim.g.lazyvim_python_lsp = "basedpyright"

-- Snacks animations
-- Set to `false` to globally disable all snacks animations
vim.g.snacks_animate = false

-- octo.nvim's keymaps are all <localleader>-based; align localleader with leader (space)
-- so they fire on space (e.g. <localleader><space> = space-space to toggle viewed)
vim.g.maplocalleader = " "

-- change cursor
-- The "a:" entry comes last so its blink settings win over every mode above.
vim.opt.guicursor = table.concat({
  "n-c-sm:block-CursorNormal",
  "v-ve:block-CursorVisual",
  "i-ci:block-CursorInsert",
  "r-cr:hor20-CursorInsert",
  "o:hor50-CursorNormal",
  "t:block-CursorInsert",
  "a:blinkwait0-blinkoff0-blinkon0",
}, ",")

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

-- nvim reads `htmlangular` off the first 40 lines of a template's content
-- (@if/@for/*ngIf/ng-template/ng-content) and keeps the filename rule disabled
-- upstream, so a template opening on plain markup lands on `html`: the html server
-- attaches instead of angularls and the html parser highlights control-flow blocks
-- as text. A component's template sits beside the .ts that declares it, which holds
-- for both `foo.component.html` and the CLI's `foo.html`, and leaves src/index.html
-- on `html`. The angular.json/nx.json check keeps the rule inside Angular workspaces.
local function angular_template(path)
  if not vim.fs.root(path, { "angular.json", "nx.json" }) then
    return nil
  end
  return vim.uv.fs_stat((path:gsub("%.html$", ".ts"))) and "htmlangular" or nil
end

vim.filetype.add({
  pattern = {
    [".*%.html"] = angular_template,
  },
})

-- nvim-treesitter registers each parser under the filetype it is named after, so
-- `htmlangular` buffers parse as html until the angular parser claims them.
vim.treesitter.language.register("angular", "htmlangular")

vim.opt.termguicolors = true

-- Loading a colorscheme clears every highlight group, and LazyVim picks one
-- after this file runs, so the cursor groups have to be re-declared each time.
local function set_cursor_hl()
  vim.api.nvim_set_hl(0, "CursorNormal", { fg = "#D9E0EE", bg = "#E28C8C" })
  vim.api.nvim_set_hl(0, "CursorInsert", { fg = "#D9E0EE", bg = "#8CAAEE" })
  vim.api.nvim_set_hl(0, "CursorVisual", { fg = "#D9E0EE", bg = "#E5C890" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("cursor_mode_colors", { clear = true }),
  callback = set_cursor_hl,
})
set_cursor_hl()
