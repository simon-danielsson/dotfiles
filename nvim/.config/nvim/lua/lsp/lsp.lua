-- local mason_plugins = {
-- 	"https://github.com/williamboman/mason.nvim",
-- 	"https://github.com/williamboman/mason-lspconfig.nvim",
-- }
--
-- for _, plugin in ipairs(mason_plugins) do
-- 	vim.pack.add({ { src = plugin, sync = true, silent = true } })
-- end
--
-- -- Load Mason
-- local mason = require("mason")
-- local mason_lspconfig = require("mason-lspconfig")
--
-- mason.setup({ ui = { border = "rounded" } })
--
-- mason_lspconfig.setup({
-- 	ensure_installed = { "lua_ls", "pyright", "rust_analyzer", "html", "cssls" },
-- })

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
                ensure_installed = { "lua_ls", "pyright", "rust_analyzer", "html", "cssls" },
                automatic_installation = false,
                exclude = {
                        "jdtls",
                }
        })
end

--
-- -- Helper: root detection
-- local function root_pattern(patterns)
-- 	return function(fname)
-- 		fname = fname or vim.api.nvim_buf_get_name(0)
-- 		for _, pattern in ipairs(patterns) do
-- 			local found = vim.fs.find(pattern, { path = vim.fs.dirname(fname), upward = true })[1]
-- 			if found then
-- 				return vim.fs.dirname(found)
-- 			end
-- 		end
-- 		return nil
-- 	end
-- end
--
-- -- root for Rust (Cargo.toml)
-- local function rust_root_dir(fname)
-- 	fname = fname or vim.api.nvim_buf_get_name(0)
-- 	local cargo_files = vim.fs.find("Cargo.toml", { path = vim.fs.dirname(fname), upward = true })
-- 	if cargo_files and #cargo_files > 0 then
-- 		return vim.fs.dirname(cargo_files[1]) -- top-most Cargo.toml
-- 	end
-- 	return nil
-- end
--
-- -- ==== Server configs (per-buffer) ====
-- local servers = {
-- 	lua_ls = {
-- 		cmd = { "lua-language-server" },
-- 		root_dir = root_pattern({ ".luarc.json", ".luarc.jsonc", ".git" }),
-- 		settings = {
-- 			Lua = {
-- 				workspace = { checkThirdParty = false },
-- 				diagnostics = { globals = { "vim" } },
-- 			},
-- 		},
-- 	},
-- 	pyright = {
-- 		cmd = { "pyright-langserver", "--stdio" },
-- 		root_dir = root_pattern({ "pyproject.toml", "setup.py", ".git" }),
-- 	},
--
-- 	-- HTML
-- 	html = {
-- 		cmd = { "vscode-html-language-server", "--stdio" },
-- 		root_dir = root_pattern({
-- 			"package.json",
-- 			"tsconfig.json",
-- 			"jsconfig.json",
-- 			".git",
-- 		}),
-- 	},
--
-- 	-- CSS / SCSS / LESS
-- 	cssls = {
-- 		cmd = { "vscode-css-language-server", "--stdio" },
-- 		root_dir = root_pattern({
-- 			"package.json",
-- 			"postcss.config.js",
-- 			"tailwind.config.js",
-- 			"tsconfig.json",
-- 			"jsconfig.json",
-- 			".git",
-- 		}),
-- 		settings = {
-- 			css = { validate = true },
-- 			scss = { validate = true },
-- 			less = { validate = true },
-- 		},
-- 	},
-- }
--
-- -- ==== Lua, Python, HTML, CSS (per-buffer) ====
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = { "lua", "python", "html", "css", "scss", "less" },
-- 	callback = function(args)
-- 		local ft = vim.bo[args.buf].filetype
--
-- 		-- map filetype -> server name
-- 		local server_name = ft
-- 		if ft == "lua" then server_name = "lua_ls" end
-- 		if ft == "python" then server_name = "pyright" end
-- 		if ft == "css" or ft == "scss" or ft == "less" then server_name = "cssls" end
-- 		if ft == "html" then server_name = "html" end
--
-- 		local config = servers[server_name]
-- 		if not config then return end
--
-- 		local root = config.root_dir()
-- 		if root then
-- 			vim.lsp.start(vim.tbl_extend("force", {
-- 				name = server_name,
-- 				buf = args.buf,
-- 				root_dir = root,
-- 			}, config))
-- 		end
-- 	end,
-- })
--
-- -- ==== Rust Analyzer (per-buffer) ====
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "rust",
-- 	callback = function(args)
-- 		local buf = args.buf
-- 		local ft = vim.bo[buf].filetype
-- 		if ft ~= "rust" then return end
--
-- 		local root = rust_root_dir()
-- 		if not root then return end
--
-- 		vim.lsp.start({
-- 			name = "rust_analyzer",
-- 			cmd = { "rust-analyzer" },
-- 			root_dir = root,
-- 			settings = {
-- 				["rust-analyzer"] = {
-- 					cargo = { allFeatures = true, loadOutDirsFromCheck = true },
-- 					procMacro = { enable = true },
-- 				},
-- 			},
-- 			buf = buf,
-- 		})
-- 	end,
-- })
