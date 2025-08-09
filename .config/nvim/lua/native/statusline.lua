-- Git branch
local function git_branch()
        local branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
        return branch ~= "" and "│  " .. branch or ""
end
_G.git_branch = git_branch

-- Define filetype icons with colors
local filetype_icons = require("native.icons").lang


-- Setup highlight groups for all filetype icons once
for ft, entry in pairs(filetype_icons) do
        local hl_group = "FileIcon_" .. ft
        vim.api.nvim_set_hl(0, hl_group, { fg = entry.color, bg = "#262626" })
end

-- Function to get the file icon with color highlight codes embedded for statusline
local function file_type_icon()
        local ft = vim.bo.filetype
        local entry = filetype_icons[ft]
        if not entry then
                return ft or ""
        end
        local hl_group = "FileIcon_" .. ft
        return entry.icon
end
_G.file_type_icon = file_type_icon


-- File size
local function file_size()
        local size = vim.fn.getfsize(vim.fn.expand('%'))
        if size < 0 then return "" end
        if size < 1024 then
                return size .. "B "
        elseif size < 1024 * 1024 then
                return string.format("%.1fK", size / 1024)
        else
                return string.format("%.1fM", size / 1024 / 1024)
        end
end
_G.file_size = file_size

-- Diagnostics
function _G.diagnostics_error()
        local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        return count > 0 and (require("native.icons").diagn.error .. " " .. count .. " ") or ""
end
function _G.diagnostics_warn()
        local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        return count > 0 and (require("native.icons").diagn.warning .. " " .. count .. " ") or ""
end
function _G.diagnostics_info()
        local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        return count > 0 and (require("native.icons").diagn.information .. " " .. count .. " ") or ""
end
function _G.diagnostics_hint()
        local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        return count > 0 and (require("native.icons").diagn.hint .. " " .. count .. " ") or ""
end
function _G.diagnostics_summary()
        for _, level in ipairs({
                vim.diagnostic.severity.ERROR,
                vim.diagnostic.severity.WARN,
                vim.diagnostic.severity.INFO,
                vim.diagnostic.severity.HINT,
        }) do
                if #vim.diagnostic.get(0, { severity = level }) > 0 then
                        return "│ "
                end
        end
        return ""
end

-- Mode indicator
function _G.mode_icon()
        local mode = vim.fn.mode()
        local modes = {
                n = " ", i = " ", v = " ", V = " ",
                ["\22"] = "󰈚 ", c = " ", s = " ",
                S = " ", ["\19"] = "󰈚 ", R = " ",
                r = " ", ["!"] = " ", t = " ",
        }
        return modes[mode] or " " .. mode:upper()
end

-- Short filepath (last 3 parts)
function _G.short_filepath()
        local path = vim.fn.expand("%:p")
        local parts = {}
        for part in string.gmatch(path, "[^/]+") do
                table.insert(parts, part)
        end
        local count = #parts
        return table.concat({ parts[count - 2] or "", parts[count - 1] or "", parts[count] or "" }, "/")
end

-- Highlights
local function fg_bg(background, bold)
        return { fg = "#ffffff", bg = background or "#262626", bold = bold }
end

-- Base highlights
for _, group in ipairs({
        "StatusFilename", "StatusGit", "StatusFileType", "StatusLine",
        "StatusFileSize", "StatusLSP", "ColumnPercentage", "StatusModified"
}) do
        vim.api.nvim_set_hl(0, group, fg_bg("#262626", false))
end

-- Special highlights
vim.api.nvim_set_hl(0, "ColumnPercentage", fg_bg("#262626", true))
vim.api.nvim_set_hl(0, "StatusMode",       fg_bg("#444444", true))
vim.api.nvim_set_hl(0, "StatusPosition",   fg_bg("#444444", true))
vim.api.nvim_set_hl(0, "StatusModified",   { fg = "#e06c75", bg = "#262626", bold = true })

-- Diagnostic highlights linked to theme
vim.api.nvim_set_hl(0, "StatusDiagnosticsError", { link = "DiagnosticError" })
vim.api.nvim_set_hl(0, "StatusDiagnosticsWarn",  { link = "DiagnosticWarn" })
vim.api.nvim_set_hl(0, "StatusDiagnosticsInfo",  { link = "DiagnosticInfo" })
vim.api.nvim_set_hl(0, "StatusDiagnosticsHint",  { link = "DiagnosticHint" })

vim.opt.statusline = table.concat({
        "%#StatusMode#",       "  %{v:lua.mode_icon()} ",
        "%#StatusLine#",
        "%#StatusFileType#",   " %{v:lua.file_type_icon()}",
        "%#StatusFilename#",   " %{v:lua.short_filepath()}",
        "%#StatusGit#",        " %{v:lua.git_branch()}",
        "%=",
        "%#StatusDiagnosticsError#", "%{v:lua.diagnostics_error()}",
        "%#StatusDiagnosticsWarn#",  "%{v:lua.diagnostics_warn()}",
        "%#StatusDiagnosticsInfo#",  "%{v:lua.diagnostics_info()}",
        "%#StatusDiagnosticsHint#",  "%{v:lua.diagnostics_hint()}",
        "%#StatusDiagnosticsSummary#", "%{v:lua.diagnostics_summary()}",
        "%#StatusFileSize#",         " %{v:lua.file_size()} ",
        "%#StatusFileSize#",         " %L ",
        "%#StatusPosition#",         " 󰟙 %l:%c ",
})
