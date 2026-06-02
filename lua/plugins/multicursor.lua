return {
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "VeryLazy",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",
        ["Find Subword Under"] = "<C-d>",
        ["Add Cursor Down"] = "<C-A-Down>",
        ["Add Cursor Up"] = "<C-A-Up>",
        ["Select All"] = "<C-S-l>",
      }
      vim.g.VM_theme = "iceblue"
      vim.g.VM_silent_exit = 1
    end,
  },
}
