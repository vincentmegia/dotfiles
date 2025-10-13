local M = {}

function M.setup()
  M.spec = {
    "nanozuki/tabby.nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local ok, tabby = pcall(require, "tabby")
      if not ok then return end

      local devicons_ok, devicons = pcall(require, "nvim-web-devicons")

      -- One Dark theme highlights
      vim.cmd([[
        highlight TabLineSel  guibg=#61AFEF guifg=#282C34 gui=bold
        highlight TabLine     guibg=#282C34 guifg=#ABB2BF
        highlight TabLineFill guibg=#282C34 guifg=#ABB2BF
        highlight TabLineHead guibg=#282C34 guifg=#98C379 gui=bold
        highlight TabLineTail guibg=#282C34 guifg=#E06C75 gui=bold
        highlight TabLineWin  guibg=#282C34 guifg=#C678DD
      ]])

      local theme = {
        fill = "TabLineFill",
        head = "TabLineHead",
        current_tab = "TabLineSel",
        tab = "TabLine",
        win = "TabLineWin",
        tail = "TabLineTail",
      }

      -- Get filename from buffer number
      local function filename_from_bufnr(bufnr)
        if not bufnr or bufnr == 0 then return nil end
        local name = vim.api.nvim_buf_get_name(bufnr)
        if not name or name == "" then return nil end
        local fname = vim.fn.fnamemodify(name, ":t")
        if devicons_ok then
          local icon = devicons.get_icon(name, vim.fn.fnamemodify(name, ":e"), { default = true }) or ""
          return icon .. " " .. fname
        end
        return fname
      end

      -- Get representative filename for a tab (first valid buffer)
      local function tab_filename(tabid)
        local wins = vim.api.nvim_tabpage_list_wins(tabid)
        for _, winid in ipairs(wins) do
          local buf = vim.api.nvim_win_get_buf(winid)
          local bufname = vim.api.nvim_buf_get_name(buf)
          if bufname ~= "" and not bufname:match("NvimTree") then
            local fname = filename_from_bufnr(buf)
            if fname then
              return fname
            end
          end
        end
        return "[No Name]"
      end

      -- Tabby line setup
      tabby.setup({
        line = function(line)
          return {
            -- Head
            { "  ", hl = theme.head },

            -- Tabs
            line.tabs().foreach(function(tab)
              local hl = tab.is_current() and theme.current_tab or theme.tab
              local tabid = tab.id or 0
              local fname = tab_filename(tabid)
              return { string.format(" %d: %s ", tab.number(), fname), hl = hl, margin = " " }
            end),

            line.spacer(),

            -- Tail
            { "  ", hl = theme.tail },

            hl = theme.fill,
          }
        end,
        option = { nerdfont = true },
      })

      -- Redraw when buffers/windows change
      vim.api.nvim_create_autocmd({ "BufWinEnter", "BufReadPost" }, {
        callback = function()
          vim.cmd("redrawtabline")
        end,
      })
    end,
  }

  return M
end

return M
