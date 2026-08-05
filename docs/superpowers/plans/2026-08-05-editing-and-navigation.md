# Editing and Navigation Upgrade Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make file picking follow Neovim's working directory by default, add a visual-selection-only `Ctrl-D` multicursor workflow, remove the Python `fd` warning, harden Diffview revision handling, and document the editing workflows.

**Architecture:** Keep each behavior in its existing LazyVim plugin-spec boundary. Exercise the effective mappings and lazy-plugin graph through a plain headless Neovim test script, and test Diffview input through its real keymap callbacks so command parsing—not a duplicate helper—is verified.

**Tech Stack:** Lua, Neovim 0.12+, LazyVim, lazy.nvim, Snacks picker, jake-stewart/multicursor.nvim, Git, Stylua.

## Global Constraints

- `<leader>ff` searches `vim.uv.cwd()`; `<leader>fF` searches `LazyVim.root()`.
- `Ctrl-D` is changed only in visual mode; normal-mode half-page scrolling remains native.
- Native visual `*` plus `:%s` remains documented as the primary identical-replacement workflow.
- Disable only `venv-selector.nvim`; retain the rest of the Python extra and the existing Pyright virtualenv discovery.
- Never interpolate user-provided Git revisions into shell strings or Ex command strings.
- Do not change `maplocalleader` or the installed Neovim version.

---

### Task 1: Headless Test Harness and Picker Semantics

**Files:**
- Create: `tests/config_spec.lua`
- Modify: `lua/plugins/picker-keys.lua:1-11`

**Interfaces:**
- Consumes: effective LazyVim mappings returned by `vim.fn.maparg(lhs, mode, false, true)`.
- Produces: a reusable `test(name, fn)` harness and the final picker callbacks for later regression checks.

- [ ] **Step 1: Write the failing picker tests**

Create `tests/config_spec.lua` with:

```lua
local failures = {}

local function test(name, fn)
  local ok, err = xpcall(fn, debug.traceback)
  if ok then
    print("PASS " .. name)
  else
    failures[#failures + 1] = name .. ": " .. err
    print("FAIL " .. failures[#failures])
  end
end

local function mapping(mode, lhs)
  local map = vim.fn.maparg(lhs, mode, false, true)
  assert(type(map) == "table" and next(map) ~= nil, ("missing %s mapping %s"):format(mode, lhs))
  assert(type(map.callback) == "function", ("mapping %s has no callback"):format(lhs))
  return map
end

test("find files uses cwd", function()
  local map = mapping("n", "<leader>ff")
  local original = Snacks.picker.files
  local received
  Snacks.picker.files = function(opts) received = opts end
  local ok, err = pcall(map.callback)
  Snacks.picker.files = original
  assert(ok, err)
  assert(received and received.cwd == vim.uv.cwd(), vim.inspect(received))
end)

test("find files uppercase uses LazyVim root", function()
  local map = mapping("n", "<leader>fF")
  local original = Snacks.picker.files
  local received
  Snacks.picker.files = function(opts) received = opts end
  local expected = LazyVim.root()
  local ok, err = pcall(map.callback)
  Snacks.picker.files = original
  assert(ok, err)
  assert(received and received.cwd == expected, vim.inspect(received))
end)

if #failures > 0 then
  error(table.concat(failures, "\n"))
end
```

- [ ] **Step 2: Run the picker tests and verify RED**

Run:

```bash
nvim --headless -l tests/config_spec.lua
```

Expected: FAIL because the current `<leader>ff` callback uses LazyVim's root abstraction and `<leader>fF` is disabled.

- [ ] **Step 3: Implement the two explicit picker callbacks**

Replace `lua/plugins/picker-keys.lua` with:

```lua
-- Keep file discovery anchored to the directory used to launch Neovim.
-- The uppercase variant preserves LazyVim's narrower current-buffer/LSP root.
return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader><space>", false },
      {
        "<leader>ff",
        function() Snacks.picker.files({ cwd = vim.uv.cwd() }) end,
        desc = "Find Files (cwd)",
      },
      {
        "<leader>fF",
        function() Snacks.picker.files({ cwd = LazyVim.root() }) end,
        desc = "Find Files (Root Dir)",
      },
    },
  },
}
```

- [ ] **Step 4: Run the picker tests and verify GREEN**

Run `nvim --headless -l tests/config_spec.lua`.

Expected: two PASS lines and exit status 0.

- [ ] **Step 5: Commit the picker behavior**

```bash
git add tests/config_spec.lua lua/plugins/picker-keys.lua
git commit -m "fix: keep file picker anchored to cwd"
```

---

### Task 2: Visual `Ctrl-D` Multicursors

**Files:**
- Create: `lua/plugins/multicursor.lua`
- Modify: `tests/config_spec.lua`
- Modify after install: `lazy-lock.json`

**Interfaces:**
- Consumes: `multicursor-nvim.matchAddCursor(direction)` and `multicursor-nvim.addKeymapLayer(callback)`.
- Produces: visual `<C-d>` for the next exact selection match and an active-session Escape cleanup layer.

- [ ] **Step 1: Append failing multicursor mapping tests before the final failure check**

```lua
test("ctrl-d is visual-only multicursor", function()
  local visual = mapping("x", "<C-d>")
  assert(visual.desc == "Add Next Match (Multicursor)", vim.inspect(visual))

  local normal = vim.fn.maparg("<C-d>", "n", false, true)
  assert(type(normal) == "table" and next(normal) == nil, "normal Ctrl-D must remain native")
end)
```

- [ ] **Step 2: Run the test and verify RED**

Run `nvim --headless -l tests/config_spec.lua`.

Expected: FAIL with `missing x mapping <C-d>`.

- [ ] **Step 3: Add the minimal plugin spec**

Create `lua/plugins/multicursor.lua`:

```lua
return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    keys = {
      {
        "<C-d>",
        function() require("multicursor-nvim").matchAddCursor(1) end,
        mode = "x",
        desc = "Add Next Match (Multicursor)",
      },
    },
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()
      mc.addKeymapLayer(function(set)
        set("n", "<Esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)
    end,
  },
}
```

- [ ] **Step 4: Install the plugin and update the lockfile**

Run:

```bash
nvim --headless "+Lazy! sync" +qa
```

Expected: `multicursor.nvim` is installed on branch `1.0` and added to `lazy-lock.json`.

- [ ] **Step 5: Run tests and verify GREEN**

Run `nvim --headless -l tests/config_spec.lua`.

Expected: the picker and multicursor tests pass; normal `<C-d>` has no user mapping.

- [ ] **Step 6: Commit multicursor support**

```bash
git add lua/plugins/multicursor.lua tests/config_spec.lua lazy-lock.json
git commit -m "feat: add visual ctrl-d multicursors"
```

---

### Task 3: Remove the Missing-`fd` Python Warning

**Files:**
- Modify: `lua/plugins/disabled.lua:1-16`
- Modify: `tests/config_spec.lua`

**Interfaces:**
- Consumes: lazy.nvim's resolved plugin table and Neovim `:messages` output.
- Produces: Python buffers that retain language tooling without loading `venv-selector.nvim`.

- [ ] **Step 1: Append failing plugin and runtime-warning tests**

```lua
test("venv selector is disabled", function()
  local plugins = require("lazy.core.config").plugins
  assert(plugins["venv-selector.nvim"] == nil, "venv-selector.nvim is still enabled")
end)

test("python buffer does not report missing fd", function()
  vim.cmd("enew")
  vim.bo.filetype = "python"
  vim.wait(500)
  local messages = vim.api.nvim_exec2("messages", { output = true }).output
  assert(not messages:find("Cannot find any fd binary", 1, true), messages)
  vim.cmd("bwipeout!")
end)
```

- [ ] **Step 2: Run tests and verify RED**

Run `nvim --headless -l tests/config_spec.lua`.

Expected: FAIL because `venv-selector.nvim` remains in Lazy's graph and emits the warning on Python `FileType`.

- [ ] **Step 3: Disable only the redundant selector**

Add this spec beside the existing Flash disable in `lua/plugins/disabled.lua`:

```lua
{ "linux-cultist/venv-selector.nvim", enabled = false },
```

- [ ] **Step 4: Run tests and verify GREEN**

Run `nvim --headless -l tests/config_spec.lua`.

Expected: all tests pass and no missing-`fd` text appears.

- [ ] **Step 5: Commit the Python warning fix**

```bash
git add lua/plugins/disabled.lua tests/config_spec.lua
git commit -m "fix: disable redundant Python venv selector"
```

---

### Task 4: Safe Diffview Revision Handling

**Files:**
- Modify: `lua/plugins/diffview.lua:1-40`
- Modify: `tests/config_spec.lua`

**Interfaces:**
- Consumes: `vim.system(argv, { text = true }):wait()` and `vim.api.nvim_cmd()`.
- Produces: unchanged `<leader>gdm` and `<leader>gdb` user flows with argument-safe Git and Ex invocation.

- [ ] **Step 1: Append failing shell-injection regression test**

```lua
test("merge-base input is one Git argument", function()
  require("lazy").load({ plugins = { "diffview.nvim" } })
  local map = mapping("n", "<leader>gdm")
  local original_input = vim.fn.input
  local original_fn_system = vim.fn.system
  local original_system = vim.system
  local received

  vim.fn.input = function() return "HEAD;touch /payload-must-not-run" end
  vim.fn.system = function(arg)
    received = arg
    return ""
  end
  vim.system = function(argv)
    received = argv
    return {
      wait = function() return { code = 1, stdout = "", stderr = "invalid revision" } end,
    }
  end

  local ok, err = pcall(map.callback)
  vim.fn.input = original_input
  vim.fn.system = original_fn_system
  vim.system = original_system

  assert(ok, err)
  assert(type(received) == "table", "Git command was passed as a shell string")
  assert(vim.deep_equal(received, { "git", "merge-base", "HEAD;touch /payload-must-not-run", "HEAD" }), vim.inspect(received))
end)
```

- [ ] **Step 2: Append failing Ex-injection regression test**

```lua
test("Diffview revision is one Ex argument", function()
  require("lazy").load({ plugins = { "diffview.nvim" } })
  pcall(vim.api.nvim_del_user_command, "DiffviewOpen")
  local received
  vim.api.nvim_create_user_command("DiffviewOpen", function(opts) received = opts.args end, { nargs = "*" })

  vim.g.diffview_injected = false
  local original_input = vim.fn.input
  vim.fn.input = function() return "HEAD | let g:diffview_injected = v:true" end
  local map = mapping("n", "<leader>gdb")
  local ok, err = pcall(map.callback)
  vim.fn.input = original_input

  assert(ok, err)
  assert(vim.g.diffview_injected == false, "revision input executed an Ex command")
  assert(received == "HEAD | let g:diffview_injected = v:true", vim.inspect(received))
end)
```

- [ ] **Step 3: Run the tests and verify RED safely**

Run `nvim --headless -l tests/config_spec.lua`.

Expected: the Git test fails because the current callback passes a string to the captured `vim.fn.system`; the capture prevents any process from running. The Ex test fails safely by setting `vim.g.diffview_injected` to true inside Neovim.

- [ ] **Step 4: Replace string execution with structured APIs**

In `<leader>gdm`, replace the `vim.fn.system` block with:

```lua
local result = vim.system({ "git", "merge-base", base, "HEAD" }, { text = true }):wait()
local merge_base = vim.trim(result.stdout or "")
if result.code ~= 0 or merge_base == "" then
  vim.notify("No merge-base with " .. base, vim.log.levels.ERROR)
  return
end
vim.api.nvim_cmd({ cmd = "DiffviewOpen", args = { merge_base } }, {})
```

In `<leader>gdb`, replace the concatenated command with:

```lua
vim.api.nvim_cmd({ cmd = "DiffviewOpen", args = { branch } }, {})
```

- [ ] **Step 5: Run tests and verify GREEN**

Run `nvim --headless -l tests/config_spec.lua`.

Expected: all tests pass, the Git invocation is the exact four-element argument vector, the Ex sentinel remains false, and the captured revision remains one argument.

- [ ] **Step 6: Commit Diffview hardening**

```bash
git add lua/plugins/diffview.lua tests/config_spec.lua
git commit -m "fix: pass Diffview revisions safely"
```

---

### Task 5: Workflow Documentation

**Files:**
- Modify: `README.md:1-4`
- Modify: `tests/config_spec.lua`

**Interfaces:**
- Consumes: final mappings and existing LazyVim GrugFar/Tree-sitter behavior.
- Produces: a concise repository-local reference for the supported workflows.

- [ ] **Step 1: Append failing documentation assertions**

```lua
test("README documents editing workflows", function()
  local readme = table.concat(vim.fn.readfile("README.md"), "\n")
  for _, expected in ipairs({
    "<leader>ff",
    "<leader>fF",
    "<C-d>",
    ":%s//replacement/gc",
    "<leader>sr",
    "vaf",
    "vif",
  }) do
    assert(readme:find(expected, 1, true), "README missing " .. expected)
  end
end)
```

- [ ] **Step 2: Run tests and verify RED**

Run `nvim --headless -l tests/config_spec.lua`.

Expected: FAIL because the starter README contains none of the workflow reference.

- [ ] **Step 3: Replace the starter README with the workflow reference**

Document these exact behaviors:

```markdown
# Neovim Configuration

## File picking

- `<leader>ff`: files below Neovim's current working directory.
- `<leader>fF`: files below the active buffer's LazyVim/LSP root.
- `Alt-c` inside the picker: toggle those roots.
- `:pwd` and `:LazyRoot`: inspect both root concepts.

## Replace text

For the same replacement throughout the current file:

1. Select the exact substring with `v` and a motion.
2. Press `*` to create a literal search.
3. Run `:%s//replacement/gc`; remove `c` to skip confirmation.

For selective simultaneous edits, visually select the substring and press `<C-d>` repeatedly to add matching selections. Change the selection, leave insert mode with Escape, then press Escape again to clear the cursors.

For multi-file replacement, visually select the text and press `<leader>sr`. GrugFar prefills the search; its Paths field limits the operation to a file or directory.

## Function text objects

- `vaf` / `vif`: select the whole function or only its body.
- `yaf` / `daf`: yank or delete the whole function.
- `]f` / `[f`: move to the next or previous function.

These Tree-sitter text objects work for Python methods without relying on braces.
```

- [ ] **Step 4: Run tests and verify GREEN**

Run `nvim --headless -l tests/config_spec.lua`.

Expected: all behavior and documentation tests pass.

- [ ] **Step 5: Commit documentation**

```bash
git add README.md tests/config_spec.lua
git commit -m "docs: add editing workflow reference"
```

---

### Task 6: Full Verification

**Files:**
- Verify: all modified files

**Interfaces:**
- Consumes: completed tasks 1-5.
- Produces: evidence that the config loads, tests pass, Lua is formatted, and only scoped changes remain.

- [ ] **Step 1: Format Lua**

```bash
stylua lua tests
```

- [ ] **Step 2: Run the complete headless test suite**

```bash
nvim --headless -l tests/config_spec.lua
```

Expected: every test prints PASS and Neovim exits 0.

- [ ] **Step 3: Verify startup and Python FileType messages**

```bash
nvim --headless "+enew" "+set filetype=python" "+lua vim.wait(500); local m=vim.api.nvim_exec2('messages',{output=true}).output; assert(not m:find('Cannot find any fd binary',1,true),m)" +qa!
```

Expected: exit status 0 with no missing-`fd` message.

- [ ] **Step 4: Verify formatting and repository scope**

```bash
git diff --check
git status --short
git diff --stat HEAD~5..HEAD
```

Expected: no whitespace errors; only the plan, config, tests, README, and lockfile changes from this feature are present.

- [ ] **Step 5: Inspect effective mappings**

```bash
nvim --headless "+lua print(vim.inspect(vim.fn.maparg('<leader>ff','n',false,true))); print(vim.inspect(vim.fn.maparg('<leader>fF','n',false,true))); print(vim.inspect(vim.fn.maparg('<C-d>','x',false,true))); assert(next(vim.fn.maparg('<C-d>','n',false,true)) == nil)" +qa!
```

Expected: both picker callbacks and visual multicursor mapping are present; normal `Ctrl-D` remains unmapped.

- [ ] **Step 6: Review final diff and commit formatting only if needed**

If Stylua changed tracked content after the task commits:

```bash
git add lua tests
git commit -m "style: format editing configuration"
```

Otherwise, leave the existing task commits unchanged.
