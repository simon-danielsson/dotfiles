local M = {}

local comment_strings = {
        lua        = { line = "--", block = { "--[[", "]]" } },
        python     = { line = "#", block = { '"""', '"""' } },
        csv        = { line = "#", block = { '"""', '"""' } },
        gdscript   = { line = "#", block = { '"""', '"""' } },
        javascript = { line = "//", block = { "/*", "*/" } },
        typst      = { line = "//", block = { "/*", "*/" } },
        typescript = { line = "//", block = { "/*", "*/" } },
        c          = { line = "//", block = { "/*", "*/" } },
        cpp        = { line = "//", block = { "/*", "*/" } },
        html       = { line = nil, block = { "<!--", "-->" } },
        css        = { line = nil, block = { "/*", "*/" } },
        sh         = { line = "#", block = nil },
        vim        = { line = '"', block = nil },
        markdown   = { line = nil, block = { "<!--", "-->" } },
        rust       = { line = "//", block = { "/*", "*/" } },
        toml       = { line = "#", block = nil },
}

local function get_comment_syntax()
        local ft = vim.bo.filetype
        local comment = comment_strings[ft] or {}
        return comment.line, comment.block
end

function M.toggle_line_comment()
        local line_cmt = get_comment_syntax()
        if not line_cmt then
                vim.notify("No line comment string for this filetype", vim.log.levels.WARN)
                return
        end
        local lnum = vim.fn.line(".")
        local line = vim.fn.getline(lnum)
        if line:match("^%s*" .. vim.pesc(line_cmt)) then
                line = line:gsub("^%s*" .. vim.pesc(line_cmt) .. "%s?", "", 1)
        else
                local indent = line:match("^%s*")
                line = indent .. line_cmt .. " " .. line:gsub("^%s*", "")
        end
        vim.fn.setline(lnum, line)
end

function M.toggle_visual()
        local line_cmt = get_comment_syntax()
        if not line_cmt then
                vim.notify("No line comment style defined", vim.log.levels.WARN)
                return
        end
        local start_line = vim.fn.line("v")
        local end_line = vim.fn.line(".")
        if start_line > end_line then
                start_line, end_line = end_line, start_line
        end
        local all_commented = true
        for lnum = start_line, end_line do
                local line = vim.fn.getline(lnum)
                if not line:match("^%s*" .. vim.pesc(line_cmt)) then
                        all_commented = false
                        break
                end
        end
        for lnum = start_line, end_line do
                local line = vim.fn.getline(lnum)
                local indent = line:match("^%s*") or ""
                if all_commented then
                        -- Use function as replacement to avoid literal "%1"
                        line = line:gsub("^([ \t]*)" .. vim.pesc(line_cmt) .. "%s?", function(lead)
                                return lead
                        end, 1)
                else
                        line = indent .. line_cmt .. " " .. line:sub(#indent + 1)
                end
                vim.fn.setline(lnum, line)
        end
end

vim.api.nvim_create_autocmd("FileType", {
        pattern = "gd",
        callback = function()
                vim.bo.commentstring = "# %s"
        end,
})
vim.api.nvim_create_autocmd("FileType", {
        pattern = "gdscript",
        callback = function()
                vim.bo.commentstring = "# %s"
        end,
})

function M.toggle_block_comment()
        local _, block_cmt = get_comment_syntax()
        if not block_cmt then
                vim.notify("No block comment style for this filetype", vim.log.levels.WARN)
                return
        end
        local start_line = vim.fn.getpos("'<")[2]
        local end_line = vim.fn.getpos("'>")[2]
        local lines = vim.fn.getline(start_line, end_line)
        table.insert(lines, 1, block_cmt[1])
        table.insert(lines, block_cmt[2])
        vim.fn.setline(start_line, lines)
end

return M
