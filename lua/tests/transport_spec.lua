local transport = require("opencode.transport")
local context = require("opencode.context")
local helpers = require("tests.helpers")

describe("transport", function()
    before_each(function()
        helpers.reset_context()
    end)

    it("builds prompt from context", function()
        local id = context.new_context()

        context.add_item(id, {
            type = "file",
            path = "foo.lua",
            content = "print('x')",
        })

        context.add_prompt(id, "Refactor")

        local prompt = transport.build_prompt(id, "Final")
        assert.matches("foo.lua", prompt)
        assert.matches("Refactor", prompt)
        assert.matches("Final", prompt)
    end)
end)
