local cmp_plugins = {
        "https://github.com/hrsh7th/nvim-cmp",
        "https://github.com/hrsh7th/cmp-nvim-lsp",
        "https://github.com/hrsh7th/cmp-buffer",
        "https://github.com/hrsh7th/cmp-path",
        "https://github.com/hrsh7th/cmp-cmdline",
        "https://github.com/f3fora/cmp-spell",
        "https://github.com/L3MON4D3/LuaSnip.git",
        "https://github.com/saadparwaiz1/cmp_luasnip.git",
}

for _, plugin in ipairs(cmp_plugins) do
        vim.pack.add({ { src = plugin, opt = true, sync = true, silent = true } })
end

local has_cmp, cmp = pcall(require, "cmp")
if has_cmp then
        local has_luasnip, luasnip = pcall(require, "luasnip")
        if has_luasnip then
                -- Load your Lua snippets from your custom folder
                require("luasnip.loaders.from_lua").lazy_load({
                        paths = "~/.config/nvim/snippets",
                })

                luasnip.setup {
                        history = true,
                        updateevents = "TextChanged,TextChangedI",
                        enable_autosnippets = true,
                }
        end

        cmp.setup({
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
                        { name = "luasnip" },
                        { name = "buffer" },
                        { name = "path" },
                        {
                                name = "spell",
                                option = {
                                        keep_all_entries = false,
                                        enable_in_context = function() return true end,
                                        preselect_correct_word = true,
                                },
                        },
                }),
        })

        cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                        { name = "cmdline" },
                },
        })
end
