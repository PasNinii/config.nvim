# Editing and Navigation Upgrade Design

## Goal

Make file discovery follow the directory used to launch Neovim, provide a dependable VS Code-like visual-selection `Ctrl-D` workflow, retain native search-and-replace as the simplest bulk-edit path, and document Tree-sitter function selection.

## Decisions

### Picker roots

`<leader>ff` will search the current working directory. This matches the expectation that launching Neovim in `root/` searches both `root/src/` and `root/bis/`, regardless of the active buffer's LSP root.

`<leader>fF` will search LazyVim's current buffer root. That preserves the useful narrower LSP/project-root behavior without making it the default. The Snacks picker retains its built-in `Alt-c` root toggle.

Changing `vim.g.root_spec` globally was rejected because it would also alter root-aware grep, terminals, Git tools, and other LazyVim features.

### Multicursor behavior

Add `jake-stewart/multicursor.nvim` on its stable `1.0` branch. Map `Ctrl-D` only in visual mode to add the next occurrence of the exact visual selection. Repeated `Ctrl-D` presses add further occurrences; changing the visual selections updates them together.

Normal-mode `Ctrl-D` remains untouched so half-page scrolling continues to work. An active multicursor session will provide an Escape path that clears its cursors after leaving insert mode.

Native visual `*` followed by `:%s//replacement/gc` remains the recommended workflow when every match receives the same replacement. Multicursors are for selectively choosing occurrences or performing edits that are not a single substitution.

`vim-visual-multi` was rejected because its additional cursor/extend mode model adds more state and keymap surface than this workflow requires.

### Python virtual-environment warning

Disable `venv-selector.nvim`. Its `fd` dependency is absent, and the local Mason registry does not provide an `fd` package. The existing Pyright configuration already discovers `.venv_container`, `.venv`, `venv`, and `env` and assigns the interpreter automatically, making the selector redundant for the configured workflow.

This avoids adding an unmanaged system dependency. The rest of LazyVim's Python extra remains enabled.

### Diffview command safety

Run `git merge-base` with an argument vector rather than a shell command string. Open Diffview through structured `nvim_cmd` arguments rather than concatenated Ex input. Empty input, failed Git commands, and empty merge-base output continue to produce no command execution and an error notification where applicable.

### Documentation

Expand the repository README with a compact workflow reference covering:

- current-working-directory versus LSP-root file picking;
- exact substring replacement in the current buffer with visual `*` and `:%s`;
- project-wide GrugFar replacement and its Paths input;
- visual `Ctrl-D` multicursors and Escape cleanup;
- `vaf`, `vif`, `yaf`, `daf`, `[f`, and `]f` Tree-sitter function operations.

## File boundaries

- `lua/plugins/picker-keys.lua`: picker key semantics only.
- `lua/plugins/multicursor.lua`: multicursor dependency, visual mapping, and active-session mappings.
- `lua/plugins/disabled.lua`: explicitly disabled optional plugins, including the redundant venv selector.
- `lua/plugins/diffview.lua`: Diffview-facing mappings and safe process/command invocation.
- `tests/config_spec.lua`: headless assertions against the effective LazyVim configuration and safe Git helper behavior.
- `README.md`: user-facing key workflow reference.

## Verification

Automated headless tests will first fail against the current config, then verify:

- `<leader>ff` resolves to working-directory file search;
- `<leader>fF` resolves to LazyVim root search;
- visual `Ctrl-D` is registered without replacing normal `Ctrl-D`;
- `venv-selector.nvim` is disabled and opening a Python buffer no longer emits the missing-`fd` warning;
- a hostile merge-base argument is passed as one Git argument and cannot create a shell side effect;
- the documented workflows are present.

Final verification will run the headless test suite, format Lua with Stylua, load the full config without startup errors, open a Python buffer without the `fd` warning, and inspect the Git diff for unrelated changes.
