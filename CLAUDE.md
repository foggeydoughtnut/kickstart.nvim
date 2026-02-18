# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A personal Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) — a single-file starting point, not a distribution. The primary config lives entirely in `init.lua`.

## Formatting

All Lua code must be formatted with `stylua`. The CI workflow enforces this on PRs.

```bash
stylua .           # format all Lua files
stylua --check .   # check formatting without modifying files
```

Key style rules (from `.stylua.toml`): 2-space indent, single quotes preferred, no call parentheses where optional, 160-char column width, `collapse_simple_statement = "Always"`.

## Architecture

### Plugin Manager

[lazy.nvim](https://github.com/folke/lazy.nvim) manages all plugins. It is bootstrapped at the top of `init.lua` and all plugins are declared in the `require('lazy').setup({...})` call.

### File Structure

- `init.lua` — the entire configuration: options, keymaps, autocommands, and all plugin specs inline
- `lua/kickstart/plugins/` — optional plugin modules that can be uncommented in `init.lua` (debug, indent_line, lint, autopairs, neo-tree, gitsigns)
- `lua/custom/plugins/` — place for personal plugins not tracked upstream; loaded via `{ import = 'custom.plugins' }` (currently commented out in `init.lua`)
- `lua/kickstart/health.lua` — `:checkhealth kickstart` implementation

### Adding Plugins

Two patterns:
1. **Inline** in `init.lua` inside the `lazy.setup({})` table
2. **Modular** in `lua/custom/plugins/*.lua` — uncomment `{ import = 'custom.plugins' }` near the bottom of `init.lua` to enable

The optional kickstart plugin modules (e.g. `lua/kickstart/plugins/neo-tree.lua`) are enabled by uncommenting their `require` lines in `init.lua`:
```lua
-- require 'kickstart.plugins.neo-tree',
```

### Key Plugins Installed

- **lazy.nvim** — plugin manager
- **nvim-tree** — file explorer (loaded on `VimEnter`; netrw is disabled via `vim.g.loaded_netrw = 1`)
- **telescope.nvim** — fuzzy finder (`<leader>s*` keymaps)
- **blink.cmp** — autocompletion
- **nvim-lspconfig** + **mason.nvim** — LSP; lua_ls is always enabled; other servers added to the `servers` table
- **conform.nvim** — autoformat on save (stylua for Lua; format with `<leader>f`)
- **tokyonight.nvim** — colorscheme
- **which-key.nvim** — keymap hints
- **mini.nvim** — ai textobjects, surround, statusline

### nvim-tree Notes

`vim.g.loaded_netrw` and `vim.g.loaded_netrwPlugin` must be set to `1` **before** lazy.nvim loads (they are set at the very top of `init.lua`). nvim-tree does not auto-open by default — use `:NvimTreeOpen` or add an autocmd to open it on `VimEnter` if desired.

### Leader Key

`<Space>` is both `mapleader` and `maplocalleader`. This must be set before lazy.nvim loads.

## Health Check

Run `:checkhealth kickstart` inside Neovim to verify external dependencies (`git`, `make`, `unzip`, `rg`) and Neovim version (requires ≥ 0.11).
