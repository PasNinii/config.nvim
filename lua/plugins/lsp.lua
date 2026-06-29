-- Point pyright at the project's virtualenv interpreter. Opening nvim above the
-- Django subdir (e.g. /app/spinapp) leaves pyright on the bare $PATH python,
-- which lacks the deps -> "import could not be resolved". Find a venv at or above
-- root_dir and feed its python to pyright explicitly. spindjango sets
-- UV_PROJECT_ENVIRONMENT=.venv_container, so that name comes first.
local venv_dirs = { ".venv_container", ".venv", "venv", "env" }
local function venv_python(root_dir)
  if not root_dir then
    return nil
  end
  for _, name in ipairs(venv_dirs) do
    local dir = vim.fs.find(name, { path = root_dir, upward = true, type = "directory" })[1]
    if dir then
      local py = dir .. "/bin/python"
      if vim.fn.executable(py) == 1 then
        return py
      end
    end
  end
  return nil
end

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
        pyright = {
          before_init = function(_, config)
            local py = venv_python(config.root_dir)
            if py then
              config.settings = config.settings or {}
              config.settings.python = vim.tbl_deep_extend("force", config.settings.python or {}, {
                pythonPath = py,
              })
            end
          end,
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
