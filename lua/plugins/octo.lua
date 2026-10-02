return {
  {
    "pwntester/octo.nvim",
    -- free <leader>gS for Snacks git_stash (LazyVim octo extra maps it to Octo Search)
    keys = {
      { "<leader>gS", false },
      { "<leader>os", "<cmd>Octo review start<cr>", desc = "Review Start (Octo)" },
      { "<leader>or", "<cmd>Octo review resume<cr>", desc = "Review Resume (Octo)" },
    },
    opts = {
      -- maplocalleader == leader (space), so every <localleader>x here is literally
      -- <leader>x: an lhs must avoid both LazyVim's reserved <leader>c namespace and
      -- octo's own defaults within the same section -- apply_mappings iterates with
      -- pairs(), so two entries sharing an lhs pick a random winner per buffer.
      -- <leader>o is unused on both sides.
      mappings = {
        discussion = { add_comment = { lhs = "<leader>oc", desc = "add comment" } },
        issue = { add_comment = { lhs = "<leader>oc", desc = "add comment" } },
        pull_request = { add_comment = { lhs = "<leader>oc", desc = "add comment" } },
        review_diff = {
          add_review_comment = { lhs = "<leader>oc", desc = "add review comment", mode = { "n", "x" } },
          submit_review = { lhs = "<leader>oa", desc = "submit review" },
          discard_review = { lhs = "<leader>od", desc = "discard review" },
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
