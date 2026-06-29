return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      servers = {
        angularls = {},
        cssls = {},
        css_variables = {},
        dprint = {},
        html = {},
        ts_ls = {},
        -- python: pyright matches CI (repo uses pyright, [tool.pyright] in spindjango/pyproject.toml);
        -- ruff LSP provides lint diagnostics / code actions consistent with ruff.toml
        pyright = {},
        ruff = {},
      },
      inlay_hints = { enabled = false },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "angular",
        "bash",
        "html",
        "css",
        "scss",
        "javascript",
        "json",
        "json5",
        "lua",
        "typescript",
        "python",
        "vim",
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "prettier", -- CI formatter for html/css/scss/yaml; was missing from PATH and Mason
        "ruff", -- python lint + format (ruff.toml)
        "pyright", -- python type-check LSP (matches CI pyright)
      },
    },
  },
}
