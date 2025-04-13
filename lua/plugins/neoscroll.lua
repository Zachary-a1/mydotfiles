
return {
  "karb94/neoscroll.nvim",
  enabled = false
  -- {
  --   "karb94/neoscroll.nvim",
  --   event = "WinScrolled",  -- 滚动事件才加载，提升启动速度
  --   config = function()
  --     require('neoscroll').setup({
  --       hide_cursor = true,       -- 滚动时隐藏光标
  --       stop_eof = true,          -- 到文件底部就停
  --       respect_scrolloff = true -- 不让光标跳来跳去
  --     })
  --
  --     -- 绑定滚动键（可选）
  --     local t = {}
  --     t['<ScrollWheelUp>']   = {'scroll', {'-4', 'true', '200'}}
  --     t['<ScrollWheelDown>'] = {'scroll', {'4', 'true', '200'}}
  --
  --     require('neoscroll.config').set_mappings(t)
  --   end
  -- }

}
