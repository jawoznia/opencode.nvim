local context = require("opencode.context")
local helpers = require("tests.helpers")

describe("context store", function()
    before_each(function()
        helpers.reset_context()
    end)

    it("creates a new context", function()
        local id = context.new_context()
        assert.is_not_nil(id)
        assert.is_table(context.get_all()[id])
    end)

    it("sets and retrieves current context", function()
        local id = context.new_context()
        local current = context.get_current()
        assert.equals(id, current.id)
    end)

    it("adds items and prompts", function()
        local id = context.new_context()

        context.add_item(id, {
            type = "file",
            path = "foo.lua",
            content = "print('hi')",
        })

        context.add_prompt(id, "Refactor this")

        local ctx = context.get_all()[id]
        assert.equals(1, #ctx.items)
        assert.equals(1, #ctx.prompts)
    end)
end)
