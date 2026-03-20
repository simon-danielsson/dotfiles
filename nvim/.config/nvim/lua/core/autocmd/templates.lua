local autocmd = vim.api.nvim_create_autocmd

-- ==== Templates ====

local template_dir = vim.fn.stdpath("config") .. "/templates"

autocmd("BufNewFile", {
    pattern = "*",
    callback = function()
        local ft = vim.bo.filetype
        local file = vim.fn.expand("<afile>") or ""
        local ext = file:match("^.+(%..+)$") or ft
        local template_file = string.format("%s/%s%s", template_dir, ft, ext or "")
        if vim.fn.filereadable(template_file) == 0 then
            template_file = string.format("%s/%s", template_dir, file:match("^.+(%..+)$") or "")
        end
        if vim.fn.filereadable(template_file) == 1 then
            vim.cmd("0r " .. template_file)
        end
    end,
})
