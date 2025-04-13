
return {
  "nvim-treesitter/nvim-treesitter",  -- 加载 nvim-treesitter 插件
  build = ":TSUpdate",  -- 安装或更新 parser 的命令
  event = { "BufReadPost", "BufNewFile" },  -- 延迟加载，只在打开文件时才加载插件
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",  -- 依赖 textobjects 插件，用于增强文本对象操作
  },
  config = function()
    -- 配置 nvim-treesitter 插件
    require("nvim-treesitter.configs").setup({
      
      -- 指定需要安装的语言解析器
      ensure_installed = {
        "lua", "c", "cpp", "python", "bash", "vim", "markdown", "rust"  -- 加入 rust 语言
      },
      auto_install = true,  -- 自动安装缺失的解析器

      -- 启用语法高亮
      highlight = {
        enable = true,  -- 启用语法高亮
        additional_vim_regex_highlighting = false,  -- 不使用额外的 Vim 正则表达式高亮
      },

      -- 启用自动缩进
      indent = {
        enable = true,  -- 启用缩进支持
      },

      -- 启用代码折叠功能（根据语法树折叠代码块）
      fold = {
        enable = true,  -- 启用折叠功能
      },

      -- 启用增量选择功能
      incremental_selection = {
        enable = true,  -- 启用增量选择
        keymaps = {
          init_selection = "<CR>",        -- 按下回车键开始选择
          node_incremental = "<TAB>",     -- 按下 TAB 键扩展选择
          node_decremental = "<S-TAB>",   -- 按下 Shift+TAB 键缩小选择
          scope_incremental = "<CR>",     -- 按下回车键扩展选择作用域
        },
      },

      -- 文本对象操作（配合 nvim-treesitter-textobjects 插件使用）
      textobjects = {
        select = {
          enable = true,  -- 启用文本对象选择
          lookahead = true,  -- 向前查看以确保目标有效
          keymaps = {
            ["af"] = "@function.outer",  -- 选择整个函数
            ["if"] = "@function.inner",  -- 选择函数内部
            ["ac"] = "@class.outer",     -- 选择整个类
            ["ic"] = "@class.inner",     -- 选择类内部
          },
        },
        move = {
          enable = true,  -- 启用文本对象跳转
          set_jumps = true,  -- 启用跳转
          goto_next_start = {
            ["]m"] = "@function.outer",  -- 跳转到下一个函数的开始
            ["]c"] = "@class.outer",     -- 跳转到下一个类的开始
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",  -- 跳转到上一个函数的开始
            ["[c"] = "@class.outer",     -- 跳转到上一个类的开始
          },
        },
      },
    })

    -- 代码折叠设置：使用 Treesitter 提供的折叠方法
    vim.o.foldmethod = "expr"  -- 设置折叠方式为 expr
    vim.o.foldexpr = "nvim_treesitter#foldexpr()"  -- 使用 Treesitter 语法树折叠表达式
    vim.o.foldlevel = 99  -- 默认不折叠（最大折叠级别）
  end,
}

