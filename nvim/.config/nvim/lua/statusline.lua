local theme = require("theme")

local M = {}

function M.setup()
    function _G.short_filepath()
        local path = vim.fn.expand("%:p")
        local home = vim.loop.os_homedir()

        if path:sub(1, #home) == home then
            path = "~" .. path:sub(#home + 1)
        end

        local parts = vim.split(path, "/", { trimempty = true })
        local count = #parts

        return table.concat({
            parts[count - 2] or "",
            parts[count - 1] or "",
            parts[count] or "",
        }, "/")
    end

    function _G.statusline_wordcount()
        local ft = vim.bo.filetype
        if ft ~= "markdown" and ft ~= "text" then
            return ""
        end
        return tostring(vim.fn.wordcount().words or 0)
    end

    function _G.ftype()
        local name = vim.fn.expand('%:p')
        local ext = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":e")
        local devicons_ok, devicons = pcall(require, 'nvim-web-devicons')
        local icon, color;
        if not devicons_ok then
            devicons = nil
            icon = "x"
            color = "#ffffff"
        else
            icon, color = devicons.get_icon_color(name, ext)
        end

        vim.api.nvim_set_hl(0, "StatusLineFType", { bg = color })
        return icon
    end

    vim.o.statusline = table.concat({
        "%#StatusLineFType#" .. " ",
        "%#Comment#" .. " ",
        "%{v:lua.ftype()}",
        "%#Normal#" .. " ",
        "%{v:lua.short_filepath()}",
        "%=",
        "%#Comment#",
        "%{v:lua.statusline_wordcount()}",
    }, "")
end

return M
