return {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "folke/tokyonight.nvim", priority = 999 },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("config.theme").setup()
    end,
  },
  "nvim-tree/nvim-web-devicons",
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        filters = { dotfiles = false },
        view = { 
	  width = 30,
	  number = true,
	  relativenumber = true,
	},
	
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
        },
      })
      pcall(telescope.load_extension, "ui-select")
    end,
  },
  "nvim-telescope/telescope-ui-select.nvim",
  {
    "3rd/image.nvim",
    build = false,
    config = function()
      require("image").setup({
        backend = "kitty",
        integrations = {
          markdown = { enabled = true },
          neorg = { enabled = false },
        },
        max_width_window_percentage = 100,
        max_height_window_percentage = 100,
        kitty_method = "normal",
      })

      local scale = 1.0

      local function rescale(delta)
        scale = math.max(0.2, math.min(scale + delta, 4.0))
        local api = require("image")
        local images = api.get_images()
        for _, img in ipairs(images) do
          local w = img.image_width
          local h = img.image_height
          if w and h then
            -- convert pixel dimensions to terminal cells (approx 8x16 px per cell)
            local cell_w = math.floor(w / 8 * scale)
            local cell_h = math.floor(h / 16 * scale)
            img:clear()
            img.geometry.width = cell_w
            img.geometry.height = cell_h
            img:render()
          end
        end
        vim.notify(string.format("Image scale: %.1fx", scale), vim.log.levels.INFO)
      end

      vim.keymap.set("n", "<leader>i+", function() rescale(0.25) end, { desc = "Image zoom in" })
      vim.keymap.set("n", "<leader>i-", function() rescale(-0.25) end, { desc = "Image zoom out" })
      vim.keymap.set("n", "<leader>i0", function()
        scale = 1.0
        local api = require("image")
        for _, img in ipairs(api.get_images()) do
          img:clear()
          img.geometry.width = nil
          img.geometry.height = nil
          img:render()
        end
        vim.notify("Image scale: reset", vim.log.levels.INFO)
      end, { desc = "Image reset zoom" })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          diagnostics = "nvim_lsp",
          separator_style = "slant",
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "left",
              separator = true,
            },
          },
        },
      })
    end,
  },
}
