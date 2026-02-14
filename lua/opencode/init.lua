local M = {}

local config = require("opencode.config")
local commands = require("opencode.commands")

---Setup function called by user
---@param opts table|nil
function M.setup(opts)
    config.setup(opts or {})
    commands.register()
end

return M
