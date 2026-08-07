Date: Fri, 20 Aug 2022 15:00:00 +0000
Issue Description:
  - User opens file-A using nvim-tree, user opens a second file using nvim-tree,
  user search a file using command <leader>ff and opens file-A,
  Expected: it should set focus to existing buffer that opened file-A.

Steps to fix:
  1. Anaylze the issue description and check the existing code.
  2. Try and reproduce the issue, if not reproducible review with user.
  3. If reproducible, fix the issue.
  4. Once confirm fixed update the same file how it was fixed.
  5. Create a PR and merge it.

Root cause:
  - `<leader>ff` (`lua/plugins/telescope.lua`) runs `Telescope find_files`
    with no custom mapping for `<CR>`, so selecting an entry falls through
    to telescope's default `select_default` action, which just runs `:edit
    <path>` in whichever window is currently focused. It never checks
    whether the file is already open in another tab, unlike nvim-tree's
    `<CR>`/`<C-t>` (see tabfix-01), which dedups against open tabs before
    loading a file.
  - Reproduced headlessly by driving the real plugin config: opening
    `fileA.txt` and `fileB.txt` via `tabnew` (mirroring how nvim-tree opens
    files) into tabs 2 and 3, moving focus back to tab 1, then invoking
    telescope's `find_files` picker and selecting `fileA.txt` again. Tab
    count stayed at 3 (no duplicate tab), but focus stayed on tab 1 with
    `fileA.txt` loaded into its window there instead of switching to tab 2
    — confirming the reported behavior.

Fix:
  - Added an `attach_mappings` callback to the `find_files` picker config in
    `lua/plugins/telescope.lua` that binds `<CR>` (insert and normal mode)
    to a local `open_or_switch_tab` function. It looks up the selected
    entry's path, scans every window in every tab for a buffer already
    showing that file, and if found, switches focus to that tab/window
    instead of opening it again. If the file isn't already open anywhere,
    it falls back to `tabnew` (consistent with how nvim-tree opens files),
    with `vim.fn.fnameescape()` applied for filenames with spaces/special
    characters.
  - The mapping is added via telescope's `map()` helper (scoped to that
    picker instance) rather than globally replacing `actions.select_default`,
    so other pickers (`buffers`, `live_grep`, `lsp_document_symbols`, etc.)
    that rely on default jump-to-line behavior are unaffected.
  - Verified via headless nvim, loading the real `lua/plugins/telescope.lua`
    config: with `fileA.txt` already open in tab 2 and focus on tab 1,
    running `find_files` and selecting `fileA.txt` switches focus to tab 2
    (tab count unchanged at 3) instead of loading a second copy into tab 1.
    Also confirmed the full config (`nvim --headless -c "qa"`) still loads
    without error.
