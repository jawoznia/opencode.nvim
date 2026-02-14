local context = require("opencode.context")
local actions = require("opencode.actions")
local telescope = require("opencode.telescope")
local transport = require("opencode.transport")

local M = {}

function M.register()
    vim.api.nvim_create_user_command("OpenCodeNew", function()
        local id = context.new_context()
        vim.notify("Created context: " .. id)
    end, {})

    vim.api.nvim_create_user_command("OpenCodeAddFile", function()
        actions.add_file_to_current()
    end, {})

    vim.api.nvim_create_user_command("OpenCodeAddVisual", function()
        actions.add_visual_to_current()
    end, { range = true })

    vim.api.nvim_create_user_command("OpenCodePrompt", function(opts)
        local ctx = context.get_current()
        if not ctx then
            return
        end
        context.add_prompt(ctx.id, table.concat(opts.fargs, " "))
    end, { nargs = "+" })

    vim.api.nvim_create_user_command("OpenCodeSend", function()
        telescope.pick_context(function(ctx_id)
            vim.ui.input({ prompt = "Final prompt (optional): " }, function(input)
                transport.send(ctx_id, input)
            end)
        end)
    end, {})
end

return M
