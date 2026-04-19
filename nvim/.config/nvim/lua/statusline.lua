local M = {}

function M.setup()
    local function short_filepath()
        local path = vim.fn.expand("%:p"); local home = vim.loop.os_homedir()
        if path:sub(1, #home) == home then
            path = "~" .. path:sub(#home + 1)
        end
        local parts = vim.split(path, "/", { trimempty = true }); local count = #parts
        return table.concat({
            parts[count - 2] or "",
            parts[count - 1] or "",
            parts[count] or "",
        }, "/")
    end

    function _G.statusline_insert()
        local file = short_filepath()
        return table.concat({ "%*", file, })
    end

    local stl = vim.go.statusline
    stl = stl:gsub("%%<%%f", "%%{%%v:lua.statusline_insert()%%}", 1)
    stl = stl:gsub("%%f", "%%{%%v:lua.statusline_insert()%%}", 1)
    vim.go.statusline = " " .. stl .. " "
end

return M
