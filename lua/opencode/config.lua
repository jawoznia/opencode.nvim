local M = {}

---@class OpenCodeConfig
---@field auto_apply boolean
---@field notify boolean
---@field server_url string|nil

---@type OpenCodeConfig
M.options = {
    auto_apply = true,
    notify = true,
    server_url = nil,
}

function M.setup(opts)
    M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M
