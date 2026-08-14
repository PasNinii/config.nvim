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
      -- nvim detects Angular templates as `htmlangular` (@if/@for/*ngIf/ng-template)
      html = { "prettier" },
      htmlangular = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      yaml = { "prettier" },
      -- ruff owns python; mirror CI order: fix -> organize imports -> format (see ruff.toml)
      python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
    },
    formatters = {
      -- An unused import on save is usually one being typed, so keep F401 out of the
      -- fixable set here; pre-commit still strips it (.vscode/ruff.toml does the same).
      ruff_fix = { append_args = { "--unfixable", "F401" } },
    },
  },
}
