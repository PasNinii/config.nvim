return {
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewFileHistory",
      "DiffviewRefresh",
    },
    opts = {
      -- Use better diff algorithm for more readable diffs (similar to VSCode)
      diff_binaries = false,
      enhanced_diff_hl = true,
      use_icons = true,

      -- VSCode-like icons for file status
      icons = {
        folder_closed = "",
        folder_open = "",
      },

      signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
      },

      view = {
        default = {
          layout = "diff2_horizontal",
          winbar_info = true,
          disable_diagnostics = false,
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
        },
        file_history = {
          layout = "diff2_horizontal",
          winbar_info = true,
        },
      },

      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
          win_opts = {
            number = false,
            relativenumber = false,
            cursorline = true,
          },
        },
      },

      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = "combined",
            },
            multi_file = {
              diff_merges = "first-parent",
            },
          },
        },
        win_config = {
          position = "bottom",
          height = 16,
          win_opts = {
            number = false,
            relativenumber = false,
            cursorline = true,
          },
        },
      },

      commit_log_panel = {
        win_config = {
          win_opts = {
            number = false,
            relativenumber = false,
          },
        },
      },

      default_args = {
        DiffviewOpen = {},
        DiffviewFileHistory = {},
      },

      hooks = {
        -- Use histogram diff algorithm for better readability
        diff_buf_read = function()
          vim.opt_local.diffopt:append("algorithm:histogram")
          vim.opt_local.diffopt:append("indent-heuristic")
        end,
      },

      keymaps = {
        disable_defaults = false,
        view = {
          -- VSCode-like navigation between changes
          { "n", "[c", "<cmd>lua require('diffview.actions').prev_conflict()<cr>", { desc = "Previous conflict" } },
          { "n", "]c", "<cmd>lua require('diffview.actions').next_conflict()<cr>", { desc = "Next conflict" } },
          { "n", "[x", "<cmd>lua require('diffview.actions').prev_entry()<cr>", { desc = "Previous file" } },
          { "n", "]x", "<cmd>lua require('diffview.actions').next_entry()<cr>", { desc = "Next file" } },

          -- Toggle file panel (like VSCode's sidebar)
          { "n", "<tab>", "<cmd>lua require('diffview.actions').toggle_files()<cr>", { desc = "Toggle file panel" } },
          { "n", "<leader>e", "<cmd>lua require('diffview.actions').focus_files()<cr>", { desc = "Focus file panel" } },
          { "n", "<leader>b", "<cmd>lua require('diffview.actions').toggle_files()<cr>", { desc = "Toggle file panel" } },

          -- Stage/unstage files (VSCode-like)
          { "n", "s", "<cmd>lua require('diffview.actions').toggle_stage_entry()<cr>", { desc = "Stage/unstage file" } },
          { "n", "S", "<cmd>lua require('diffview.actions').stage_all()<cr>", { desc = "Stage all" } },
          { "n", "U", "<cmd>lua require('diffview.actions').unstage_all()<cr>", { desc = "Unstage all" } },

          -- Refresh and close
          { "n", "R", "<cmd>lua require('diffview.actions').refresh_files()<cr>", { desc = "Refresh" } },
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
          { "n", "<esc>", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },

          -- Focus entry
          { "n", "<cr>", "<cmd>lua require('diffview.actions').select_entry()<cr>", { desc = "Open file" } },
          { "n", "o", "<cmd>lua require('diffview.actions').select_entry()<cr>", { desc = "Open file" } },

          -- Open in new split
          { "n", "<C-v>", "<cmd>lua require('diffview.actions').select_entry('vsplit')<cr>", { desc = "Open in vsplit" } },
          { "n", "<C-x>", "<cmd>lua require('diffview.actions').select_entry('split')<cr>", { desc = "Open in split" } },
          { "n", "<C-t>", "<cmd>lua require('diffview.actions').select_entry('tabedit')<cr>", { desc = "Open in tab" } },

          -- Go to file
          { "n", "gf", "<cmd>lua require('diffview.actions').goto_file_edit()<cr>", { desc = "Go to file" } },
        },

        file_panel = {
          -- Navigation
          { "n", "j", "<cmd>lua require('diffview.actions').next_entry()<cr>", { desc = "Next file" } },
          { "n", "<down>", "<cmd>lua require('diffview.actions').next_entry()<cr>", { desc = "Next file" } },
          { "n", "k", "<cmd>lua require('diffview.actions').prev_entry()<cr>", { desc = "Previous file" } },
          { "n", "<up>", "<cmd>lua require('diffview.actions').prev_entry()<cr>", { desc = "Previous file" } },

          -- Open files
          { "n", "<cr>", "<cmd>lua require('diffview.actions').select_entry()<cr>", { desc = "Open file" } },
          { "n", "o", "<cmd>lua require('diffview.actions').select_entry()<cr>", { desc = "Open file" } },
          { "n", "l", "<cmd>lua require('diffview.actions').select_entry()<cr>", { desc = "Open file" } },

          -- Close folder
          { "n", "h", "<cmd>lua require('diffview.actions').close_fold()<cr>", { desc = "Close folder" } },

          -- Open in new split
          { "n", "<C-v>", "<cmd>lua require('diffview.actions').select_entry('vsplit')<cr>", { desc = "Open in vsplit" } },
          { "n", "<C-x>", "<cmd>lua require('diffview.actions').select_entry('split')<cr>", { desc = "Open in split" } },
          { "n", "<C-t>", "<cmd>lua require('diffview.actions').select_entry('tabedit')<cr>", { desc = "Open in tab" } },

          -- Stage/unstage
          { "n", "s", "<cmd>lua require('diffview.actions').toggle_stage_entry()<cr>", { desc = "Stage/unstage" } },
          { "n", "S", "<cmd>lua require('diffview.actions').stage_all()<cr>", { desc = "Stage all" } },
          { "n", "U", "<cmd>lua require('diffview.actions').unstage_all()<cr>", { desc = "Unstage all" } },

          -- Restore file
          { "n", "X", "<cmd>lua require('diffview.actions').restore_entry()<cr>", { desc = "Restore file" } },

          -- Refresh
          { "n", "R", "<cmd>lua require('diffview.actions').refresh_files()<cr>", { desc = "Refresh" } },

          -- Toggle panel
          { "n", "<tab>", "<cmd>lua require('diffview.actions').toggle_files()<cr>", { desc = "Toggle file panel" } },
          { "n", "<leader>e", "<cmd>lua require('diffview.actions').focus_files()<cr>", { desc = "Focus files" } },
          { "n", "<leader>b", "<cmd>lua require('diffview.actions').toggle_files()<cr>", { desc = "Toggle file panel" } },

          -- Close
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
          { "n", "<esc>", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },

          -- Go to file
          { "n", "gf", "<cmd>lua require('diffview.actions').goto_file_edit()<cr>", { desc = "Go to file" } },

          -- List/tree toggle
          { "n", "i", "<cmd>lua require('diffview.actions').listing_style()<cr>", { desc = "Toggle list/tree" } },
        },

        file_history_panel = {
          { "n", "g!", "<cmd>lua require('diffview.actions').options()<cr>", { desc = "Open options" } },
          { "n", "<C-d>", "<cmd>lua require('diffview.actions').open_in_diffview()<cr>", { desc = "Open in diffview" } },
          { "n", "y", "<cmd>lua require('diffview.actions').copy_hash()<cr>", { desc = "Copy commit hash" } },
          { "n", "L", "<cmd>lua require('diffview.actions').open_commit_log()<cr>", { desc = "Open commit log" } },
          { "n", "zR", "<cmd>lua require('diffview.actions').open_all_folds()<cr>", { desc = "Open all folds" } },
          { "n", "zM", "<cmd>lua require('diffview.actions').close_all_folds()<cr>", { desc = "Close all folds" } },
          { "n", "j", "<cmd>lua require('diffview.actions').next_entry()<cr>", { desc = "Next entry" } },
          { "n", "<down>", "<cmd>lua require('diffview.actions').next_entry()<cr>", { desc = "Next entry" } },
          { "n", "k", "<cmd>lua require('diffview.actions').prev_entry()<cr>", { desc = "Previous entry" } },
          { "n", "<up>", "<cmd>lua require('diffview.actions').prev_entry()<cr>", { desc = "Previous entry" } },
          { "n", "<cr>", "<cmd>lua require('diffview.actions').select_entry()<cr>", { desc = "Open entry" } },
          { "n", "o", "<cmd>lua require('diffview.actions').select_entry()<cr>", { desc = "Open entry" } },
          { "n", "<tab>", "<cmd>lua require('diffview.actions').select_next_entry()<cr>", { desc = "Next entry" } },
          { "n", "<s-tab>", "<cmd>lua require('diffview.actions').select_prev_entry()<cr>", { desc = "Previous entry" } },
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close" } },
          { "n", "<esc>", "<cmd>DiffviewClose<cr>", { desc = "Close" } },
        },

        option_panel = {
          { "n", "<tab>", "<cmd>lua require('diffview.actions').select_entry()<cr>", { desc = "Select option" } },
          { "n", "q", "<cmd>lua require('diffview.actions').close()<cr>", { desc = "Close" } },
          { "n", "<esc>", "<cmd>lua require('diffview.actions').close()<cr>", { desc = "Close" } },
        },
      },
    },
    keys = {
      -- Diffview shortcuts for PR review and git workflow
      {
        "<leader>gdo",
        function()
          local lib = require("diffview.lib")
          local view = lib.get_current_view()
          if view then
            vim.cmd("DiffviewClose")
          else
            vim.cmd("DiffviewOpen")
          end
        end,
        desc = "Toggle Diffview",
      },
      { "<leader>gdh", "<cmd>DiffviewFileHistory<cr>", desc = "File History (all)" },
      { "<leader>gdf", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File History" },
      { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
      { "<leader>gdr", "<cmd>DiffviewRefresh<cr>", desc = "Refresh Diffview" },

      -- Compare branches/commits
      {
        "<leader>gdm",
        function()
          local branch = vim.fn.input("Compare with branch/commit: ", "main")
          if branch ~= "" then
            vim.cmd("DiffviewOpen " .. branch)
          end
        end,
        desc = "Diffview Compare Branch",
      },
    },
  },
}
