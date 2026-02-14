local M = {}

M.setup = function() end

function M.hello()
    print("Hello from my plugin!")
end

--- Adds two integers and returns their sum
--- @param a integer
--- @param b integer
--- @return integer
local add = function(a, b)
    print("a = ", a)
    print("b = ", b)
    return a + b
end

vim.print(add(5, 8))

M._add = add

return M
