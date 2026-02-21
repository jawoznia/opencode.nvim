# AGENTS.md

## Project Overview

`opencode.nvim` is an AI context staging plugin for Neovim. It allows users to create named contexts, add files or visual selections to them, attach prompts, inspect contexts via Telescope, send them to the OpenCode CLI, and automatically apply unified diff patches.

## Requirements

- Neovim >= 0.9
- Telescope.nvim
- opencode CLI installed and in PATH
- git (for patch apply)

## Project Structure

```
lua/opencode/
├── init.lua       # Main entry point, exports setup()
├── config.lua     # Configuration handling (auto_apply, notify)
├── commands.lua   # Registers :OpenCode* user commands
├── context.lua    # Context storage and management (in-memory store)
├── actions.lua    # Capture visual selections and files into contexts
├── telescope.lua  # Telescope picker for selecting contexts
├── transport.lua  # Builds prompts and sends to OpenCode CLI
└── patch.lua      # Applies unified diff patches via git

plugin/
└── opencode.lua   # Plugin entry point

lua/tests/
├── minimal_init.lua
├── helpers.lua
├── bootstrap.lua
├── context_spec.lua
├── actions_spec.lua
├── transport_spec.lua
├── telescope_spec.lua
└── patch_spec.lua
```

## Configuration

```lua
require("opencode").setup({
    auto_apply = true,  -- auto-apply patches (default: true)
    notify = true,      -- show notifications (default: true)
    server_url = nil,   -- running server URL (e.g., "http://localhost:4096")
})
```

To use a running OpenCode server, start it first:
```bash
opencode serve --port 4096
```

Then configure the plugin:
```lua
require("opencode").setup({
    server_url = "http://localhost:4096",
})
```

## Commands

| Command | Description |
|---------|-------------|
| `:OpenCodeNew` | Create a new empty context and set it as current |
| `:OpenCodeAddFile` | Add entire current buffer to active context |
| `:OpenCodeAddVisual` | Add visual selection to active context |
| `:OpenCodePrompt <text>` | Attach a prompt/instruction to active context |
| `:OpenCodeSend` | Open Telescope picker to select context and send to OpenCode CLI |

## Key APIs

### `context.new_context()` -> `string`
Creates a new context with a unique ID and sets it as current.

### `context.get_current()` -> `OpenCodeContext|nil`
Returns the currently active context.

### `context.add_item(ctx_id, item)`
Adds a file or range item to a context.

### `context.add_prompt(ctx_id, prompt)`
Attaches a prompt string to a context.

### `transport.send(ctx_id, extra_prompt)`
Sends context to OpenCode CLI and applies returned patch.

### `patch.apply(output)`
Applies unified diff output via `git apply`.

## Testing

Run tests with:
```bash
just test
```

Uses plenary.nvim's busted test runner in headless Neovim.

## Linting/Type Checking

Run luacheck to lint Lua files:
```bash
luacheck lua/
```

The project uses Lua with lua-language-server for IDE support (see `.luarc.json`).
