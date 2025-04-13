vim.g.mapleader = " "  -- 设置<leader>为空格

local map = vim.keymap.set  -- 快捷写法

-- 基础操作
map("n", "<leader>w", ":w<CR>", { desc = "保存" })
map("n", "<leader>q", ":q<CR>", { desc = "退出" })
--map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "文件树" })
map("n", "<leader>e", ":Ex<CR>", { desc = "Exploer" })

-- 移动优化
map("n", "H", "^")  -- 行首
map("n", "L", "$")  -- 行尾
--map("n", "J", "5j") -- 向下5行
--map("n", "K", "5k") -- 向上5行


