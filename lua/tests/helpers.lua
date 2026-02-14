local M = {}

function M.with_temp_buffer(lines, fn)
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.api.nvim_set_current_buf(bufnr)
    fn(bufnr)
    vim.api.nvim_buf_delete(bufnr, { force = true })
end

function M.mock_notify()
    local calls = {}
    vim.notify = function(msg, level)
        table.insert(calls, { msg = msg, level = level })
    end
    return calls
end

function M.mock_jobstart(output)
    vim.fn.jobstart = function(_, opts)
        opts.on_stdout(nil, output)
        return 1
    end
end

function M.reset_context()
    local ctx = require("opencode.context")
    ctx.store.contexts = {}
    ctx.store.current_id = nil
end

return M
