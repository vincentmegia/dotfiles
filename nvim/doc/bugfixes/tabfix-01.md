Date: Fri, 20 Aug 2022 15:00:00 +0000
Issue Description:
  - I see a behavior where sometimes multiple tabs are opened with the same filename.

Steps to fix:
  1. Anaylze the issue description and check the existing code.
  2. Try and reproduce the issue, if not reproducible review with user.
  3. If reproducible, fix the issue.
  4. Once confirm fixed update the same file how it was fixed.
  5. Create a PR and merge it.

Root cause:
  - `lua/plugins/nvim-tree.lua`'s `<CR>` mapping already deduped tabs (commit
    65c372d, "fixed issue of duplicate tabs"): before opening a file it scans
    every window in every tab and jumps to one already showing the file
    instead of opening a new tab.
  - `on_attach` also calls `api.config.mappings.default_on_attach(bufnr)`,
    which sets nvim-tree's own default keymaps, including `<C-t>` bound to
    `api.node.open.tab` (an unconditional `tabnew`, no dedup check). That
    mapping was never overridden, so pressing `<C-t>` on a file already open
    in another tab opened a genuine duplicate.
  - Reproduced headlessly by driving the real plugin config: opening the same
    node's file via `<C-t>` twice produced the file in 2 separate tabs.

Fix:
  - Renamed the `<CR>` handler's inline function to a named local
    (`open_or_switch_tab`) and bound `<C-t>` to the same function, so both
    keys share one dedup-aware code path instead of `<C-t>` falling through
    to nvim-tree's unconditional-new-tab default.
  - Considered switching to nvim-tree's built-in `api.node.open.tab_drop`
    (a `:tab :drop`-based equivalent) instead of the hand-rolled loop, but
    reverted: it reuses the current window when that window's buffer is
    empty/unnamed. Since `VimEnter` opens the tree as a split (leaving
    Neovim's initial empty scratch window behind in tab 1), the *first* file
    opened each session would silently load into that leftover window
    instead of getting its own tab — verified with a headless repro
    (tab count stayed at 1 after the first open). The hand-rolled loop
    doesn't have this failure mode since it always does an explicit
    `tabnew` when the file isn't found open anywhere.
  - Also restored `vim.fn.fnameescape()` around the `tabnew` path, dropped
    in the original dedup commit, so filenames with spaces/special
    characters are handled correctly.
  - Verified via headless nvim, loading `lua/plugins/nvim-tree.lua` for
    real: first open of a file creates a new tab; `<CR>` or `<C-t>` on an
    already-open file switches to its existing tab instead of duplicating;
    opening a different file still gets its own new tab.
