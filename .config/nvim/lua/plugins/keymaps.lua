local map = vim.keymap.set
local function common(descr)
        return { desc = descr, noremap = true, silent = true }
end

-- ======================================================
-- Telescope
-- ======================================================

map("n", "<leader>t", "<cmd>Telescope<cr>", common("Telescope"))
map("n", "<leader>b", "<cmd>Telescope buffers<cr>", common("Current buffers"))
map("n", "<leader>d", "<cmd>Telescope diagnostics<cr>", common("List diagnostics"))
map("n", "<leader>r", "<cmd>Telescope oldfiles<cr>", common("Recent files"))
map("n", "<leader>k", "<cmd>Telescope keymaps<cr>", common("Keymaps"))
map("n", "<leader>g", "<cmd>Telescope live_grep<cr>", common("Local grep"))

-- ======================================================
-- UndoTree
-- ======================================================

map("n", "<leader>u", "<cmd>UndotreeToggle<CR>", common("Toggle Undotree"))

-- ======================================================
-- Silicon
-- ======================================================

map({ 'n', 'v' }, '<leader>s', function()
                vim.cmd('Silicon')
        end,
        { desc = 'Silicon' })

-- ======================================================
-- Flash
-- ======================================================

local flash = require("flash")
map({ "n", "x", "o" }, "s", flash.jump, { desc = "Flash" })
map({ "n", "x", "o" }, "S", flash.treesitter, { desc = "Flash Treesitter" })
map("o", "r", flash.remote, { desc = "Remote Flash" })
map({ "o", "x" }, "R", flash.treesitter_search, { desc = "Treesitter Search" })
map("c", "<C-s>", flash.toggle, { desc = "Toggle Flash Search" })
