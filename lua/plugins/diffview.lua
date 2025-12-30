return {
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>dh", "<cmd>DiffviewFileHistory<cr>", desc = "File History (all)" },
      { "<leader>df", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File History" },
      { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
      { "<leader>dr", "<cmd>DiffviewRefresh<cr>", desc = "Refresh Diffview" },
      {
        "<leader>dm",
        function()
          local branch = vim.fn.input("Compare with branch/commit: ", "master")
          if branch ~= "" then
            vim.cmd("DiffviewOpen " .. branch)
          end
        end,
        desc = "Diffview Compare Branch",
      },
    },
  },
}
