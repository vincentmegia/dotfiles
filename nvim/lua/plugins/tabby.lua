local M = {}

function M.setup()
  M.spec = {
    "nanozuki/tabby.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local ok, tabline = pcall(require, "tabby.tabline")
      if not ok then return end
      local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
      vim.o.showtabline = 2

      -- === Highlights ===
      vim.api.nvim_set_hl(0, "TabbyLeft",       { fg = "#c0caf5", bg = "#1e1e2e" })
      vim.api.nvim_set_hl(0, "TabbyRight",      { fg = "#c0caf5", bg = "#1e1e2e" })
      vim.api.nvim_set_hl(0, "TabbyTabActive",  { fg = "#ffffff", bg = "#7aa2f7", bold = true })
      vim.api.nvim_set_hl(0, "TabbyTabInactive",{ fg = "#a9b1d6", bg = "#1e1e2e" })
      vim.api.nvim_set_hl(0, "TabbyTabModified",{ fg = "#ff9e64", bg = "#7aa2f7" })
      vim.api.nvim_set_hl(0, "TabbyTabHover",   { fg = "#ffffff", bg = "#5a7adf", bold = true })

      -- Helper: get file icon
      local function file_icon(bufnr)
        if not devicons_ok then return " " end
        local name = vim.fn.bufname(bufnr)
        local ext = vim.fn.fnamemodify(name, ":e")
        local icon = devicons.get_icon(name, ext, { default = true })
        return icon .. " "
      end

      -- Helper: git status
      local function git_status(bufnr)
        local signs = vim.b[bufnr].gitsigns_status_dict
        if not signs then return "" end
        if signs.added and signs.added > 0 then return " +"
        elseif signs.changed and signs.changed > 0 then return " ~"
        elseif signs.removed and signs.removed > 0 then return " -"
        else return "" end
      end

      -- Helper: diagnostic counts
      local function diagnostics(bufnr)
        local errs = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
        local warns = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN })
        local s = ""
        if errs > 0 then s = s .. " E:" .. errs end
        if warns > 0 then s = s .. " W:" .. warns end
        return s
      end

      -- === Tabline setup ===
      tabline.set(function()
        local tabs = {}

        -- Left
        table.insert(tabs, { "  Buffers ", "TabbyLeft" })

        -- Buffers
        for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
          local hl
          if vim.api.nvim_get_current_buf() == buf.bufnr then
            hl = "TabbyTabActive"
          elseif vim.bo[buf.bufnr].modified then
            hl = "TabbyTabModified"
          else
            hl = "TabbyTabInactive"
          end

          local name = vim.fn.fnamemodify(vim.fn.bufname(buf.bufnr), ":t")
          local display_name = "" .. file_icon(buf.bufnr)
                            .. (name ~= "" and name or "[No Name]") 
                            .. git_status(buf.bufnr)
                            .. diagnostics(buf.bufnr)
                            .. (vim.bo[buf.bufnr].modified and " ●" or "")
                            .. ""
                            .. " x" -- close button
          table.insert(tabs, { display_name, hl })
        end

        -- Right: buffer count
        table.insert(tabs, { "  " .. #vim.fn.getbufinfo({ buflisted = 1 }) .. " ", "TabbyRight" })

        return tabs
      end)

      --
    end,
  }

  return M
end

return M

