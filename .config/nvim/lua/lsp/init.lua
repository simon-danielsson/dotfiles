require("mason").setup()

require("mason-lspconfig").setup({
        ensure_installed = {
                "lua_ls",
                "pyright",
                "ts_ls",  -- newer fork of tsserver
                "rust_analyzer",
                "taplo",
                -- Note: gdscript is not available via mason
        },
})

local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

-- Lua language server
lspconfig.lua_ls.setup({
        settings = {
                Lua = {
                        workspace = { checkThirdParty = false },
                        diagnostics = { globals = { "vim" } },
                        telemetry = { enable = false },
                },
        },
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        single_file_support = true,
        root_dir = function(fname)
                -- Prefer Git repo if available
                local git_root = util.find_git_ancestor(fname)
                if git_root then return git_root end
                local root_pattern = util.root_pattern(
                        ".luarc.json",
                        ".luarc.jsonc",
                        ".luacheckrc",
                        ".stylua.toml",
                        "stylua.toml",
                        "selene.toml",
                        "selene.yml",
                        ".git"
                )
                local detected = root_pattern(fname)
                if detected == nil or detected == vim.fn.expand("~") then
                        local cwd = vim.fn.getcwd()
                        if cwd ~= vim.fn.expand("~") then
                                return cwd
                        end
                        return nil
                end

return detected
        end,
})

require('lspconfig').rust_analyzer.setup({
        on_attach = function(client, bufnr)
                if client.server_capabilities.documentFormattingProvider then
                        vim.api.nvim_create_autocmd("BufWritePre", {
                                buffer = bufnr,
                                callback = function()
                                        vim.lsp.buf.format({ async = false })
                                end,
                        })
                end
        end,
})

-- GDScript LSP (manual setup, not via Mason)
lspconfig.gdscript.setup({
        cmd = { "nc", "127.0.0.1", "6005" }, -- connects to Godot's built-in LSP server
        filetypes = { "gd", "gdscript" },
        root_dir = util.root_pattern("project.godot", ".git"),
        single_file_support = false,
})
