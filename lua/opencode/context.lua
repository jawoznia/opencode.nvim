-- lua/opencode/context.lua

---@class OpenCodeContextItem
---@field type '"file"'|'"range"'        -- Type of captured item
---@field path string                    -- Absolute file path
---@field start_line? integer            -- Present only for range
---@field end_line? integer              -- Present only for range
---@field content string                 -- Snapshot of content at capture time

---@class OpenCodeContext
---@field id string
---@field items OpenCodeContextItem[]
---@field prompts string[]

---@class OpenCodeContextStore
---@field contexts table<string, OpenCodeContext>
---@field current_id string|nil

local M = {}

---@type OpenCodeContextStore
M.store = {
    contexts = {},
    current_id = nil,
}

---------------------------------------------------------------------
-- Context Lifecycle
---------------------------------------------------------------------

---Create a new empty context and make it current.
---@return string ctx_id
function M.new_context()
    local id = "ctx-" .. tostring(os.time()) .. "-" .. math.random(1000)

    ---@type OpenCodeContext
    local ctx = {
        id = id,
        items = {},
        prompts = {},
    }

    M.store.contexts[id] = ctx
    M.store.current_id = id

    return id
end

---Set active context manually.
---@param ctx_id string
function M.set_current(ctx_id)
    if M.store.contexts[ctx_id] then
        M.store.current_id = ctx_id
    end
end

---Get active context.
---@return OpenCodeContext|nil
function M.get_current()
    if not M.store.current_id then
        return nil
    end
    return M.store.contexts[M.store.current_id]
end

---------------------------------------------------------------------
-- Mutators
---------------------------------------------------------------------

---Add item to context.
---@param ctx_id string
---@param item OpenCodeContextItem
function M.add_item(ctx_id, item)
    local ctx = M.store.contexts[ctx_id]
    if not ctx then
        return
    end
    table.insert(ctx.items, item)
end

---Attach a prompt to context.
---@param ctx_id string
---@param prompt string
function M.add_prompt(ctx_id, prompt)
    local ctx = M.store.contexts[ctx_id]
    if not ctx then
        return
    end
    table.insert(ctx.prompts, prompt)
end

---------------------------------------------------------------------
-- Query
---------------------------------------------------------------------

---Return all contexts.
---@return table<string, OpenCodeContext>
function M.get_all()
    return M.store.contexts
end

return M
