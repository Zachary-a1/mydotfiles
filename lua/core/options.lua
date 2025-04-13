vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt         --opt是vim的选项接口

-- 取消鼠标影响
vim.o.mouse = "a"

--防止中文输入光标消失
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

--显示相关
opt.number = true           --显示绝对行号
opt.relativenumber = true   --显示相对行号
opt.cursorline = true       --高亮光标所在行

--缩进相关
opt.tabstop = 4             --Tab字符长度
opt.shiftwidth = 4          --缩进宽度
opt.expandtab = true        --用空格代替Tab
opt.smartindent = true      --智能缩进

--搜索相关
opt.ignorecase = true       --忽略大小写
opt.smartcase = true        --有大写时不忽略

--UI优化
opt.termguicolors = true    --开启真彩色
opt.signcolumn = "yes"      --显示符号列
opt.splitright = true      --垂直分割在右
opt.splitbelow = true      --水平分割在下

--系统剪贴板
opt.clipboard = "unnamedplus" --系统剪贴板共享

