local patch = require("opencode.patch")
local helpers = require("tests.helpers")

describe("patch application", function()
    local mock_notify_calls
    local written_content
    local cmd_called

    before_each(function()
        mock_notify_calls = helpers.mock_notify()
        vim.fn.writefile = function()
        end
        vim.cmd = function()
        end
    end)

    it("writes and applies patch", function()
        local applied = false

        vim.cmd = function(cmd)
            if cmd:match("git apply") then
                applied = true
            end
        end

        patch.apply({
            "diff --git a/a b/a",
            "+hello",
        })

        assert.is_true(applied)
    end)

    it("shows warning for empty response", function()
        patch.apply({ "" })

        assert.equals(1, #mock_notify_calls)
        assert.equals(vim.log.levels.WARN, mock_notify_calls[1].level)
        assert.is_string(mock_notify_calls[1].msg:match("empty"))
    end)

    it("shows warning for nil input", function()
        local ok, err = pcall(function()
            patch.apply(nil)
        end)
        assert.is_false(ok)
    end)

    it("writes patch content to temp file", function()
        written_content = nil

        vim.fn.writefile = function(lines, path)
            written_content = lines
        end
        vim.cmd = function(cmd)
        end

        patch.apply({
            "diff --git a/test.lua b/test.lua",
            "--- a/test.lua",
            "+++ b/test.lua",
            "@@ -1,1 +1,2 @@",
            " old",
            "+new",
        })

        assert.is_not_nil(written_content)
        local text = table.concat(written_content, "\n")
        assert.is_true(text:find("diff", 1, true) ~= nil)
        assert.is_true(text:find("+new", 1, true) ~= nil)
    end)

    it("calls git apply with temp file path", function()
        local git_apply_called = false

        vim.cmd = function(cmd)
            if cmd:find("git apply", 1, true) then
                git_apply_called = true
            end
        end

        patch.apply({ "diff content" })

        assert.is_true(git_apply_called)
    end)

    it("shows info notification on successful apply", function()
        vim.cmd = function()
        end

        patch.apply({ "some patch" })

        assert.is_true(#mock_notify_calls >= 1)
        local info_call = mock_notify_calls[#mock_notify_calls]
        assert.equals(vim.log.levels.INFO, info_call.level)
        assert.is_true(info_call.msg:match("applied") ~= nil)
    end)

    it("runs checktime after applying patch", function()
        local checktime_called = false

        vim.cmd = function(cmd)
            if cmd == "checktime" then
                checktime_called = true
            end
        end

        patch.apply({ "patch content" })

        assert.is_true(checktime_called)
    end)
end)
