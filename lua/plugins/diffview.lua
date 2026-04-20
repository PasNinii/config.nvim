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
          local branch = vim.fn.input("Compare with branch/commit: ", "master")
          if branch ~= "" then
            vim.cmd("DiffviewOpen origin...HEAD")
          end
        end,
        desc = "Diffview Compare Branch",
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
