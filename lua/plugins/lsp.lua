local python = require("util.python")

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
        -- angularls also attaches to plain .ts files in Angular projects and
        -- answers the same requests (references, hover, definitions), so
        -- results show up twice. Skip ts_ls there and let angularls cover it.
        ts_ls = {
          root_dir = function(bufnr, on_dir)
            if vim.fs.root(bufnr, { "angular.json", "nx.json" }) then
              return
            end
            -- lockfile > .git > package.json > cwd: a lockfile-less scratch
            -- project (e.g. a fresh `bun init` with no .git yet) otherwise
            -- falls back to getcwd(), which can miss node_modules/typescript
            -- entirely and make ts_ls use its own bundled TS version instead.
            local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
            on_dir(vim.fs.root(bufnr, { root_markers, { ".git" }, { "package.json" } }) or vim.fn.getcwd())
          end,
        },
        -- python: pyright matches CI (repo uses pyright, [tool.pyright] in spindjango/pyproject.toml);
        -- ruff LSP provides lint diagnostics / code actions consistent with ruff.toml
        -- spindjango/ and scripts/ each hold a pyproject.toml, so pyright roots itself
        -- on whichever one owns the file and reads that project's [tool.pyright] and venv.
        pyright = {
          -- The client captures config.settings by reference before before_init runs and
          -- sends that same table, so the interpreter has to be written into it in place.
          before_init = function(_, config)
            local py = python.venv_bin(config.root_dir, "python")
            if py then
              config.settings = config.settings or {}
              config.settings.python = vim.tbl_deep_extend("force", config.settings.python or {}, {
                pythonPath = py,
              })
            end
          end,
          settings = {
            python = {
              analysis = {
                autoImportCompletions = true,
              },
            },
          },
        },
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
