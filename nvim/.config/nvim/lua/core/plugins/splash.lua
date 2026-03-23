local M = {}

local function center(lines)
    local width = vim.o.columns
    local out = {}

    for _, line in ipairs(lines) do
        local pad = math.max(0, math.floor((width - vim.fn.strdisplaywidth(line)) / 2))
        table.insert(out, string.rep(" ", pad) .. line)
    end

    return out
end

local function load_header()
    -- get directory of this script
    local script_path = debug.getinfo(1, "S").source:sub(2)
    local script_dir = vim.fn.fnamemodify(script_path, ":h")

    local file = script_dir .. "/splash-header.md"

    if vim.fn.filereadable(file) == 1 then
        local lines = vim.fn.readfile(file)
        local filtered = {}

        for _, line in ipairs(lines) do
            -- skip lines that start with "<"
            if not line:match("^%<") then
                table.insert(filtered, line)
            end
        end

        return filtered
    end
    return { "Neovim" }
end

local function render()
    -- only on a truly empty startup buffer
    if vim.fn.argc() > 0 then
        return
    end

    local cur = vim.api.nvim_get_current_buf()

    -- avoid replacing a real file / modified buffer
    if vim.bo[cur].modified or vim.api.nvim_buf_get_name(cur) ~= "" then
        return
    end

    local header = load_header()

    local footer = {
        -- "",
        -- "---- Neovim v0.12 ----",
        "Neovim v0.12",
        -- "",
        -- "------------",
        -- git_branch(),
        -- "",
        -- string.format("%s", vim.fn.fnamemodify(vim.loop.cwd(), ":~")),
        -- string.format("loaded: %d buffers", #vim.fn.getbufinfo({ buflisted = 1 })),
        -- "",
    }

    local content = {}
    vim.list_extend(content, center(header))
    vim.list_extend(content, center(footer))
    -- vertical centering
    local win_height = vim.api.nvim_win_get_height(0)
    local content_height = #content
    local top_pad = math.max(0, math.floor((win_height - content_height) / 2))

    local lines = {}

    -- add empty lines above
    for _ = 1, top_pad do
        table.insert(lines, "")
    end

    vim.list_extend(lines, content)
    vim.bo[cur].buftype = "nofile"
    vim.bo[cur].bufhidden = "wipe"
    vim.bo[cur].swapfile = false
    vim.bo[cur].modifiable = true
    vim.bo[cur].filetype = "nvim-splash"

    vim.api.nvim_buf_set_lines(cur, 0, -1, false, lines)

    -- buffer-local UI polish
    vim.bo[cur].modifiable = false
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.cursorline = false
    vim.wo.signcolumn = "no"
    vim.wo.foldcolumn = "0"
    vim.wo.list = false
    vim.wo.wrap = false
    vim.wo.statuscolumn = ""
    vim.wo.colorcolumn = ""
    vim.wo.spell = false

    -- simple highlights
    vim.api.nvim_set_hl(0, "NvimSplashFooter", { link = "Comment" })

    local ns = vim.api.nvim_create_namespace("native-splash")
    for i = 1, #header do
        if header[i] ~= "" then
            vim.api.nvim_buf_add_highlight(cur, ns, "SplashHeader", top_pad + i - 1, 0, -1)
        end
    end

    local footer_start = #lines - #footer
    for row = footer_start, #lines - 1 do
        vim.api.nvim_buf_add_highlight(cur, ns, "NvimSplashFooter", row, 0, -1)
    end

    vim.api.nvim_win_set_cursor(0, { #header + 2, 0 })
end

function M.setup()
    -- hide builtin intro; `shortmess+=I` disables it
    vim.opt.shortmess:append("I")

    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            vim.schedule(render)
        end,
    })

    -- re-center if the window is resized while splash is visible
    vim.api.nvim_create_autocmd("VimResized", {
        callback = function()
            if vim.bo.filetype == "nvim-splash" then
                vim.bo.modifiable = true
                render()
            end
        end,
    })
end

return M
