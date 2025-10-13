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

      local has_icons, devicons = pcall(require, "nvim-web-devicons")

      local theme = {
        fill        = "TabLineFill",
        head        = "TabLine",
        current_tab = "TabLineSel",
        other_tab   = "TabLine",
        window      = "TabLine",
        tail        = "TabLine",
      }

      local function filename_from_buf(bufnr)
        if not bufnr or bufnr == 0 then return "[No Name]" end
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name == "" then return "[No Name]" end
        local fname = vim.fn.fnamemodify(name, ":t")
        if has_icons then
          local ext = vim.fn.fnamemodify(name, ":e")
          local icon = devicons.get_icon(fname, ext, { default = true }) or ""
          return icon .. " " .. fname
        end
        return fname
      end

      tabby.setup({
        line = function(line)
          return {
            { "  ", hl = theme.head },
            line.tabs().foreach(function(tab)
              local hl = tab.is_current() and theme.current_tab or theme.other_tab
              local tabid = tab.id
              local wins = vim.api.nvim_tabpage_list_wins(tabid)
              local name = "[No Name]"
              if #wins > 0 then
                local bufnr = vim.api.nvim_win_get_buf(wins[1])
                name = filename_from_buf(bufnr)
              end
              return {
                string.format(" %d: %s ", tab.number(), name),
                hl = hl,
                margin = " ",
              }
            end),
            line.spacer(),
            { "  ", hl = theme.tail },
            hl = theme.fill,
          }
        end,
        option = { nerdfont = true },
      })

      vim.api.nvim_create_autocmd({ "BufEnter", "TabNew", "TabClosed", "BufAdd", "BufDelete" }, {
        callback = function()
          vim.cmd("redrawtabline")
        end,
      })
    end,
  }

  return M
end

return M
