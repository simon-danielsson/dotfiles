local M       = {}

local g       = vim.g; local bo = vim.bo
local cmd     = vim.cmd; local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd;

function M.setup()
    g.netrw_altfile        = 1; vim.g.netrw_fastbrowse = 2
    g.netrw_liststyle      = 3; g.netrw_banner = 0; g.netrw_dirhistmax = 0
    g.netrw_preview        = 1; g.netrw_keepdir = 0; bo.bufhidden = "wipe"
    vim.g.netrw_localrmdir = "rm -r"

    map("n", "<leader>f", function()
        local dir = vim.fn.getcwd()
        cmd("Explore " .. vim.fn.fnameescape(dir))
    end)

    autocmd({ "FileType", "BufWinEnter" }, {
        pattern = "netrw",
        callback = function()
            local opts = { buffer = true, noremap = true, silent = true }
            map("n", "n", "h", opts)
            map("n", "e", "j", opts)
            map("n", "o", "k", opts)
            map("n", "i", "l", opts)
            vim.wo.relativenumber = true
            vim.wo.number = true
        end,
    })
end

return M
