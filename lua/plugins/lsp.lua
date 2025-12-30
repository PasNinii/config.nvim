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
      },
    },
  },
}
