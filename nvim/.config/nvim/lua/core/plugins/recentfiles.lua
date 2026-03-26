local M = {}

local defaults = {
    title = "Recent files",
    exclude_current = true,
    open_cmd = "copen",
    qf_mappings = true,
    keymap = "<leader>r",
    desc = "Open recent files",
    notify = false,
}

M.config = vim.deepcopy(defaults)

local function get_opts(opts)
    return vim.tbl_deep_extend("force", {}, M.config, opts or {})
end

local function normalize_path(path)
    return vim.fn.fnamemodify(path, ":~:.")
end

local function is_readable_file(path)
    return path ~= "" and vim.fn.filereadable(path) == 1
end

local function collect_oldfiles(opts)
    local seen = {}
    local items = {}
    local current = vim.api.nvim_buf_get_name(0)

    for _, path in ipairs(vim.v.oldfiles or {}) do
        local skip =
            not is_readable_file(path)
            or seen[path]
            or (opts.exclude_current and path == current)

        if not skip then
            seen[path] = true
            items[#items + 1] = path
        end
    end

    return items
end

function M.quickfix_text(info)
    local qf_items = vim.fn.getqflist({ id = info.id, items = 1 }).items
    local lines = {}

    for i = info.start_idx, info.end_idx do
        local item = qf_items[i]
        local name = ""

        if item and item.bufnr > 0 then
            name = vim.api.nvim_buf_get_name(item.bufnr)
        elseif item and item.text then
            name = item.text
        end

        local file = vim.fn.fnamemodify(name, ":t")
        local dir = vim.fn.fnamemodify(name, ":h")

        dir = normalize_path(dir)

        -- optional: ensure trailing slash
        if dir ~= "" and not dir:match("/$") then
            dir = dir .. "/"
        end

        lines[#lines + 1] = string.format("%-25s %s", file, dir)
    end

    return lines
end

function M.setqflist(opts)
    opts = get_opts(opts)

    local oldfiles = collect_oldfiles(opts)

    if vim.tbl_isempty(oldfiles) then
        if opts.notify then
            vim.notify("No recent files found", vim.log.levels.INFO)
        end
        return false
    end

    vim.fn.setqflist({}, " ", {
        title = opts.title,
        lines = oldfiles,
        efm = "%f",
        quickfixtextfunc = "v:lua.require'core.plugins.recentfiles'.quickfix_text",
    })

    return true
end

function M.open(opts)
    opts = get_opts(opts)

    if not M.setqflist(opts) then
        return
    end

    vim.cmd(opts.open_cmd)
end

function M.setup(opts)
    M.config = get_opts(opts)

    if M.config.keymap then
        vim.keymap.set("n", M.config.keymap, function()
            M.open()
        end, { desc = M.config.desc })
    end

    if M.config.qf_mappings then
        local group = vim.api.nvim_create_augroup("RecentFilesQuickfix", { clear = true })

        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = "qf",
            callback = function(args)
                local ns = vim.api.nvim_create_namespace("RecentFilesHighlight")

                vim.api.nvim_buf_clear_namespace(args.buf, ns, 0, -1)

                local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)

                for i, line in ipairs(lines) do
                    local file, path = line:match("^(%S+)%s+(.*)$")

                    if file and path then
                        local file_end = #file
                        local path_start = line:find(path, 1, true) - 1

                        -- filename → Normal (technically already default, but explicit is fine)
                        vim.api.nvim_buf_add_highlight(args.buf, ns, "Normal", i - 1, 0, file_end)

                        -- path → Comment
                        vim.api.nvim_buf_add_highlight(args.buf, ns, "Comment", i - 1, path_start, -1)
                    end
                end
                local qf_info = vim.fn.getqflist({ title = 1 })
                if qf_info.title ~= M.config.title then
                    return
                end

                vim.bo[args.buf].buflisted = false

                vim.keymap.set("n", "q", "<cmd>cclose<cr>", {
                    buffer = args.buf,
                    silent = true,
                    desc = "Close recent files",
                })

                vim.keymap.set("n", "<CR>", function()
                    local idx = vim.fn.line(".")
                    vim.cmd(("cc %d"):format(idx))
                    vim.cmd("cclose")
                end, {
                    buffer = args.buf,
                    silent = true,
                    desc = "Open recent file and close list",
                })
            end,
        })
    end
end

return M
