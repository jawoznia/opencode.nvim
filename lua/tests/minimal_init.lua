-- Add plugin itself
vim.cmd("set runtimepath+=.")
vim.cmd("set runtimepath+=./lua")

-- Add test dependencies
vim.cmd("set runtimepath+=./.deps/plenary.nvim")
vim.cmd("set runtimepath+=./.deps/telescope")

-- Required for plenary busted
require("plenary.busted")
