local python = require("util.python")

return {
  "mfussenegger/nvim-dap-python",
  config = function()
    local dap_python = require("dap-python")
    dap_python.setup("debugpy-adapter")
    -- The adapter runs from Mason, but the program under test needs the project's
    -- interpreter. dap-python's own search covers venv/.venv/env/.env, which misses
    -- the environment named by $UV_PROJECT_ENVIRONMENT.
    dap_python.resolve_python = function()
      return python.venv_bin(vim.api.nvim_buf_get_name(0), "python")
    end
  end,
}
