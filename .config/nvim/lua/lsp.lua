local mason_plugins = {
        "https://github.com/williamboman/mason.nvim",
        "https://github.com/williamboman/mason-lspconfig.nvim",
        "https://github.com/neovim/nvim-lspconfig",
}

for _, plugin in ipairs(mason_plugins) do
        vim.pack.add({ { src = plugin, sync = true, silent = true } })
end

local has_mason, mason = pcall(require, "mason")
local has_mason_lsp, mason_lspconfig = pcall(require, "mason-lspconfig")
local has_lspconfig = pcall(require, "lspconfig")

if has_mason and has_mason_lsp and has_lspconfig then
        mason.setup({
                ui = {
                        border = "rounded",
                        icons = {
                                package_installed = "✓",
                                package_pending = "➜",
                                package_uninstalled = "✗"
                        }
                }
        })
        mason_lspconfig.setup({
                ensure_installed = { "lua_ls", "ruff", "pyright", "rust_analyzer" },
                automatic_installation = false,
        })
end
