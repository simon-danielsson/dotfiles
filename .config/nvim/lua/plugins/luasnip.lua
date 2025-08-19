vim.pack.add({
        {
                src = "https://github.com/L3MON4D3/LuaSnip",
                name = "luasnip",
                version = "2.4.0",
                sync = true,
                silent = true,
                build = "make install_jsregexp",
        },
        {
                src = "https://github.com/rafamadriz/friendly-snippets",
                name = "friendly-snippets",
                lazy = true, -- we will load snippets via LuaSnip
        }
})

local ls = require("luasnip")

-- Load your own snippets
require("luasnip.loaders.from_lua").lazy_load({
        paths = vim.fn.stdpath("config") .. "/snippets",
})

-- Load friendly-snippets automatically
require("luasnip.loaders.from_vscode").lazy_load()  -- friendly-snippets are in VSCode format

-- Optional: command to reload all snippets
vim.api.nvim_create_user_command("ReloadSnippets", function()
        ls.cleanup()
        require("luasnip.loaders.from_lua").lazy_load({
                paths = vim.fn.stdpath("config") .. "/snippets",
        })
        require("luasnip.loaders.from_vscode").lazy_load()
        vim.notify("Snippets reloaded!", vim.log.levels.INFO)
end, {})
