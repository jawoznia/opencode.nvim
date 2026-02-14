local patch = require("opencode.patch")
local helpers = require("tests.helpers")

describe("patch application", function()
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
end)
