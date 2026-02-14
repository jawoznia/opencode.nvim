local context = require("opencode.context")

local M = {}

---------------------------------------------------------------------
-- Capture Visual Selection
---------------------------------------------------------------------

---Capture current visual selection and attach to active context.
function M.add_visual_to_current()
    local ctx = context.get_current()
    if not ctx then
        vim.notify("No active OpenCode context", vim.log.levels.WARN)
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local path = vim.api.nvim_buf_get_name(bufnr)

    local start_line = vim.fn.getpos("'<")[2]
    local end_line = vim.fn.getpos("'>")[2]

    local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)

    ---@type OpenCodeContextItem
    local item = {
        type = "range",
        path = path,
        start_line = start_line,
        end_line = end_line,
        content = table.concat(lines, "\n"),
    }

    context.add_item(ctx.id, item)
end

---------------------------------------------------------------------
-- Capture Entire File
---------------------------------------------------------------------

---Capture entire current buffer into active context.
function M.add_file_to_current()
    local ctx = context.get_current()
    if not ctx then
        vim.notify("No active OpenCode context", vim.log.levels.WARN)
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local path = vim.api.nvim_buf_get_name(bufnr)

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    ---@type OpenCodeContextItem
    local item = {
        type = "file",
        path = path,
        content = table.concat(lines, "\n"),
    }

    context.add_item(ctx.id, item)
end

return M
