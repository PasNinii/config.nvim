return {
  "folke/noice.nvim",
  opts = {
    routes = {
      -- pyright emits an LSP progress token on every re-analysis, i.e. on each burst
      -- of typing, which noice renders bottom-right. Other servers keep their progress.
      {
        filter = {
          event = "lsp",
          kind = "progress",
          cond = function(message)
            return vim.tbl_get(message.opts, "progress", "client") == "pyright"
          end,
        },
        opts = { skip = true },
      },
    },
  },
}
