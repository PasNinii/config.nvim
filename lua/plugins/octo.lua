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
    config = function(_, opts)
      require("octo").setup(opts)

      -- maplocalleader == leader (space), so <localleader>cc above is literally
      -- <leader>cc. LazyVim binds <leader>cc to codelens on any LSP-attached
      -- buffer, and the TS server attaches to the real file behind an Octo
      -- review diff *after* Octo sets its mapping, silently overwriting it.
      -- Re-apply Octo's review_diff mapping on every LspAttach for buffers
      -- that belong to the active review so the comment binding always wins.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("octo_review_diff_keymap_priority", { clear = true }),
        callback = function(args)
          local ok, reviews = pcall(require, "octo.reviews")
          local review = ok and reviews.get_current_review()
          if not review then
            return
          end
          for _, file in ipairs(review.layout.files) do
            if vim.tbl_contains(file.associated_bufs, args.buf) then
              require("octo.utils").apply_mappings("review_diff", args.buf)
              return
            end
          end
        end,
      })
    end,
  },
}
