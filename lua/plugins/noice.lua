return {
  "folke/noice.nvim",
  opts = {
    -- basedpyright emits a progress token on every re-analysis, i.e. on each burst of
    -- typing; diagnostics already show when a server is done, so the progress view is noise.
    lsp = { progress = { enabled = false } },
  },
}
