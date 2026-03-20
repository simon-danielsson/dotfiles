local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local files_group = augroup("FileCommands", { clear = true })

autocmd({ "BufEnter", "BufWritePre" }, {
    group = files_group,
    pattern = "*",
    callback = function()
        local dir = vim.fn.expand("%:p:h")
        if vim.fn.isdirectory(dir) == 1 then
            vim.cmd("lcd " .. dir)
        end
    end,
    desc = "Auto-change cwd to folder of current buffer",
})

autocmd("BufNewFile", {
    group = files_group,
    command = "silent! 0r "
        .. vim.fn.stdpath("config")
        .. "/templates/template.%:e",
    desc = "If one exists, use a template when opening a new file",
})

autocmd("BufWritePre", {
    group = files_group,
    pattern = "*",
    callback = function()
        local dir = vim.fn.expand("%:p:h")
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
    desc = "Auto create directories before save",
})

-- Create undo directory if it doesn't exist
local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
