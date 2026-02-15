# opencode.nvim

NOTE: This plugin is still WIP and not yet tested

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
      auto_apply = true,
    })
  end
}
