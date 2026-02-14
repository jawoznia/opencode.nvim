local M = {}

---@class OpenCodeConfig
---@field auto_apply boolean
---@field notify boolean

---@type OpenCodeConfig
M.options = {
    auto_apply = true,
    notify = true,
}

function M.setup(opts)
    M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M
