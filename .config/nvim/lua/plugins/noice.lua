local icons = require("ui.icons").noice

local plugins = {
        { src = "https://github.com/rcarriga/nvim-notify", version = "master", sync = true, silent = true },
        { src = "https://github.com/MunifTanjim/nui.nvim", version = "master", sync = true, silent = true },
        { src = "https://github.com/folke/noice.nvim", version = "v4.10.0", sync = true, silent = true },
}
for _, plugin in ipairs(plugins) do
        vim.pack.add({ plugin })
end

local highlights = {
        "NoiceCmdlinePopupBorder",
        "NoiceCmdlinePopup",
        "NoicePopupmenuBorder",
        "NoicePopupmenu"
}
for _, group in ipairs(highlights) do
        vim.cmd(string.format("highlight %s guibg=NONE", group))
end

local has_notify, notify = pcall(require, "notify")
if has_notify then
        vim.notify = notify.setup({
                stages = "static",
                timeout = 5000,
                background_colour = "#000000",
        })
end

local has_noice, noice = pcall(require, "noice")
if has_noice then
        noice.setup({
                cmdline = {
                        format = {
                                cmdline = { icon = icons.cmdline, title = "" },
                                search_down = { icon = icons.search_down},
                                search_up = { icon = icons.search_up},
                                filter = { icon = icons.filter},
                                lua = { icon = icons.lua},
                                help = { icon = icons.help},
                        },
                },
                lsp = {
                        progress = { enabled = true },
                        signature = { enabled = true },
                        hover = { enabled = true },
                        message = { enabled = true },
                },
                presets = {
                        bottom_search = false,
                        command_palette = true,
                        long_message_to_split = true,
                        lsp_doc_border = true,
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
                        routes = {
                                filter = { event = "msg_show" },
                                view = "mini",
                        },
                },
        })
end
