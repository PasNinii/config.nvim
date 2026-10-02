return {
  {
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
  },
  {
    "folke/which-key.nvim",
    opts = {
      -- which-key starts on every ModeChanged into visual / operator-pending, reads the
      -- next key with getchar and re-feeds it with the "t" flag; multicursor then treats
      -- that key as plugin-fed input and skips replaying it on the other cursors
      -- (viw<C-d><C-d>d deletes at the main cursor only, dw / cgn corrupt the rest).
      triggers = {
        { "<auto>", mode = "n" },
        { "<leader>", mode = "x" },
      },
    },
  },
}
