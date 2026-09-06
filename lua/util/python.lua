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

local function executable(dir, name)
  local bin = dir .. "/bin/" .. name
  return vim.fn.executable(bin) == 1 and bin or nil
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
  if not path or path == "" then
    return nil
  end
  for _, venv in ipairs(venv_names()) do
    local dir = vim.fs.find(venv, { path = path, upward = true, type = "directory" })[1]
    local bin = dir and executable(dir, name)
    if bin then
      return bin
    end
  end
  -- poetry, pyenv-virtualenv and conda keep the environment outside the project tree,
  -- where the upward search cannot reach it; the shell nvim was launched from still
  -- names it, so fall back to that once the project itself has nothing to offer.
  for _, dir in ipairs({ vim.env.VIRTUAL_ENV, vim.env.CONDA_PREFIX }) do
    local bin = dir and dir ~= "" and executable(dir, name)
    if bin then
      return bin
    end
  end
  return nil
end

--- @param pyproject string
--- @return boolean whether the file declares any [tool.ruff...] table
local function declares_ruff(pyproject)
  local ok, lines = pcall(io.lines, pyproject)
  if not ok then
    return false
  end
  for line in lines do
    if line:match("^%s*%[tool%.ruff") then
      return true
    end
  end
  return false
end

--- Root of the nearest project that opts into ruff, searching upward from `path`.
---
--- ruff's LSP roots itself on `.git`, so it otherwise starts in every python repo and
--- reports its own default rule set as diagnostics. Merely holding a pyproject.toml is
--- not an opt-in; the file has to carry a [tool.ruff] table.
---
--- @param path string? file or directory to search from
--- @return string? nil when no project above `path` configures ruff
function M.ruff_root(path)
  if not path or path == "" then
    return nil
  end
  local configs = vim.fs.find({ "ruff.toml", ".ruff.toml", "pyproject.toml" }, {
    path = path,
    upward = true,
    type = "file",
    limit = math.huge,
  })
  for _, config in ipairs(configs) do
    if not config:match("pyproject%.toml$") or declares_ruff(config) then
      return vim.fs.dirname(config)
    end
  end
  return nil
end

return M
