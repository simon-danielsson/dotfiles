local M   = {}

local cmd = vim.cmd
local map = vim.keymap.set
function M.setup()
    -- leader
    vim.g.mapleader      = " "; vim.g.maplocalleader = " "

    -- navigation: local
    map("n", "i", "<Nop>")
    map("n", "I", "<Nop>")
    map("n", "o", "<Nop>")
    map("n", "O", "<Nop>")

    map({ "n", "v" }, "n", "h", { desc = "Move left" })

    map({ "n", "v" }, "i", "l", { desc = "Move right" })

    map({ 'n', 'v' }, 'o', "v:count == 0 ? 'gk' : 'k'",
        {
            expr = true,
            silent = true,
            desc = "Move up (through wrapped lines)"
        })

    map({ 'n', 'v' }, 'e', "v:count == 0 ? 'gj' : 'j'",
        {
            expr = true,
            silent = true,
            desc = "Move down (through wrapped lines)"
        })

    map("n", ">", "nzv",
        { desc = "Next search result (centered)" })

    map("n", "<", "Nzv",
        { desc = "Previous search result (centered)" })

    local function on_jump(diagnostic, bufnr)
        if not diagnostic then
            return
        end
        vim.schedule(function()
            vim.diagnostic.open_float(bufnr, {
                scope = "line",
                pos = { diagnostic.lnum, diagnostic.col },
            })
        end)
    end
    map("n", "<C-e>", function()
        vim.diagnostic.jump({ count = -1, on_jump = on_jump })
    end, { desc = "Go to previous diagnostic" })

    map("n", "<C-o>", function()
        vim.diagnostic.jump({ count = 1, on_jump = on_jump })
    end, { desc = "Go to next diagnostic" })

    -- navigation: global

    map("n", "<leader>f", function()
        local dir = vim.fn.getcwd()
        cmd("Explore " .. vim.fn.fnameescape(dir))
    end)

    map("n", "<Left>", "<cmd>bprevious<cr>", { desc = "Go to prev buffer" })
    map("n", "<Right>", "<cmd>bnext<cr>", { desc = "Go to next buffer" })

    map("n", "<c-b>", function()
        local bufs = vim.fn.getbufinfo({ buflisted = 1 })
        if #bufs == 1 then
            cmd("update")
            cmd("quit")
        else
            cmd("update")
            cmd("bdelete")
        end
    end, { desc = "save & close buffer (or quit if last)" })

    map("n", ",", function()
        cmd("wincmd w")
    end, { desc = "Cycle through splits" })

    map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

    -- general

    map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

    -- editing

    map("n", "<leader>,", [[:%s/<C-r><C-w>//gI<Left><Left><Left>]],
        { desc = "open %s//gI with cword" })

    map({ "x", "v" }, "<leader>,", [[:s/<C-r><C-w>//gI<Left><Left><Left>]],
        { desc = "open visual s//gI with cword" })

    map('n', 'x', '"_x',
        { desc = "Delete single character without yanking to register" })

    map("n", "<leader><CR>", "i<CR><Esc>",
        { desc = "Insert newline at cursor in normal mode" })

    map("n", "<leader><BS>", "i<BS><Esc>",
        { desc = "Insert backspace at cursor in normal mode" })

    map("n", "<leader><leader>", "i<Space><Esc>",
        { desc = "Insert space at cursor in normal mode" })

    -- "vip" to go visual inside paragraph (had to be fixed since it broke when I remapped the movement keys)
    map("n", "vip", function()
        local cur_line = vim.api.nvim_win_get_cursor(0)[1]
        local total_lines = vim.api.nvim_buf_line_count(0)
        local top = cur_line
        while top > 1 and vim.fn.getline(top - 1):match("^%s*$") == nil do
            top = top - 1
        end
        local bottom = cur_line
        while bottom < total_lines and vim.fn.getline(bottom + 1):match("^%s*$") == nil do
            bottom = bottom + 1
        end
        vim.api.nvim_win_set_cursor(0, { top, 0 })
        cmd("normal! V")
        vim.api.nvim_win_set_cursor(0, { bottom, 0 })
    end, { desc = "Smart select paragraph" })

    -- New insert mode bindings
    map("n", "<leader>i", "i", { desc = "Insert before cursor" })
    map("n", "<leader>I", "I", { desc = "Insert at line start" })
    map("n", "<leader>o", "o", { desc = "Open new line below" })
    map("n", "<leader>O", "O", { desc = "Open new line above" })

    map("v", "<Tab>", ">gv", { desc = "Indent selection" })
    map("v", "<S-Tab>", "<gv", { desc = "Outdent selection" })
    map("n", "<Tab>", ">>", { desc = "Indent line" })
    map("n", "<S-Tab>", "<<", { desc = "Outdent line" })
    map("i", "<Tab>", "<C-t>", { desc = "Indent line in insert mode" })
    map("i", "<S-Tab>", "<C-d>", { desc = "Outdent line in insert mode" })

    -- Move selected lines up/down in visual mode using Shift and navigation keys
    map("v", "<S-o>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
    map("v", "<S-e>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

    -- lsp

    map("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end)
    map("n", "<C-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end)

    map("n", "å", function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.lsp.inlay_hint.enable(
            not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
            { bufnr = bufnr }
        )
    end, { desc = "Toggle Inlay Hints" })

    map("n", "gd", vim.lsp.buf.definition); map("n", "gr", vim.lsp.buf.references)
end

return M
