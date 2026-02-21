-- .luacheckrc
-- https://luacheck.readthedocs.io/en/stable/config.html

std = "lua51"

globals = {
    "vim",
    "describe",
    "it",
    "before_each",
    "after_each",
    "pending",
    "mock",
    "stub",
}

unused_args = false
