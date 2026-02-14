local context = require("opencode.context")
local M = {}

---------------------------------------------------------------------
-- Prompt Builder
---------------------------------------------------------------------

---Build complete prompt payload.
---@param ctx_id string
---@param extra_prompt string|nil
---@return string
function M.build_prompt(ctx_id, extra_prompt)
    local ctx = context.get_all()[ctx_id]
    if not ctx then
        return ""
    end

    local parts = {}

    for _, item in ipairs(ctx.items) do
        table.insert(parts, string.format("File: %s\n```\n%s\n```", item.path, item.content))
    end

    for _, p in ipairs(ctx.prompts) do
        table.insert(parts, "Instruction: " .. p)
    end

    if extra_prompt and extra_prompt ~= "" then
        table.insert(parts, "Final instruction: " .. extra_prompt)
    end

    return table.concat(parts, "\n\n")
end

---------------------------------------------------------------------
-- Send to OpenCode CLI
---------------------------------------------------------------------

---Send context to OpenCode.
---@param ctx_id string
---@param extra_prompt string|nil
function M.send(ctx_id, extra_prompt)
    local prompt = M.build_prompt(ctx_id, extra_prompt)

    local cmd = {
        "opencode",
        "--json",
        prompt,
    }

    vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        on_stdout = function(_, data)
            require("opencode.patch").apply(data)
        end,
    })
end

return M
