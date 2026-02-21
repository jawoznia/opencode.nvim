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

    it("adds visual selection to context and sends to OpenCode", function()
        helpers.mock_jobstart({
            "diff --git a/a b/a",
            "+change",
        })

        helpers.with_temp_buffer({ "line1", "line2", "line3", "line4" }, function(bufnr)
            helpers.mock_visual_selection(2, 3)
            vim.api.nvim_buf_set_option(bufnr, "filetype", "lua")

            local id = context.new_context()
            actions.add_visual_to_current()
            transport.send(id, "Refactor")
        end)

        local ctx = context.get_current()
        assert.equals(1, #ctx.items)
        assert.equals("range", ctx.items[1].type)
        assert.equals(2, ctx.items[1].start_line)
        assert.equals(3, ctx.items[1].end_line)
    end)

    it("adds buffer (full file) to context and sends to OpenCode", function()
        helpers.mock_jobstart({
            "diff --git a/a b/a",
            "+updated content",
        })

        helpers.with_temp_buffer({ "original", "content" }, function()
            local id = context.new_context()
            actions.add_file_to_current()
            transport.send(id, "Update")
        end)

        local ctx = context.get_current()
        assert.equals(1, #ctx.items)
        assert.equals("file", ctx.items[1].type)
    end)

    it("adds both selection and buffer to context and sends to OpenCode", function()
        helpers.mock_jobstart({
            "diff --git a/a b/a",
            "+combined changes",
        })

        helpers.with_temp_buffer({ "a", "b", "c", "d" }, function(bufnr)
            helpers.mock_visual_selection(1, 2)
            local id = context.new_context()
            actions.add_visual_to_current()
            actions.add_file_to_current()
            transport.send(id, "Do work")
        end)

        local ctx = context.get_current()
        assert.equals(2, #ctx.items)
        assert.equals("range", ctx.items[1].type)
        assert.equals("file", ctx.items[2].type)
    end)
end)
