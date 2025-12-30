-- Snacks animations
-- Set to `false` to globally disable all snacks animations
vim.g.snacks_animate = false

-- Configure cursor to be a block in all modes with different colors
vim.opt.guicursor = {
  "n-c:block-Cursor",                -- Normal, Command: block cursor
  "v:block-CursorVisual",            -- Visual: block cursor
  "i-ci-ve:block-CursorInsert",      -- Insert: block cursor
  "r-cr:block-CursorReplace",        -- Replace: block cursor
  "a:blinkwait700-blinkoff400-blinkon250", -- Blink settings for all modes
}

-- Define colors for cursor in different modes
vim.api.nvim_set_hl(0, "Cursor", { fg = "#1e1e2e", bg = "#cdd6f4" })        -- Normal mode: light blue
vim.api.nvim_set_hl(0, "CursorVisual", { fg = "#1e1e2e", bg = "#89b4fa" })  -- Visual mode: blue
vim.api.nvim_set_hl(0, "CursorInsert", { fg = "#1e1e2e", bg = "#a6e3a1" })  -- Insert mode: green
vim.api.nvim_set_hl(0, "CursorReplace", { fg = "#1e1e2e", bg = "#f38ba8" }) -- Replace mode: red
