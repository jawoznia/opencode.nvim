# opencode.nvim

Still WIP. Lacking integration and e2e testing.

AI context staging plugin for Neovim.

## Features

- Add file or visual selection to named contexts
- Attach prompts to contexts
- Inspect contexts via Telescope
- Send contexts to OpenCode CLI
- Apply unified diff patches automatically

## Requirements

- Neovim >= 0.9
- Telescope.nvim
- opencode CLI installed and in PATH
- git (for patch apply)

## Installation (lazy.nvim)

```lua
{
  "jawoznia/opencode.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("opencode").setup({
      auto_apply = true,  -- auto-apply patches (default: true)
      notify = true,      -- show notifications (default: true)
    })
  end
}
```

## Keybindings

Recommended keybindings:

```lua
vim.keymap.set("n", "<leader>oc", ":OpenCodeNew<CR>", { desc = "OpenCode: New context" })
vim.keymap.set("n", "<leader>oa", ":OpenCodeAddFile<CR>", { desc = "OpenCode: Add file" })
vim.keymap.set("v", "<leader>oa", ":OpenCodeAddVisual<CR>", { desc = "OpenCode: Add visual" })
vim.keymap.set("n", "<leader>os", ":OpenCodeSend<CR>", { desc = "OpenCode: Send to CLI" })
```

- `<leader>oc` - Create a new context
- `<leader>oa` - Add current file (normal mode) or visual selection (visual mode)
- `<leader>os` - Open Telescope picker to select and send context to OpenCode CLI

## Usage

1. Create a new context: `<leader>oc`
2. Add files or visual selections: `<leader>oa`
3. Add a prompt: `:OpenCodePrompt Fix the bug in the foo function`
4. Send to OpenCode CLI: `<leader>os`

## Server Mode

To use a running OpenCode server instead of spawning a new process each time:

```bash
opencode serve --port 4096
```

Then configure the plugin:

```lua
require("opencode").setup({
    server_url = "http://localhost:4096",
})
```
