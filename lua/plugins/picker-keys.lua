-- Keep file search anchored to the directory where Neovim was launched.
return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader><space>", false },
      { "<leader>ff", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>fF", false },
    },
  },
}
