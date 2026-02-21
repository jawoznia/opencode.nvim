local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local context = require("opencode.context")

local M = {}

---------------------------------------------------------------------
-- Pick Context
---------------------------------------------------------------------

---Open Telescope picker listing all contexts.
---@param on_select fun(ctx_id:string)
function M.pick_context(on_select)
    local results = {}

    for id, ctx in pairs(context.get_all()) do
        table.insert(results, id .. " (" .. #ctx.items .. " items)")
    end

    if #results == 0 then
        vim.notify("No OpenCode contexts found", vim.log.levels.WARN)
        return
    end

    local entry_maker = function(line)
        return {
            display = line,
            value = vim.split(line, " ")[1],
            ordinal = line,
        }
    end

    pickers
        .new({}, {
            prompt_title = "OpenCode Contexts",
            finder = finders.new_table({
                results = results,
                entry_maker = entry_maker,
            }),
            sorter = sorters.get_generic_fuzzy_sorter(),
            attach_mappings = function(_, map)
                map("i", "<CR>", function(bufnr)
                    local selection = action_state.get_selected_entry()
                    actions.close(bufnr)
                    on_select(selection.value)
                end)
                return true
            end,
        })
        :find()
end

return M
