-- 高亮复制的内容
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 300 })
    end,
})

-- 保存时自动格式化（后续可以配合 LSP）
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     pattern = "*.c,*.cpp,*.h",
--     callback = function()
--         vim.lsp.buf.format()
--     end,
-- })

