-- =========================
-- Mason + LSP (CLEAN SETUP)
-- =========================

-- Install plugins via vim.pack
local mason_plugins = {
    "https://github.com/williamboman/mason.nvim",
    "https://github.com/williamboman/mason-lspconfig.nvim",
    "https://github.com/neovim/nvim-lspconfig",
}

for _, plugin in ipairs(mason_plugins) do
    vim.pack.add({ { src = plugin, sync = true, silent = true } })
end

-- Require (fail loudly if broken)
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

-- Mason UI
mason.setup({
    ui = {
        border = "rounded",
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})

-- Ensure servers are installed
mason_lspconfig.setup({
    ensure_installed = { "lua_ls", "pyright", "rust_analyzer" },
})

-- vim.lsp.config("rust_analyzer", {
-- cmd = { vim.fn.expand("/Users/simondanielsson/.cargo/bin/rust-analyzer") }, -- ensures correct sysroot
-- filetypes = { "rust" },
-- root_markers = { "Cargo.toml", ".git" },
-- settings = {
-- ["rust-analyzer"] = {
-- cargo = { allFeatures = true, loadOutDirsFromCheck = true },
-- procMacro = { enable = true },
-- checkOnSave = true,
-- },
-- },
-- })
--
-- vim.lsp.enable("rust_analyzer")
