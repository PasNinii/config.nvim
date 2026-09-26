# nvim

LazyVim v8 on Neovim 0.12. Personal keys on top of the defaults:

| Key | Mode | Does |
|-----|-----|-----|
| `viw` then `<C-d>` | visual | add a cursor on the next match (repeat), `<C-q>` skips one, `<Esc>` clears |
| `<A-Up>` / `<A-Down>` | normal, visual | add a cursor on the line above / below |
| `<leader>ff` | normal | find files from the launch directory |
| `<leader>gd*` | normal | Diffview: history, merge-base diff, branch compare |
| `<A-h>` / `<A-l>`, `<leader>t*` | normal | tabs |
| `gj` / `gk` | diff windows | next / previous change |

Formatting runs on save through conform: dprint when the repo holds a dprint.json,
prettier otherwise; ruff for python, read from the project's venv when one exists.
Project config wins whenever present, tool defaults apply otherwise.
