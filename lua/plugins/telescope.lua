
-- ~/.config/nvim/lua/plugins/telescope.lua
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup()
      local map = vim.keymap.set
      map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "查找文件" })
      map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "全局搜索" })
    end,
  },
}

