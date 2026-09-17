local python = require("util.python")

-- ruff's enabled rule set and formatting come from the binary as much as from
-- ruff.toml, so run the version the project pins instead of Mason's copy.
local function ruff_cmd(_, ctx)
  return python.venv_bin(ctx.dirname, "ruff") or "ruff"
end

-- A project that never configured ruff gets ruff's defaults applied to every buffer
-- it writes, so gate the whole chain on the project having opted in.
local function has_ruff_config(_, ctx)
  return python.ruff_root(ctx.filename) ~= nil
end

return {
  "stevearc/conform.nvim",
  -- @module "conform"
  -- @type conform.setupOpts
  opts = {
    formatters_by_ft = {
      -- dprint owns ts/js, json/json5, toml (see repo dprint.json + .pre-commit-config.yaml);
      -- prettier covers the same filetypes in repos with no dprint.json, and
      -- stop_after_first keeps the second one from reformatting the first one's output.
      javascript = { "dprint", "prettier", stop_after_first = true },
      javascriptreact = { "dprint", "prettier", stop_after_first = true },
      typescript = { "dprint", "prettier", stop_after_first = true },
      typescriptreact = { "dprint", "prettier", stop_after_first = true },
      json = { "dprint", "prettier", stop_after_first = true },
      jsonc = { "dprint", "prettier", stop_after_first = true },
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
      -- conform picks the first *available* formatter in the chain, and dprint on $PATH
      -- counts as available everywhere; a root holding its config is what makes it apply.
      dprint = { require_cwd = true },
      -- An unused import on save is usually one being typed, so keep F401 out of the
      -- fixable set here; pre-commit still strips it (.vscode/ruff.toml does the same).
      ruff_fix = { command = ruff_cmd, condition = has_ruff_config, append_args = { "--unfixable", "F401" } },
      ruff_organize_imports = { command = ruff_cmd, condition = has_ruff_config },
      ruff_format = { command = ruff_cmd, condition = has_ruff_config },
    },
  },
}
