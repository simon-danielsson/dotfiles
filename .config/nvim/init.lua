-- ~/.config/nvim/init.lua

require("native.options")
require("native.keymaps")
require("native.comment")
require("native.netrw")
require("native.autocmds")
require("native.colorscheme")
require("native.statusline")

-- Setup lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
                "git", "clone", "--filter=blob:none",
                "https://github.com/folke/lazy.nvim.git", "--branch=stable",
                lazypath,
        })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")

-- Load LSP
require("lsp")

-- tmux
if os.getenv("TMUX") then
        vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
                callback = function()
                        local name = vim.fn.expand("%:t")
                        if name == "" then name = "[No Name]" end
                        vim.fn.system({ "tmux", "rename-window", name })
                end,
        })
end

-- notify
_G.last_notify_message = ""
vim.notify = function(msg, level, opts)
        _G.last_notify_message = msg
        vim.fn.setreg("6", msg)
        return vim.notify_orig and vim.notify_orig(msg, level, opts) or vim.api.nvim_echo({{msg}}, true, {})
end
