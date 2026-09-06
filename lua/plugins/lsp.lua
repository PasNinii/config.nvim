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
        -- mason-lspconfig enables every server installed in Mason unless it is excluded,
        -- so python-lsp-server sitting in Mason attaches to python buffers next to
        -- pyright + ruff and answers with its own black / pycodestyle / jedi results.
        pylsp = { enabled = false },
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
          -- lspconfig roots ruff on `.git`, which reaches every python repo; leaving
          -- on_dir uncalled keeps the client from starting where ruff has no config.
          root_dir = function(bufnr, on_dir)
            local root = python.ruff_root(vim.api.nvim_buf_get_name(bufnr))
            if root then
              on_dir(root)
            end
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
        "pyright", -- python type-check LSP (matches CI pyright)
        "debugpy", -- python DAP adapter; nvim-dap-python's `debugpy-adapter` wrapper
      },
    },
  },
}
