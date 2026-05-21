local M       = {}

local g       = vim.g; local bo = vim.bo
local cmd     = vim.cmd; local map = vim.keymap.set
local shl     = vim.api.nvim_set_hl
local autocmd = vim.api.nvim_create_autocmd;

function M.setup()
    g.netrw_altfile        = 1; vim.g.netrw_fastbrowse = 2
    g.netrw_liststyle      = 3; g.netrw_banner = 0; g.netrw_dirhistmax = 0
    g.netrw_preview        = 1; g.netrw_keepdir = 0; bo.bufhidden = "wipe"
    vim.g.netrw_localrmdir = "rm -r"

    g.netrw_sort_sequence  =
    [[[/]$,*~,\.bak$,\.o$,\.info$,\.swp$,\.obj$,
     \.pyc$,\.class$,
     \core\%(\.\d\+\)\=,
     \.(c|h|cpp|hpp|lua|py|rs|go|zig|ts|js)$,*]]
    shl(0, "netrwMarkFile", { link = "Visual" })

    -- keymaps

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

    -- close netrw preview on bufenter
    autocmd("FileType", {
        pattern = "netrw",
        callback = function(args)
            autocmd("BufLeave", {
                buffer = args.buf,
                once = true,
                callback = function()
                    cmd("pclose")
                end,
            })
        end,
    })
end

return M
