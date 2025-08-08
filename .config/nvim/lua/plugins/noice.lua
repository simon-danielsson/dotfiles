return {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
                "MunifTanjim/nui.nvim",
                {
                        "rcarriga/nvim-notify",
                        config = function()
                                local notify = require("notify")
                                local original_notify = notify
                                vim.notify = function(msg, level, opts2)
                                        if type(msg) == "string" and msg:lower():find("cursor") then
                                                return
                                        end
                                        return original_notify(msg, level, opts2)
                                end
                                notify.setup({
                                        background_colour = "#1e1e2e",
                                })
                        end,
                },
        },
        opts = {
                notify = {
                        enabled = false, -- keep enabled globally
                        -- Optional: you can filter specific filetypes here
                        filter = {
                                event = "notify",
                                cond = function()
                                        return vim.bo.filetype ~= "oil"
                                end,
                        },
                },
                cmdline = {
                        format = {
                                cmdline = { icon = "", title = "" },
                                search_down = { icon = " " },
                                search_up = { icon = " " },
                                filter = { icon = " " },
                                lua = { icon = " " },
                                help = { icon = " " },
                        },
                },
                lsp = {
                        progress = { enabled = true },
                        signature = { enabled = true },
                        hover = { enabled = true },
                        message = { enabled = true },
                },
                presets = {
                        bottom_search = false,      -- Classic bottom cmdline for search
                        command_palette = true,    -- Cmdline + popup UI
                        long_message_to_split = true,
                        lsp_doc_border = true,     -- Add border to hover/signature help
                },
                views = {
                        cmdline_popup = {
                                position = {
                                        row = "50%",
                                        col = "50%",
                                },
                                size = {
                                        width = 60,
                                        height = "auto",
                                },
                                border = {
                                        style = "rounded",
                                },
                                win_options = {
                                        winblend = 0,
                                },
                        },
                        popupmenu = {
                                border = {
                                        style = "rounded",
                                },
                                win_options = {
                                        winblend = 0,
                                },
                        },
                        hover = {
                                border = {
                                        style = "rounded",
                                },
                                win_options = {
                                        winblend = 0,
                                },
                        },
                        mini = {
                                win_options = {
                                        winblend = 0,
                                },
                        },
                },
                popupmenu = {
                        backend = "nui",
                },
        },
        config = function(_, opts)
                require("noice").setup(opts)

-- Optional: transparent UI highlights
                vim.cmd([[
      highlight NoiceCmdlinePopupBorder guibg=NONE
      highlight NoiceCmdlinePopup guibg=NONE
      highlight NoicePopupmenuBorder guibg=NONE
      highlight NoicePopupmenu guibg=NONE
      ]])
        end,
}
