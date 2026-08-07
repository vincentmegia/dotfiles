# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal Neovim configuration (Lua), managed with `lazy.nvim` as the plugin manager. It is one directory within a larger `dotfiles` repo — this file applies to `nvim/` specifically. There is no build system, package.json, or test suite; validation happens by launching Neovim and exercising the config directly.

## Common commands

- Reload after editing: relaunch `nvim`, or `:source %` / restart for a single file.
- Sync/install plugins: `:Lazy sync` (also bound to `<leader>ls`).
- Check environment health: `:checkhealth`.
- Lazy-lock file (`lazy-lock.json`) pins plugin commit versions — commit it alongside plugin spec changes so installs stay reproducible.

## Architecture

### Bootstrap flow (`init.lua`)

1. Bootstraps `lazy.nvim` by cloning it if not already present at `stdpath("data")`.
2. Requires `core.init`, which loads `core.options`, `core.signs`, `core.keymaps` (order matters — options before keymaps).
3. Requires each `lua/plugins/*.lua` module individually and calls `.setup()` on it to populate `M.spec`.
4. Passes the collected `.spec` tables into a single `lazy.setup({...})` call.
5. Sets colorscheme and a few global `vim.g`/`vim.opt` values at the bottom.

**Important:** plugin modules are wired in one at a time, by name, in `init.lua` — there is no `{ import = "plugins" }` auto-loading of the whole `lua/plugins/` directory. Adding a new file under `lua/plugins/` does nothing until you `require()` it and add its `.spec` (and call `.setup()`) in `init.lua`.

### Plugin module convention

Every file in `lua/plugins/` follows the same shape:

```lua
local M = {}
function M.setup()
  M.spec = { "author/plugin", dependencies = {...}, config = function() ... end }
  return M
end
return M
```

`M.setup()` must be called (in `init.lua`) before `M.spec` is populated; the spec is then handed to `lazy.setup()`. When adding a new plugin, follow this pattern and remember to wire it into `init.lua` in both the `require`/`.setup()` section and the `lazy.setup({...})` table.

### Orphaned/unwired files

Not everything under `lua/plugins/` is actually loaded by `init.lua`. Currently unreferenced anywhere:
- `lua/plugins/color.lua` (TabLine highlight overrides)
- `lua/plugins/nvim-web-devicons.lua` (devicons is instead pulled in directly as a dependency string in `nvim-tree.lua`, `telescope.lua`, and `tabby.lua`)
- `lua/plugins/js_ts.lua` (a JS/TS LSP + cmp setup that duplicates/conflicts with the `ts_ls`/`eslint` setup already done in `mason-lsp.lua`; uses the deprecated `tsserver` server name)
- `lua/config/indent.lua` (JS/TS indent-width autocmd)

Before assuming a file affects runtime behavior, check whether it's actually `require`d from `init.lua` or from another loaded module.

### LSP setup lives in `mason-lsp.lua`

`lua/plugins/mason-lsp.lua` is the real source of truth for LSP servers, on_attach keymaps, and format-on-save — not `js_ts.lua`. It configures `gopls`, `lua_ls`, `pyright`, `rust_analyzer`, `jsonls`, `ts_ls`, and `eslint`, each with its own `on_attach`. JS/TS format-on-save deliberately formats via the `eslint` LSP client rather than `ts_ls`; Rust format-on-save shells out to `rustfmt` directly instead of going through `rust_analyzer`.

### Go run/build helpers (`lua/go/`)

`lua/go/run.lua` and `lua/go/build.lua` are hand-rolled (non-plugin) helpers that reuse a single scratch terminal buffer/window (module-local `term_buf`/`term_win`) to run `go run cmd/api/main.go` / `go build cmd/api/main.go`. They currently hardcode that path rather than using the current file or project root — check this if adapting the config for a different Go project layout. Bound to `<leader>gr` and `<leader>grb` in `core/keymaps.lua`.

### Keymaps (`lua/core/keymaps.lua`)

Central file for all keymaps; leader is `<space>`. LSP buffer-local keymaps are set twice: once generically in `mason-lsp.lua`'s `on_attach`/`on_attach_js_ts`, and again globally via an `LspAttach` autocmd here — be aware of this duplication when changing LSP keybindings. `<leader>sh` opens a scratch buffer and streams an arbitrary shell command's stdout into it live via `vim.system`.

### Diagnostics UI

Diagnostic sign/virtual-text config is split across `core/signs.lua` (sign definitions, diagnostic float config, gitsigns) and `plugins/tiny-inline-diagnostic.lua` (the inline diagnostic renderer, toggled with `<leader>dd`/`<leader>dc`/`<leader>dr`). Diagnostic icons in `signs.lua` fall back to nerd-font glyphs if `nvim-web-devicons` isn't available.

### Colorscheme

`colors/onedark.lua` is a full custom colorscheme (loaded via `:colorscheme onedark` in `init.lua`), not a plugin-provided one — edit it directly to change colors rather than looking for a theme plugin.

Features: are stored in doc/features and in sequence <feature-name-<number>.md>, the number portion
would be the order of the feature list that can help tracking the state of the features.

Bug-fix: are stored in doc/bugfix and in sequence <bugfix-name-<number>.md>, the number portion
would be the order of the feature list that can help tracking the state of the features.


## Important Working Rules

Before making changes:

1. Inspect the existing implementation first.
2. Follow the architecture and conventions already present in the codebase.
3. Prefer the smallest change that satisfies the task.
4. Do not introduce new dependencies unless necessary.
5. Do not perform unrelated refactoring.
6. Update tests when behavior changes.
7. Run the relevant validation commands after making changes.
8. Review the final diff for unintended changes.

Coding Guidelines:
 - Do not modify external plugins' code.

Rules:
 - For TABS
    - Do not create new tabs if existing tabs is already opened, filename would the identifier.
