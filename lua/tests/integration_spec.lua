local context = require("opencode.context")
local actions = require("opencode.actions")
local transport = require("opencode.transport")
local helpers = require("tests.helpers")

describe("full workflow", function()
    before_each(function()
        helpers.reset_context()
    end)

    it("creates context, adds file, sends to OpenCode", function()
        helpers.mock_jobstart({
            "diff --git a/a b/a",
            "+change",
        })

        helpers.with_temp_buffer({ "x" }, function()
            local id = context.new_context()
            actions.add_file_to_current()
            transport.send(id, "Improve")
        end)

        local ctx = context.get_current()
        assert.equals(1, #ctx.items)
    end)
end)
