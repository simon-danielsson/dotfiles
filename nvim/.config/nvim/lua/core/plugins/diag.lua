local icons = require("core.ui.icons")

local M = {}

local defaults = {
    title = "Diagnostics",
    open_cmd = "copen",
    qf_mappings = true,
    keymap = "<leader>d",
    desc = "Open current buffer diagnostics",
    notify = false,
}

M.config = vim.deepcopy(defaults)

local function get_opts(opts)
    return vim.tbl_deep_extend("force", {}, M.config, opts or {})
end

local function normalize_path(path)
    return vim.fn.fnamemodify(path, ":~:.")
end

local function collect_buffer_diagnostics()
    local bufnr = vim.api.nvim_get_current_buf()
    local diagnostics = vim.diagnostic.get(bufnr)
    local items = {}

    for _, d in ipairs(diagnostics) do
        items[#items + 1] = {
            bufnr = bufnr,
            lnum = d.lnum + 1,
            col = d.col + 1,
            end_lnum = d.end_lnum and (d.end_lnum + 1) or nil,
            end_col = d.end_col and (d.end_col + 1) or nil,
            text = d.message,
            type = ({
                [vim.diagnostic.severity.ERROR] = icons.diagn.error,
                [vim.diagnostic.severity.WARN] = icons.diagn.warning,
                [vim.diagnostic.severity.INFO] = icons.diagn.information,
                [vim.diagnostic.severity.HINT] = icons.diagn.hint,
            })[d.severity],
        }
    end

    table.sort(items, function(a, b)
        if a.lnum ~= b.lnum then
            return a.lnum < b.lnum
        end
        if a.col ~= b.col then
            return a.col < b.col
        end
        return (a.text or "") < (b.text or "")
    end)

    return items
end

function M.quickfix_text(info)
    local qf_items = vim.fn.getqflist({ id = info.id, items = 1 }).items
    local lines = {}

    for i = info.start_idx, info.end_idx do
        local item = qf_items[i]
        if item then
            local name = item.bufnr > 0 and vim.api.nvim_buf_get_name(item.bufnr) or ""
            local path = normalize_path(name)
            local lnum = item.lnum or 0
            local col = item.col or 0
            local typ = item.type or ""
            local text = item.text or ""

            lines[#lines + 1] = string.format("%s:%d:%d: [%s] %s", path, lnum, col, typ, text)
        end
    end

    return lines
end

function M.setqflist(opts)
    opts = get_opts(opts)

    local items = collect_buffer_diagnostics()

    if vim.tbl_isempty(items) then
        if opts.notify then
            vim.notify("No diagnostics found in current buffer", vim.log.levels.INFO)
        end
        return false
    end

    vim.fn.setqflist({}, " ", {
        title = opts.title,
        items = items,
        quickfixtextfunc = "v:lua.require'core.plugins.diag'.quickfix_text",
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
        local group = vim.api.nvim_create_augroup("BufferDiagnosticsQuickfix", { clear = true })

        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = "qf",
            callback = function(args)
                local qf_info = vim.fn.getqflist({ title = 1 })
                if qf_info.title ~= M.config.title then
                    return
                end

                vim.bo[args.buf].buflisted = false

                vim.keymap.set("n", "q", "<cmd>cclose<cr>", {
                    buffer = args.buf,
                    silent = true,
                    desc = "Close diagnostics list",
                })

                vim.keymap.set("n", "<CR>", function()
                    local idx = vim.fn.line(".")
                    vim.cmd(("cc %d"):format(idx))
                    vim.cmd("cclose")
                end, {
                    buffer = args.buf,
                    silent = true,
                    desc = "Open diagnostic and close list",
                })
            end,
        })
    end
end

return M
