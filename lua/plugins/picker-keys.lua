-- Free <leader><space> (don't want Find Files there) and drop the duplicate cwd
-- find variant; <leader>ff (Root Dir) stays as the single find-files map.
return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader><space>", false },
      { "<leader>fF", false },
    },
  },
}
