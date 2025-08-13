-- ~/.config/nvim/init.lua

-- ======================================================
-- Native config setup
-- ======================================================

require("native.options")
require("native.comment")
require("native.autocmds")
require("native.colorscheme")
require("native.statusline")
require("native.netrw")

require("native.keymaps")

-- ======================================================
-- Plugins
-- ======================================================

require("plugins.indent-blankline")
require("plugins.nvim-treesitter")
require("plugins.nvim-telescope")
require("plugins.undotree")
require("plugins.noice")
require("plugins.cmp")

require("plugins.keymaps")

-- ======================================================
-- LSP
-- ======================================================

require("lsp")
-- ======================================================
-- TMUX
-- ======================================================

if os.getenv("TMUX") then
        vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
                callback = function()
                        local name = vim.fn.expand("%:t")
                        if name == "" then name = "[No Name]" end
                        vim.fn.system({ "tmux", "rename-window", name })
                end,
        })
end

-- ======================================================
-- Notify
-- ======================================================

-- _G.last_notify_message = ""
-- vim.notify = function(msg, level, opts)
        -- _G.last_notify_message = msg
        -- vim.fn.setreg("6", msg)
        -- return vim.notify_orig and vim.notify_orig(msg, level, opts) or vim.api.nvim_echo({{msg}}, true, {})
        -- end
