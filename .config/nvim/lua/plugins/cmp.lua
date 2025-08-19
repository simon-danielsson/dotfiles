-- Define plugins for vim.pack
local cmp_plugins = {
        "https://github.com/hrsh7th/nvim-cmp",
        "https://github.com/hrsh7th/cmp-nvim-lsp",
        "https://github.com/hrsh7th/cmp-buffer",
        "https://github.com/hrsh7th/cmp-path",
        "https://github.com/hrsh7th/cmp-cmdline",
        "https://github.com/L3MON4D3/LuaSnip.git",             -- Add LuaSnip
        "https://github.com/saadparwaiz1/cmp_luasnip.git",     -- Add LuaSnip integration for nvim-cmp
        "https://github.com/rafamadriz/friendly-snippets.git", -- Optional: VSCode-style snippets
}

-- Add plugins to vim.pack
for _, plugin in ipairs(cmp_plugins) do
        vim.pack.add({ { src = plugin, opt = true, sync = true, silent = true } })
end

-- -- Load plugins when needed (e.g., on InsertEnter)
-- vim.pack.load(
        -- { 'nvim-cmp', 'cmp-nvim-lsp', 'cmp-buffer', 'cmp-path', 'cmp-cmdline', 'LuaSnip', 'cmp_luasnip',
        -- 'friendly-snippets' },
        -- { event = 'InsertEnter' })

-- Configure nvim-cmp and LuaSnip
        local has_cmp, cmp = pcall(require, "cmp")
        if has_cmp then
                -- Load LuaSnip (required for snippet integration)
                local has_luasnip, luasnip = pcall(require, "luasnip")
                if has_luasnip then
                        -- Load VSCode-style snippets from friendly-snippets (optional)
                        require("luasnip.loaders.from_vscode").lazy_load()

-- Basic LuaSnip configuration
                        luasnip.setup {
                                history = true,                            -- Keep snippet history
                                updateevents = "TextChanged,TextChangedI", -- Update snippets dynamically
                                enable_autosnippets = true,                -- Enable auto-triggered snippets
                        }
                end

cmp.setup({
                        -- Add snippet support
                        snippet = {
                                expand = function(args)
                                        if has_luasnip then
                                                luasnip.lsp_expand(args.body)
                                        end
                                end,
                        },
                        window = {
                                completion = cmp.config.window.bordered({ border = "rounded" }),
                                documentation = cmp.config.window.bordered({ border = "rounded" }),
                        },
                        mapping = cmp.mapping.preset.insert({
                                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                                ["<Tab>"] = cmp.mapping(function(fallback)
                                        if cmp.visible() then
                                                cmp.select_next_item()
                                        elseif has_luasnip and luasnip.expand_or_jumpable() then
                                                luasnip.expand_or_jump()
                                        else
                                                fallback()
                                        end
                                end, { "i", "s" }),
                                ["<S-Tab>"] = cmp.mapping(function(fallback)
                                        if cmp.visible() then
                                                cmp.select_prev_item()
                                        elseif has_luasnip and luasnip.jumpable(-1) then
                                                luasnip.jump(-1)
                                        else
                                                fallback()
                                        end
                                end, { "i", "s" }),
                        }),
                        sources = cmp.config.sources({
                                { name = "nvim_lsp" },
                                { name = "luasnip" }, -- Add LuaSnip as a source
                                { name = "buffer" },
                                { name = "path" },    -- Include path source
                        }),
                })

-- Configure cmdline completion
                cmp.setup.cmdline(":", {
                        mapping = cmp.mapping.preset.cmdline(),
                        sources = {
                                { name = "cmdline" },
                        },
                })
        end
