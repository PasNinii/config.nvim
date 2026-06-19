return {
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gdh", "<cmd>DiffviewFileHistory<cr>", desc = "File History (all)" },
      { "<leader>gdf", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File History" },
      { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
      { "<leader>gdr", "<cmd>DiffviewRefresh<cr>", desc = "Refresh Diffview" },
      {
        "<leader>gdm",
        function()
          local base = vim.fn.input("Compare against (merge-base with): ", "origin/master")
          if base == "" then
            return
          end
          -- diff working tree against the merge-base (single rev) => PR-scoped file list,
          -- but right pane stays the live working file so it remains editable.
          local merge_base = vim.fn.system("git merge-base " .. base .. " HEAD"):gsub("%s+", "")
          if vim.v.shell_error ~= 0 or merge_base == "" then
            vim.notify("No merge-base with " .. base, vim.log.levels.ERROR)
            return
          end
          vim.cmd("DiffviewOpen " .. merge_base)
        end,
        desc = "Diffview vs merge-base (PR-scoped, editable)",
      },
      {
        "<leader>gdb",
        function()
          local current = vim.fn.system("git branch --show-current"):gsub("%s+", "")
          local branch = vim.fn.input("Compare with branch/commit: ", current)
          if branch ~= "" then
            vim.cmd("DiffviewOpen " .. branch)
          end
        end,
        desc = "Diffview Compare (current branch prefill)",
      },
    },
  },
}
