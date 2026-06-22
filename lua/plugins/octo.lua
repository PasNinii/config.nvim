return {
  {
    "pwntester/octo.nvim",
    opts = {
      -- move "add comment" off <localleader>ca to avoid a keymap conflict; deep-merged into octo defaults
      mappings = {
        discussion = { add_comment = { lhs = "<localleader>cc", desc = "add comment" } },
        issue = { add_comment = { lhs = "<localleader>cc", desc = "add comment" } },
        pull_request = { add_comment = { lhs = "<localleader>cc", desc = "add comment" } },
        review_diff = {
          add_review_comment = { lhs = "<localleader>cc", desc = "add review comment", mode = { "n", "x" } },
          -- drive file nav from the diff window without returning to the file panel
          select_next_entry = { lhs = "<C-n>", desc = "next changed file" },
          select_prev_entry = { lhs = "<C-p>", desc = "previous changed file" },
        },
        review_thread = {
          add_comment = { lhs = "<localleader>cc", desc = "add comment" },
          select_next_entry = { lhs = "<C-n>", desc = "next changed file" },
          select_prev_entry = { lhs = "<C-p>", desc = "previous changed file" },
        },
      },
    },
  },
}
