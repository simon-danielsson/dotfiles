local M       = {}

local cmd     = vim.cmd
local autocmd = vim.api.nvim_create_autocmd

function M.setup()
    autocmd("FileType", {
        pattern = { "markdown", "text" },
        callback = function()
            vim.opt_local.spell = true; vim.opt_local.spelllang = { "en" }
        end,
        desc = "Spell-checking inside markdown/text buffers",
    })

    vim.diagnostic.config({
        virtual_text = {
            current_line = true,
            spacing = 2,
            prefix = "",
        },

        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
    })

    -- preview color on hex/rgb codes etc.
    -- (only works with lsps that support this, ex: css_ls)
    vim.lsp.document_color.enable(true, nil, { style = '■ ' })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    vim.filetype.add({
        extension = {
            h = 'h',
            odin = 'odin',
            el = 'el',
            gd = 'gd'
        },
    })

    local lsp_servers = {
        rust_analyzer = {
            cmd = { 'rust-analyzer' },
            filetypes = { 'rust' },
            root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
            settings = {
                ['rust-analyzer'] = {
                    procMacro = {
                        enable = true,
                    },
                    cargo = {
                        buildScripts = {
                            enable = true,
                        },
                    },
                },
                lens = {
                    enable = true,
                    implementations = { enable = true },
                    references = {
                        adt = { enable = true },
                        enumVariant = { enable = true },
                        method = { enable = true },
                        trait = { enable = true },
                    },
                    run = { enable = true },
                },

            },
        },

        gopls = {
            cmd = { 'gopls' },
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
            root_markers = { "go.work", "go.mod", ".git" },
            settings = {
                gopls = {
                    gofumpt = true,
                    staticcheck = true,
                    analyses = {
                        unusedparams = true,
                        shadow = true,
                    },
                },
            },
        },

        ols = {
            cmd = { 'ols' },
            filetypes = { 'odin' },
            root_markers = { 'ols.json', 'odinfmt.json', '.git' },
            -- settings = {
            --     ['ols'] = {},
            -- },
        },

        taplo = {
            cmd = { 'taplo', 'lsp', 'stdio' },
            filetypes = { 'toml' },
            root_markers = { '.git' },
            settings = {
                ['taplo'] = {},
            },
        },

        bashls = {
            cmd = { 'bash-language-server', 'start' },
            filetypes = { 'bash', 'sh' },
            root_markers = { '.git' },
            settings = {
                bashIde = {},
            },
        },

        marksman = {
            cmd = { 'marksman', 'server' },
            filetypes = { 'markdown' },
            root_markers = { '.git' },
            capabilities = capabilities,
        },

        pyright = {
            cmd = { 'pyright-langserver', '--stdio' },
            filetypes = { 'python' },
            root_markers = {
                'pyproject.toml',
                'setup.py',
                '.git',
            },
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "basic",
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                    },
                },
            },
        },

        gdscript = {
            cmd = {
                'nc',
                '127.0.0.1',
                '6005',
            },
            filetypes = { 'gd', 'gdscript' },
            root_markers = {
                'project.godot',
            },
        },

        clangd = {
            cmd = {
                'clangd',
                '--background-index',
                '--enable-config',
                '--clang-tidy',
                '--completion-style=detailed',
                '--header-insertion=iwyu',
            },
            filetypes = { 'c', 'h', 'cpp', 'objc', 'objcpp' },
            root_markers = {
                'compile_commands.json',
                'compile_flags.txt',
                '.git',
            },
        },

        tsserver = {
            cmd = { 'typescript-language-server', '--stdio' },
            filetypes = {
                'javascript',
                'javascriptreact',
                'typescript',
                'typescriptreact',
            },
            root_markers = { 'package.json', 'tsconfig.json', '.git' },
            settings = {
                typescript = {
                    inlayHints = {
                        includeInlayParameterNameHints = "all",
                    },
                },
                javascript = {
                    inlayHints = {
                        includeInlayParameterNameHints = "all",
                    },
                },
            },
        },

        lua_ls = {
            cmd = { 'lua-language-server' },
            filetypes = { 'lua' },
            root_markers = { '.git', '.luarc.json', '.luarc.jsonc' },
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                    },
                    diagnostics = {
                        globals = { 'vim' },
                        disable = { 'redefined-local' },
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME,
                        },
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        },

        cssls = {
            cmd = { 'vscode-css-language-server', '--stdio' },
            filetypes = { 'css', 'scss', 'less' },
            capabilities = capabilities,
        },

        html = {
            cmd = { 'vscode-html-language-server', '--stdio' },
            filetypes = { 'html' },
            capabilities = capabilities,
        },
    }

    for name, config in pairs(lsp_servers) do
        vim.lsp.config(name, config); vim.lsp.enable(name)
    end

    -- =========================================================
    -- !!! lsp/format
    -- =========================================================

    autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
            local ft = vim.bo.filetype
            local ignore = {
                ["markdown"]  = true,
                ["make"]      = true,
                ["el"]        = true,
                ["text"]      = true,
                ["typ"]       = true,
                ["gitignore"] = true,
                ["ana"]       = true,
                [""]          = true,
            }
            if ignore[ft] then return end
            local has_lsp = #vim.lsp.get_clients({ bufnr = 0 }) > 0; local pos = vim.api.nvim_win_get_cursor(0)
            if has_lsp then
                vim.lsp.buf.format({ async = false })
            end
            if ft == "c" then
                cmd("normal! gg=G")
            elseif ft == "rust" then
                cmd("normal! gg=G")
            elseif ft == "bash" then
                cmd("normal! gg=G")
            elseif ft == "python" then
                cmd("silent! %!black -q -")
                local pos = vim.api.nvim_win_get_cursor(0)
                cmd([[silent! %s/\s\+$//e]]); cmd([[silent! %s/\(\n\)\{3,}/\r\r/e]])
                vim.api.nvim_win_set_cursor(0, pos)
                cmd("normal! gg=G")
            elseif ft == "odin" then
                cmd("normal! gg=G")
            elseif not has_lsp then
                cmd("normal! gg=G")
            end
            local line = math.min(pos[1], vim.api.nvim_buf_line_count(0))
            pcall(vim.api.nvim_win_set_cursor, 0, { line, pos[2] })
        end,
        desc = "Format on save with LSP; force gg=G after format for C/Rust files",
    })

    -- =========================================================
    -- !!! lsp/completion
    -- =========================================================

    vim.opt.completeopt = { "noselect", "menu", "menuone", "popup" }
    vim.o.inccommand    = 'nosplit'; vim.opt.pumborder = "rounded"

    -- code
    autocmd("LspAttach", {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if not client then return end

            local cp = client.server_capabilities.completionProvider
            if cp then
                cp.triggerCharacters = cp.triggerCharacters or {}
                for c in ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ._"):gmatch(".") do
                    if not vim.tbl_contains(cp.triggerCharacters, c) then
                        table.insert(cp.triggerCharacters, c)
                    end
                end
            end

            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true, })
        end,
    })

    -- commandline
    autocmd("CmdlineChanged", {
        pattern = { ":", "/", "?" },
        callback = function() vim.fn.wildtrigger() end,
    })
end

return M
