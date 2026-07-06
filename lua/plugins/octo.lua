return {
  {
    "pwntester/octo.nvim",
    -- free <leader>gS for Snacks git_stash (LazyVim octo extra maps it to Octo Search)
    keys = {
      { "<leader>gS", false },
    },
    opts = {
      -- maplocalleader == leader (space), so any <localleader>c* here is literally
      -- <leader>c*, colliding with LazyVim's reserved <leader>c (LSP code actions)
      -- namespace. LazyVim applies those via Snacks.keymap.set, which re-asserts
      -- the buffer-local mapping on a 100ms debounce every time a matching LSP
      -- client attaches -- it always wins a same-key race eventually. Use a key
      -- outside that namespace instead of fighting the debounce.
      mappings = {
        discussion = { add_comment = { lhs = "<leader>oc", desc = "add comment" } },
        issue = { add_comment = { lhs = "<leader>oc", desc = "add comment" } },
        pull_request = { add_comment = { lhs = "<leader>oc", desc = "add comment" } },
        review_diff = {
          add_review_comment = { lhs = "<leader>oc", desc = "add review comment", mode = { "n", "x" } },
          -- drive file nav from the diff window without returning to the file panel
          select_next_entry = { lhs = "<C-n>", desc = "next changed file" },
          select_prev_entry = { lhs = "<C-p>", desc = "previous changed file" },
        },
        review_thread = {
          add_comment = { lhs = "<leader>oc", desc = "add comment" },
          select_next_entry = { lhs = "<C-n>", desc = "next changed file" },
          select_prev_entry = { lhs = "<C-p>", desc = "previous changed file" },
        },
      },
    },
  },
}
