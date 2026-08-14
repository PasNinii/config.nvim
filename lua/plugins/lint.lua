local python = require("util.python")

-- The repo's .flake8 ignores every built-in check (ruff covers them) and keeps flake8
-- around only for the custom SPI001-003 plugins in spindjango/flake8_plugins, which
-- have no LSP equivalent and otherwise surface at commit time.
-- --config makes flake8 resolve [flake8:local-plugins] paths relative to that file,
-- so the linter works whatever nvim's cwd is.
local function flake8_config(path)
  return vim.fs.find(".flake8", { path = path, upward = true, type = "file" })[1]
end

local function buffer_path()
  return vim.api.nvim_buf_get_name(0)
end

return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      python = { "flake8" },
    },
    linters = {
      flake8 = {
        cmd = function()
          return python.venv_bin(buffer_path(), "flake8")
        end,
        condition = function(ctx)
          return flake8_config(ctx.filename) ~= nil and python.venv_bin(ctx.filename, "flake8") ~= nil
        end,
        -- LazyVim appends prepend_args after nvim-lint's own args; flake8 accepts
        -- flags on either side of the `-` stdin marker.
        prepend_args = {
          function()
            return "--config=" .. flake8_config(buffer_path())
          end,
        },
      },
    },
  },
}
