vim.g.mapleader = " "  -- 设置<leader>为空格

local map = vim.keymap.set  -- 快捷写法

-- 基础操作
map("n", "<leader>ww", ":w<CR>", { desc = "save" })
map("n", "<leader>wq", ":wq<CR>", { desc = "save and exit" })
map("n", "<leader>qq", ":q!<CR>", { desc = "exit" })
map("n", "<leader>qa", ":qa!<CR>", { desc = "close all windows and quit"})

--map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "文件树" })
map("n", "<leader>e", ":Ex<CR>", { desc = "Exploer" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode"})
map("v", "<leader>j", "<ESC>", { desc = "Exit visual mode" })

-- 移动优化
map("n", "H", "^")  -- 行首
map("n", "L", "$")  -- 行尾
--map("n", "J", "5j") -- 向下5行
--map("n", "K", "5k") -- 向上5行

--window management
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split"})

-- map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
-- map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
-- map("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
-- map("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })

--clear hignlights aftering "/"-finding
map("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

--run C code
map("n", "<leader>rc", "<leader>tt gcc % -o %:r && ./%:r<CR>", { desc = "Run this C code" })

--start from here,followed are terminal window settings,
-- 增强版终端开关（水平分屏）
vim.keymap.set('n', '<leader>tt', function()
  -- 安全获取所有终端缓冲区
  local terminals = vim.tbl_filter(function(buf)
    return buf.variables and buf.variables.buftype == "terminal"
  end, vim.fn.getbufinfo({buflisted = 1}))

  if #terminals > 0 then
    -- 跳转到最近使用的终端
    vim.cmd('sb ' .. terminals[#terminals].bufnr)
    vim.cmd('startinsert')  -- 自动进入插入模式
  else
    -- 新建水平分屏终端
    vim.cmd('split | terminal')
    vim.cmd('startinsert')
  end
end, { desc = 'Toggle terminal (horizontal)' })

-- 增强版运行终端
local run_term = {
  buf = nil,
  job_id = nil,
  setup = function(self)
    if not (self.buf and vim.api.nvim_buf_is_valid(self.buf)) then
      vim.cmd('split | terminal')
      self.buf = vim.api.nvim_get_current_buf()
      self.job_id = vim.b.terminal_job_id
      vim.cmd('startinsert')
    end
    return self.buf, self.job_id
  end
}

vim.keymap.set('n', '<F5>', function()
  vim.cmd('w')  -- 保存文件
  
  -- 获取或创建终端
  local _, job_id = run_term:setup()
  vim.cmd('sb ' .. run_term.buf)
  
  -- 文件类型对应的命令
  local ft_cmds = {
    c = 'gcc % -o %:r && ./%:r',
    cpp = 'g++ % -o %:r && ./%:r',
    python = 'python %',
    javascript = 'node %',
    lua = 'lua %',
    sh = 'bash %',
    rust = 'cargo run'
  }
  
  -- 发送运行命令
  local cmd = ft_cmds[vim.bo.filetype] or 'echo "Unsupported filetype"'
  vim.api.nvim_chan_send(job_id, cmd .. '\r')
end, { desc = 'Run current file' })

-- 增强窗口导航（支持终端模式）
vim.keymap.set({'n', 't'}, '<A-h>', '<C-\\><C-n><C-w>h', { desc = 'Move left' })
vim.keymap.set({'n', 't'}, '<A-j>', '<C-\\><C-n><C-w>j', { desc = 'Move down' })
vim.keymap.set({'n', 't'}, '<A-k>', '<C-\\><C-n><C-w>k', { desc = 'Move up' })
vim.keymap.set({'n', 't'}, '<A-l>', '<C-\\><C-n><C-w>l', { desc = 'Move right' })
--terminal window settings end
--terminal window settings end

local c_runner = {
    term_buf = nil,
    term_job = nil,
    setup = function(self)
        -- 安全获取终端信息
        local function get_terminal_info()
            if not self.term_buf or not vim.api.nvim_buf_is_valid(self.term_buf) then
                return nil, nil
            end
            return self.term_buf, self.term_job
        end

        local buf, job = get_terminal_info()
        if buf then return buf, job end

        -- 新建终端（带错误处理）
        local success, err = pcall(function()
            vim.cmd('split | terminal')
            self.term_buf = vim.api.nvim_get_current_buf()
            self.term_job = vim.b.terminal_job_id
            vim.cmd('startinsert')
        end)

        if not success then
            vim.notify("Failed to create terminal: " .. err, vim.log.levels.ERROR)
            return nil, nil
        end

        return self.term_buf, self.term_job
    end
}

vim.keymap.set('n', '<F5>', function()
    -- 保存文件并获取路径
    if vim.bo.modified then vim.cmd('w') end
    local src_file = vim.fn.expand('%:p')
    local bin_name = vim.fn.expand('%:t:r')
    local dir = vim.fn.expand('%:p:h')

    -- 构建安全命令
    local compile_cmd = table.concat({
        'echo "[Compiling $(basename '..src_file..')]..."',
        'mkdir -p "'..dir..'"',
        'gcc -Wall -Wextra -g "'..src_file..'" -o "'..dir..'/'..bin_name..'"',
        'echo "[Running]\n------------------------"',
        'cd "'..dir..'" && "./'..bin_name..'"',
        'echo "\n[Program exited with status $?]"'
    }, ' && ')

    -- 获取或创建终端
    local buf, job_id = c_runner:setup()
    if not job_id then return end

    -- 发送命令（带延迟确保终端就绪）
    vim.defer_fn(function()
        vim.api.nvim_chan_send(job_id, compile_cmd..'\r')
        vim.cmd('wincmd j')  -- 跳转到终端窗口
    end, 100)
end, { desc = 'Compile & Run C Program' })

-- 终端窗口增强配置
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { buffer = true })
vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>', { buffer = true })
