# Close Buffer and NvimTree

## Keybinding

`<leader>x` — Close the current buffer and NvimTree together.

## Behavior

1. If the cursor is in the NvimTree window, focus moves to the adjacent file window first.
2. NvimTree is closed if it is currently visible.
3. The current file buffer is deleted (`:bdelete`).

This prevents NvimTree from lingering alone after its companion buffer is closed, and works regardless of which window (tree or file) is focused when invoked.

## Location

`lua/core/keymaps.lua` — in the File Explorer section.
