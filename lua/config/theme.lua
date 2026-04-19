local M = {}

function M.reload()
  vim.schedule(function()
    local installed = pcall(require, "catppuccin")
    if not installed then
      return
    end

    for name in pairs(package.loaded) do
      if name:match("^catppuccin") then
        package.loaded[name] = nil
      end
    end

    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") == 1 then
      vim.cmd("syntax reset")
    end
    vim.g.colors_name = nil

    local ok_cat, catppuccin = pcall(require, "catppuccin")
    if ok_cat then
      catppuccin.setup({
        flavour = "macchiato",
        compile = { enabled = false },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          bufferline = true,
          telescope = { enabled = true },
          indent_blankline = { enabled = true },
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          },
        },
      })
      vim.cmd("colorscheme tokyonight")
    end

    local ok_lualine, lualine = pcall(require, "lualine")
    if ok_lualine then
      lualine.setup({
        options = { theme = "tokyonight" },
      })
    end

    vim.cmd("redraw!")
    vim.notify("Catppuccin reloaded!", vim.log.levels.INFO)
  end)
end

function M.setup()
  _G.reload_catppuccin = M.reload
  M.reload()
end

return M
