return {
  "folke/tokyonight.nvim",
  opts = {
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
    -- Stock diff colors are loud: DiffText is solid blue7 and Octo paints changed
    -- words white-on-#238636/#da3633. Tint lines lightly, words a bit more, and keep
    -- syntax fg everywhere. Octo defines its groups with `default = true`, so these win.
    on_highlights = function(hl, c)
      local blend = require("tokyonight.util").blend_bg
      hl.DiffAdd = { bg = blend(c.green2, 0.12) }
      hl.DiffDelete = { bg = blend(c.red1, 0.12) }
      hl.DiffChange = { bg = blend(c.blue7, 0.10) }
      hl.DiffText = { bg = blend(c.blue7, 0.45) }
      hl.DiffviewDiffDeleteDim = { fg = c.fg_gutter } -- the ╱ filler, see diffview.lua
      hl.OctoReviewDiffAdd = { bg = blend(c.green2, 0.12) }
      hl.OctoReviewDiffDelete = { bg = blend(c.red1, 0.12) }
      hl.OctoReviewDiffAddText = { bg = blend(c.green2, 0.30) }
      hl.OctoReviewDiffDeleteText = { bg = blend(c.red1, 0.30) }
    end,
  },
}
