local M = {}

-- uv creates the environment named by $UV_PROJECT_ENVIRONMENT; spinapp sets it to
-- .venv_container, which lives alongside the host-side .venv.
local function venv_names()
  local names = { ".venv_container", ".venv", "venv", "env" }
  local uv_env = vim.env.UV_PROJECT_ENVIRONMENT
  if uv_env and uv_env ~= "" then
    table.insert(names, 1, uv_env)
  end
  return names
end

--- Absolute path to `name` in the bin/ of the virtualenv nearest to `path`, searching upward.
---
--- Opening nvim above the project directory (e.g. /app/spinapp rather than
--- /app/spinapp/spindjango) leaves python tooling on the bare $PATH, which lacks the
--- project's dependencies -> pyright reports "import could not be resolved".
---
--- @param path string? file or directory to search from
--- @param name string executable to look for
--- @return string? nil when no virtualenv above `path` provides it
function M.venv_bin(path, name)
  if not path then
    return nil
  end
  for _, venv in ipairs(venv_names()) do
    local dir = vim.fs.find(venv, { path = path, upward = true, type = "directory" })[1]
    local bin = dir and dir .. "/bin/" .. name
    if bin and vim.fn.executable(bin) == 1 then
      return bin
    end
  end
  return nil
end

return M
