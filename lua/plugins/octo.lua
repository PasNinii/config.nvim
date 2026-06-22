return {
  {
    "pwntester/octo.nvim",
    opts = {
      -- move "add comment" off <localleader>ca to avoid a keymap conflict; deep-merged into octo defaults
      mappings = {
        discussion = { add_comment = { lhs = "<localleader>cc", desc = "add comment" } },
        issue = { add_comment = { lhs = "<localleader>cc", desc = "add comment" } },
        pull_request = { add_comment = { lhs = "<localleader>cc", desc = "add comment" } },
        review_thread = { add_comment = { lhs = "<localleader>cc", desc = "add comment" } },
        review_diff = {
          add_review_comment = { lhs = "<localleader>cc", desc = "add review comment", mode = { "n", "x" } },
        },
      },
    },
  },
}
