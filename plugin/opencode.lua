if vim.g.loaded_opencode then
    return
end
vim.g.loaded_opencode = true

require("opencode").setup()
