-- ======================================================
-- Setup
-- ======================================================
vim.o.cmdheight = 0
vim.o.shortmess = "filnxtToOF"
local icons = require("ui.icons").diagn
local M = {}

-- ======================================================
-- Settings
-- ======================================================

M.filter = {
        "deprecated",
        "TextYankPost",
        "faq",
        "Autocommands"
}

M.config = {
        timeout = 6000,
        max_width = 50,
        border = "rounded",
        top_margin = 2,
        right_margin = 3
}

-- ======================================================
-- Notify
-- ======================================================

M.notifications = {}
local level_hl = { INFO = "DiagnosticInfo", WARN = "DiagnosticWarn", ERROR = "DiagnosticError", HINT = "DiagnosticHint" }

M.diagn = icons

local function is_filtered(msg)
        for _, word in ipairs(M.filter) do if string.find(msg:lower(), word:lower(), 1, true) then return true end end
        return false
end

local function split_lines(str)
        local t = {}
        for s in str:gmatch("([^\n]+)") do
                table.insert(t, s)
        end
        return t
end

local function create_win(msg, level)
        local buf = vim.api.nvim_create_buf(false, true)
        local lines = {}
        local icon = ""

        if level == "ERROR" then
                level = "Error"
                icon = M.diagn.error
        elseif level == "WARN" then
                level = "Warning"
                icon = M.diagn.warning
        elseif level == "INFO" then
                level = "Info"
                icon = M.diagn.information
        elseif level == "HINT" then
                level = "Hint"
                icon = M.diagn.hint
        end

        table.insert(lines, icon .. " " .. level)

        -- handle multi-line messages safely
        for _, l in ipairs(split_lines(msg)) do
                for i = 1, math.ceil(#l / M.config.max_width) do
                        table.insert(lines, l:sub((i - 1) * M.config.max_width + 1, i * M.config.max_width))
                end
        end

        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

        local width = math.min(#msg + 4, M.config.max_width)
        local row = M.config.top_margin
        for _, win in ipairs(M.notifications) do
                if vim.api.nvim_win_is_valid(win) then
                        row = row + vim.api.nvim_win_get_height(win) + 2
                end
        end

        local col = vim.o.columns - width - M.config.right_margin
        local opts = {
                relative = "editor",
                width = width,
                height = #lines,
                row = row,
                col = col,
                style = "minimal",
                border = M.config.border,
        }
        local win = vim.api.nvim_open_win(buf, false, opts)
        vim.api.nvim_win_set_option(win, "winhl", "Normal:" .. (level_hl[level] or "Normal"))
        return buf, win
end
local function reflow()
        local row = M.config.top_margin
        for _, w in ipairs(M.notifications) do
                if vim.api.nvim_win_is_valid(w) then
                        local h = vim.api.nvim_win_get_height(w)
                        vim.api.nvim_win_set_config(w,
                                {
                                        relative = "editor",
                                        row = row,
                                        col = vim.o.columns - vim.api.nvim_win_get_width(w) -
                                            M.config.right_margin
                                })
                        row = row + h + 2
                end
        end
end

function M.notify(msg, level)
        if not msg or msg == "" then return end
        if is_filtered(msg) then return end
        level = level or "INFO"
        local buf, win = create_win(msg, level)
        table.insert(M.notifications, win)
        vim.defer_fn(function()
                if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
                for i, w in ipairs(M.notifications) do
                        if w == win then
                                table.remove(M.notifications, i)
                                break
                        end
                end
                reflow()
        end, M.config.timeout)
end

function M.info(msg) M.notify(msg, "INFO") end

function M.warn(msg) M.notify(msg, "WARN") end

function M.error(msg) M.notify(msg, "ERROR") end

function M.hint(msg) M.notify(msg, "HINT") end

vim.notify = function(msg, level, opts)
        local lvlmap = {
                [vim.log.levels.ERROR] = "ERROR",
                [vim.log.levels.WARN] = "WARN",
                [vim.log.levels.INFO] = "INFO",
                [vim.log.levels.DEBUG] = "HINT"
        }
        local lvl = lvlmap[level] or "INFO"
        M.notify(msg, lvl)
end

if vim.deprecate then
        vim.deprecate = function(name, alt, ver)
                M.notify(string.format("%s is deprecated, use %s instead (since %s)", name, alt or "N/A", ver or "?"),
                        "WARN")
        end
end

vim.api.nvim_out_write = function(msg)
        msg = msg:gsub("\r?\n$", "")
        if msg ~= "" then M.notify(msg, "INFO") end
end
vim.api.nvim_err_writeln = function(msg)
        msg = msg:gsub("\r?\n$", "")
        if msg ~= "" then M.notify(msg, "ERROR") end
end
vim.api.nvim_echo = function(chunks, history, opts)
        local texts = {}
        for _, c in ipairs(chunks) do table.insert(texts, c[1]) end
        local msg = table.concat(texts, " ")
        if msg ~= "" then M.notify(msg, "INFO") end
end

if vim.api.nvim_set_handler then
        vim.api.nvim_set_handler("msg_show", function(params)
                local chunks = params.content or {}
                local texts = {}
                for _, c in ipairs(chunks) do table.insert(texts, c[1]) end
                local msg = table.concat(texts, " ")
                if msg ~= "" then
                        local level = "INFO"
                        if params.kind == "echoerr" or msg:match("error") or msg:match("E%d+") then
                                level = "ERROR"
                        elseif msg:match("warn") then
                                level =
                                "WARN"
                        end
                        M.notify(msg, level)
                end
        end)
end

vim.api.nvim_create_user_command("W", function()
        local file = vim.fn.expand("%")
        vim.cmd("write!")
        local size = vim.fn.getfsize(file)
        local display = size < 1024 and size .. "B" or math.floor(size / 1024) .. "KB"
        M.info(file .. " written (" .. display .. ")")
end, { desc = "Write file with floating notification" })
vim.cmd("cabbrev w W")

local orig_print = print
print = function(...)
        local args = {}
        for i = 1, select("#", ...) do table.insert(args, tostring(select(i, ...))) end
        local msg = table.concat(args, " ")
        M.notify(msg, "INFO")
        orig_print(...)
end

vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
                vim.schedule(function()
                        local ft = vim.bo.filetype
                        if ft == "netrw" then return end
                        local ok, M = pcall(require, "native.notify")
                        if not ok then return end
                        local reg = vim.fn.getreg(vim.v.register)
                        local regtype = vim.fn.getregtype(vim.v.register)
                        local count, unit
                        if regtype == "V" then
                                unit = "lines"
                                count = #vim.fn.split(reg, "\n")
                        elseif regtype == "\22" then
                                unit = "block"
                                count = #reg:gsub("\n", "")
                        else
                                unit = "chars"
                                count = #reg
                        end
                        M.info(string.format("%d %s yanked", count, unit))
                end)
        end
})

return M
