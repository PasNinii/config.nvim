return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      documentation = {
        -- pyright hands back whole docstrings, so the window is capped and the
        -- long ones scroll instead of covering the buffer next to the menu.
        window = { max_width = 60, max_height = 12 },
        auto_show_delay_ms = 500,
      },
    },
  },
}
