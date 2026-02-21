local context = require("opencode.context")
local actions = require("opencode.actions")
local helpers = require("tests.helpers")

describe("e2e visual selection workflow", function()
    before_each(function()
        helpers.reset_context()
    end)

    it("adds real visual selection to context without mocks", function()
        helpers.with_temp_buffer({ "line1", "line2", "line3", "line4" }, function(bufnr)
            vim.api.nvim_buf_set_option(bufnr, "filetype", "lua")

            vim.api.nvim_buf_set_mark(bufnr, "<", 1, 0, {})
            vim.api.nvim_buf_set_mark(bufnr, ">", 4, 0, {})

            context.new_context()
            actions.add_visual_to_current()

            local ctx = context.get_current()
            assert.equals(1, #ctx.items)
            assert.equals("range", ctx.items[1].type)
            assert.equals(1, ctx.items[1].start_line)
            assert.equals(4, ctx.items[1].end_line)
            assert.equals("line1\nline2\nline3\nline4", ctx.items[1].content)
        end)
    end)

    it("adds specific line range to context without mocks", function()
        helpers.with_temp_buffer({ "aaa", "bbb", "ccc", "ddd" }, function(bufnr)
            vim.api.nvim_buf_set_option(bufnr, "filetype", "lua")

            vim.api.nvim_buf_set_mark(bufnr, "<", 1, 0, {})
            vim.api.nvim_buf_set_mark(bufnr, ">", 3, 0, {})

            context.new_context()
            actions.add_visual_to_current()

            local ctx = context.get_current()
            assert.equals(1, #ctx.items)
            assert.equals("range", ctx.items[1].type)
            assert.equals(1, ctx.items[1].start_line)
            assert.equals(3, ctx.items[1].end_line)
            assert.equals("aaa\nbbb\nccc", ctx.items[1].content)
        end)
    end)
end)
