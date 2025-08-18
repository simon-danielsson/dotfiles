local map = vim.keymap.set

-- ======================================================
-- Leader
-- ======================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ======================================================
-- Local Navigation
-- ======================================================

map("n", "i", "<Nop>")
map("n", "I", "<Nop>")
map("n", "o", "<Nop>")
map("n", "O", "<Nop>")

map({ "n", "v" }, "n", "h",
{ desc = "Move left" })

map({ "n", "v" }, "i", "l",
{ desc = "Move right" })

map({'n', 'v' }, 'o', "v:count == 0 ? 'gk' : 'k'",
{ expr = true, silent = true,
desc = "Move up (through wrapped lines)" })

map({'n', 'v' }, 'e', "v:count == 0 ? 'gj' : 'j'",
{ expr = true, silent = true,
desc = "Move down (through wrapped lines)" })

map("n", ">", "nzzzv",
{ desc = "Next search result (centered)" })

map("n", "<", "Nzzzv",
{ desc = "Previous search result (centered)" })

map("n", "}", "}zz",
{ desc = "Next empty line (centered)" })

map("n", "{", "{zz",
{ desc = "Previous empty line (centered)" })

map("n", "<C-e>", function()
        vim.diagnostic.goto_prev()
        vim.cmd("normal! zz")
end, { desc = "Go to previous diagnostic" })

map("n", "<C-o>", function()
        vim.diagnostic.goto_next()
        vim.cmd("normal! zz")
end, { desc = "Go to next diagnostic" })

-- ======================================================
-- Global Navigation
-- ======================================================

map("n", "<leader>f", "<cmd>Ex<CR>",
{ desc = "Launch netrw", noremap = true, silent = true })

map("n", "_", function()
        local bufs = vim.api.nvim_list_bufs()
        -- Filter only listed and loaded buffers
        local open_bufs = {}
        for _, bufnr in ipairs(bufs) do
                if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_option(bufnr, "buflisted") then
                        table.insert(open_bufs, bufnr)
                end
        end
        if #open_bufs == 0 then return end
        local current = vim.api.nvim_get_current_buf()
        local idx = nil
        for i, bufnr in ipairs(open_bufs) do
                if bufnr == current then
                        idx = i
                        break
                end
        end
        local next_idx = (idx % #open_bufs) + 1
        vim.api.nvim_set_current_buf(open_bufs[next_idx])
end, { desc = "Cycle through open buffers with _" })

map('t', '<Esc><Esc>', '<C-\\><C-n>',
{ desc = 'Exit terminal mode' })

map("n", "-", function()
        vim.cmd("wincmd w")
end, { desc = "Cycle through splits" })

map('n', '<Left>', '<cmd>vertical resize +4<cr>',
{ desc = 'Increase Window Width' })

map('n', '<Right>', '<cmd>vertical resize -4<cr>',
{ desc = 'Decrease Window Width' })

-- ======================================================
-- General
-- ======================================================

map("n", "<Esc>", "<cmd>nohlsearch<CR>",
{ desc = "Clear search highlights" })

map("n", "<Leader>w", "<cmd>w<CR>",
{ desc = "Write" })

map("n", "<Leader>q", "<cmd>q<CR>",
{ desc = "Quit" })

map('n', 'q', '<nop>')
map('n', 'Q', 'q',
{ desc = 'Record macro' })

map('n', '<C-q>', 'Q',
{ desc = 'Replay last recorded macro' })

map('n', '<leader>å', function()
        vim.cmd('restart')
end,
{ desc = 'Restart Neovim' })

-- ======================================================
-- Folds
-- ======================================================

map('n', 'za', 'za',
{ desc = "Toggle fold under cursor" })

map('n', 'zo', 'zR',
{ desc = "Open all folds" })

map('n', 'zc', 'zM',
{ desc = "Close all folds" })

-- ======================================================
-- Editing
-- ======================================================

map("n", "<leader>,", [[:%s/<C-r><C-w>//gI<Left><Left><Left>]],
{ desc = "open %s//gI with cword" })

map('n', 'x', '"_x',
{ desc = "Delete single character without yanking to register" })

map("n", "<leader><CR>", "i<CR><Esc>",
{ desc = "Insert newline at cursor" })

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
        vim.cmd("normal! V")
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

local comment = require("native.comment")
map("n", "gcc", comment.toggle_line_comment, { desc = "Toggle line comment" })
map("x", "gc", comment.toggle_visual, { desc = "Toggle visual line comments" })
map("n", "gbc", comment.toggle_block_comment, { desc = "Toggle block comment" })
map("v", "gb", comment.toggle_visual, { desc = "Toggle visual block comments" })

-- Move selected lines up/down in visual mode using Shift and navigation keys
map("v", "<S-e>", ":m '>+2<CR>gv=gv", { desc = "Move selection down" })
map("v", "<S-o>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ======================================================
-- Plugins & LSP
-- ======================================================

-- LSP
map("n", "K", function() vim.lsp.buf.hover({ border = "rounded"}) end, opts)
map("n", "<C-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, opts)

local M = {}
function M.setup_lsp_keymaps(bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        map("n", "gd", vim.lsp.buf.definition, opts)
        map("n", "gr", vim.lsp.buf.references, opts)
end
return M
