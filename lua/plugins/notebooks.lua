return {
  {
    "goerz/jupytext.nvim",
    lazy = false,
    config = true,
  },
  {
    "cmorales95/jupytext-render.nvim",
    lazy = false,
    opts = {},
  },
  {
    "3rd/image.nvim",
    opts = {},
  },
  {
    "benlubas/molten-nvim",
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_output_win_max_height = 20
    end,
  },
}
