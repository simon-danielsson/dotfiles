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
        local f = theme.buffer_icon_col(vim.bo.filetype)

        vim.api.nvim_set_hl(0, "StatusLineFType", {
            fg = "#25252d",
            bg = f[3],
        })

        return f[2]
    end

    vim.o.statusline = table.concat({
        "%#StatusLineFType#" .. " ",
        "%{v:lua.ftype()}" .. " ",
        "%#Normal#" .. " ",
        "%{v:lua.short_filepath()}",
        "%=",
        "%#Comment#",
        "%{v:lua.statusline_wordcount()}" .. " ",
        "%#Normal#" .. " ",
        "%l:%c",
    }, "")
end

return M
