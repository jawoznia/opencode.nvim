local telescope = require("opencode.telescope")
local context = require("opencode.context")
local helpers = require("tests.helpers")

describe("telescope integration", function()
    before_each(function()
        helpers.reset_context()
        context.new_context()
    end)

    it("invokes selection callback", function()
        local called = false

        telescope.pick_context(function(id)
            called = true
            assert.is_string(id)
        end)

        assert.is_true(called)
    end)
end)
