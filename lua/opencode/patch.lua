local M = {}

---------------------------------------------------------------------
-- Apply unified diff safely using git
---------------------------------------------------------------------

---Apply patch output from OpenCode.
---@param output string[]
function M.apply(output)
    local text = table.concat(output, "\n")

    if text == "" then
        vim.notify("OpenCode returned empty response", vim.log.levels.WARN)
        return
    end

    local tmp = vim.fn.tempname()
    vim.fn.writefile(vim.split(text, "\n"), tmp)

    -- Apply via git
    vim.cmd("silent !git apply " .. tmp)
    vim.cmd("checktime")

    vim.notify("OpenCode patch applied", vim.log.levels.INFO)
end

return M
