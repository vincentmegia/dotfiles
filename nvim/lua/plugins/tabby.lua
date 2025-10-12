local M = {}

function M.setup()
  M.spec = {
    "nanozuki/tabby.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local ok, tabby = pcall(require, "tabby")
      if not ok then return end

      local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
      vim.o.showtabline = 2

      -- === Highlight groups for VSCode style ===
      vim.api.nvim_set_hl(0, "TabLineSel",    { fg="#ffffff", bg="#7aa2f7", bold=true })   -- active tab
      vim.api.nvim_set_hl(0, "TabLine",       { fg="#a9b1d6", bg="#1e1e2e" })               -- inactive tabs
      vim.api.nvim_set_hl(0, "TabLineFill",   { fg="#c0caf5", bg="#1e1e2e" })               -- background

      -- Setup Tabby with the preset
      tabby.setup({
        preset = 'active_wins_at_tail',
        option = {
          nerdfont      = true,        -- enable Nerd Font icons
          theme         = {
            fill        = 'TabLineFill',
            head        = 'TabLine',
            current_tab = 'TabLineSel',
            tab         = 'TabLine',
            win         = 'TabLine',
            tail        = 'TabLine',
          },
          tab_name = {
            name_fallback = function(tabid)
              return tabid
            end,
          },
          buf_name = {
            mode = 'unique',  -- show unique buffer names
            suffix = function(bufid)
              -- show modified indicator
              return vim.bo[bufid].modified and " ●" or ""
            end,
          },
          win_name = {
            bufid_as_fallback = true,
          },
          left = {
            { "  ", "TabLine" },
          },
          right = {
            -- buffer count
            function()
              return "  " .. #vim.fn.getbufinfo({buflisted = 1})
            end,
          },
          -- Optional: add icons for buffers using Nerd Fonts
          tab_icon = function(bufid)
            if devicons_ok then
              local name = vim.fn.bufname(bufid)
              local ext = vim.fn.fnamemodify(name, ":e")
              return devicons.get_icon(name, ext, { default = "" }) .. " "
            end
            return ""
          end,
          -- Optionally, add diagnostics next to buffer name
          buf_diagnostics = function(bufid)
            local errs  = #vim.diagnostic.get(bufid, {severity = vim.diagnostic.severity.ERROR})
            local warns = #vim.diagnostic.get(bufid, {severity = vim.diagnostic.severity.WARN})
            local s = ""
            if errs > 0 then s = s .. " " .. errs end
            if warns > 0 then s = s .. " " .. warns end
            return s
          end,
        },
      })
    end,
  }

  return M
end

return M

