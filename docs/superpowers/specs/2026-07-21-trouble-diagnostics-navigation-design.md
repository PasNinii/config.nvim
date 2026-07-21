# Trouble Diagnostics Navigation Design

## Goal

Make the diagnostics list opened by `<leader>xx` navigable with picker-style
`<C-n>` and `<C-p>` bindings.

## Behavior

- In the Trouble window, `<C-n>` selects the next diagnostic.
- In the Trouble window, `<C-p>` selects the previous diagnostic.
- Trouble's existing automatic preview updates as the selection moves.
- `<CR>` remains the explicit action that jumps to the selected diagnostic.
- Outside Trouble, the existing global `<C-n>` and `<C-p>` quickfix mappings
  remain unchanged.

## Implementation

Add a focused `trouble.nvim` plugin override under `lua/plugins/`. Extend
Trouble's public `keys` option with `<C-n> = "next"` and `<C-p> = "prev"`.
Trouble installs these mappings locally in its own window, so they override the
global quickfix mappings only where needed.

## Verification

- Load the configuration headlessly and confirm it reports no startup errors.
- Inspect the merged Trouble plugin options and confirm both key/action pairs.
- Run the repository's available configuration checks, if any.

## Non-goals

- Changing `<leader>xx` itself.
- Changing global quickfix navigation.
- Making selection movement immediately jump the main editor to a diagnostic.
