return {
  { "folke/flash.nvim", enabled = false },
  -- util.python.venv_bin already resolves the interpreter; this one also wants `fd`.
  { "linux-cultist/venv-selector.nvim", enabled = false },

  {
    "folke/snacks.nvim",
    opts = {
      notifier = { enabled = false },
      explorer = { enabled = false },
      -- notify = { enabled = false },
      -- scroll = { enabled = false },
      -- animate = { enabled = false },
      -- terminal = { enabled = false },
      -- picker = { enabled = false },
    },
  },
}
