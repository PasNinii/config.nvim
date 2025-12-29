return {
  "stevearc/conform.nvim",
  -- @module "conform"
  -- @type conform.setupOpts
  opts = {
    formatters_by_ft = {
      javascript = { "dprint", "prettierd", "prettier", stop_after_first = true },
      typescript = { "dprint", "prettierd", "prettier", stop_after_first = true },
      html = { "dprint", "prettierd", "prettier", stop_after_first = true },
      css = { "dprint", "prettierd", "prettier", stop_after_first = true },
      scss = { "dprint", "prettierd", "prettier", stop_after_first = true },
      json = { "dprint", "prettierd", "prettier", stop_after_first = true },
      json5 = { "dprint", "prettierd", "prettier", stop_after_first = true },
    },
  },
}
