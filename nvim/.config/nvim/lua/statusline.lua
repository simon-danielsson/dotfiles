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
        return tostring(vim.fn.wordcount().words or 0) .. " words"
    end

    local function right_side()
        local stl = vim.o.statusline
        return stl:match("%%=(.*)$") or ""
    end

    local default_right = right_side()

    vim.o.statusline = table.concat({
        "%{v:lua.short_filepath()}",
        "%=",
        "%#Comment#%{v:lua.statusline_wordcount()}%#Normal#",
        default_right,
    }, " ")
end

return M
