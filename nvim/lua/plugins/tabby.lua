local M = {}

function M.setup()
  M.spec = {
    "nanozuki/tabby.nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local ok, tabby = pcall(require, "tabby")
      if not ok then
        vim.notify("tabby.nvim not found", vim.log.levels.ERROR)
        return
      end

      local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
      if not devicons_ok then
        vim.notify("nvim-web-devicons not found", vim.log.levels.WARN)
      end

      local theme = {
        fill = "TabLineFill",
        head = "TabLine",
        current_tab = "TabLineSel",
        tab = "TabLine",
        win = "TabLine",
        tail = "TabLine",
      }

      -- Get filename from buffer number
      local function filename_from_bufnr(bufnr)
        if not bufnr or bufnr == 0 then return nil end
        local name = vim.api.nvim_buf_get_name(bufnr)
        if not name or name == "" then return nil end
        local fname = vim.fn.fnamemodify(name, ":t")
        if devicons_ok then
          local icon = devicons.get_icon(name, vim.fn.fnamemodify(name, ":e"), { default = true }) or ""
          local result = icon .. " " .. fname
          vim.notify("filename_from_bufnr: " .. result, vim.log.levels.INFO)
          return result
        end
        vim.notify("filename_from_bufnr (no icon): " .. fname, vim.log.levels.INFO)
        return fname
      end

      -- Get representative filename for a tab (first buffer)
      local function tab_filename(tabid)
        local wins = vim.api.nvim_tabpage_list_wins(tabid)
        for _, winid in ipairs(wins) do
          local buf = vim.api.nvim_win_get_buf(winid)
          local bufname = vim.api.nvim_buf_get_name(buf)
          if bufname ~= "" and not bufname:match("NvimTree") then
            local fname = filename_from_bufnr(buf)
            if fname then
              vim.notify("tab_filename: tabid=" .. tabid .. " fname=" .. fname, vim.log.levels.INFO)
              return fname
            end
          end
        end
        vim.notify("tab_filename: tabid=" .. tabid .. " => [No Name]", vim.log.levels.INFO)
        return "[No Name]"
      end
      -- Tabby line setup
      tabby.setup({
        line = function(line)
          return {
            { "  ", hl = theme.head },
            line.tabs().foreach(function(tab)
              local hl = tab.is_current() and theme.current_tab or theme.tab
              local tabid = tab.id or 0
              local fname = tab_filename(tabid)
              vim.notify("Rendering tab: number=" .. tab.number() .. " fname=" .. fname, vim.log.levels.INFO)
              return { string.format(" %d: %s ", tab.number(), fname), hl = hl, margin = " " }
            end),
            line.spacer(),
            { "  ", hl = theme.tail },
            hl = theme.fill,
          }
        end,
        option = { nerdfont = true },
      })

      -- Redraw when buffers/windows change
      vim.api.nvim_create_autocmd({ "BufWinEnter", "BufReadPost" }, {
        callback = function()
          vim.notify("Redrawing Tabby tabline...", vim.log.levels.INFO)
          vim.cmd("redrawtabline")
        end,
      })
    end,
  }

  return M
end

return M
