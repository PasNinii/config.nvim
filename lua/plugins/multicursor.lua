return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  event = "VeryLazy",
  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()
    -- Visual only: normal <C-d> keeps its half-page scroll, so start with viw<C-d>.
    vim.keymap.set("x", "<C-d>", function()
      mc.matchAddCursor(1)
    end, { desc = "Add next match cursor" })
    vim.keymap.set({ "n", "x" }, "<A-Down>", function()
      mc.lineAddCursor(1)
    end, { desc = "Add cursor below" })
    vim.keymap.set({ "n", "x" }, "<A-Up>", function()
      mc.lineAddCursor(-1)
    end, { desc = "Add cursor above" })
    mc.addKeymapLayer(function(set)
      set("x", "<C-q>", function()
        mc.matchSkipCursor(1)
      end, { desc = "Skip match" })
      set("n", "<Esc>", function()
        if mc.cursorsEnabled() then
          mc.clearCursors()
        else
          mc.enableCursors()
        end
      end)
    end)
  end,
}
