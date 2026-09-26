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
        -- lspconfig lists python/markdown/rust among dprint's filetypes and declares no
        -- workspace requirement, so the client starts single-file in every repo; a root
        -- holding its config is what gives the server anything to answer with.
        dprint = { workspace_required = true },
        html = {},
        -- python: basedpyright shares pyright's engine and reads [tool.pyright] in
        -- spindjango/pyproject.toml, so diagnostics stay in step with CI;
        -- ruff LSP provides lint diagnostics / code actions consistent with ruff.toml
        -- spindjango/ and scripts/ each hold a pyproject.toml, so the server roots itself
        -- on whichever one owns the file and reads that project's config and venv.
        basedpyright = {
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
            basedpyright = {
              analysis = {
                autoImportCompletions = true,
                -- basedpyright ships "recommended" as its default strictness.
                typeCheckingMode = "standard",
              },
            },
          },
        },
        -- ruff's enabled rule set comes from the binary as much as from ruff.toml,
        -- so start the version the project pins. `cmd` is a function so it resolves
        -- once per root, for the project that owns the file rather than for whichever
        -- directory nvim happened to start in.
        ruff = {
          cmd = function(dispatchers, config)
            local root = config and config.root_dir or vim.fn.getcwd()
            local bin = python.venv_bin(root, "ruff") or "ruff"
            return vim.lsp.rpc.start({ bin, "server" }, dispatchers)
          end,
        },
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
        "basedpyright", -- python type-check LSP (pyright engine + add-import code actions)
        "debugpy", -- python DAP adapter; nvim-dap-python's `debugpy-adapter` wrapper
      },
    },
  },
}
