return {
  "stevearc/conform.nvim",
  -- @module "conform"
  -- @type conform.setupOpts
  opts = {
    formatters_by_ft = {
      -- dprint owns ts/js, json/json5, toml (see repo dprint.json + .pre-commit-config.yaml)
      javascript = { "dprint", "prettier" },
      typescript = { "dprint", "prettier" },
      json = { "dprint" },
      json5 = { "dprint" },
      toml = { "dprint" },
      -- prettier owns html/css/scss/yaml (see repo .prettierrc + .pre-commit-config.yaml)
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      yaml = { "prettier" },
      -- ruff owns python; mirror CI order: fix -> organize imports -> format (see ruff.toml)
      python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
    },
  },
}
