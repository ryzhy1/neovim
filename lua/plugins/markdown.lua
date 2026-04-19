return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local ok, render_markdown = pcall(require, "render-markdown")
      if not ok then
        return
      end

      render_markdown.setup({})
    end,
  },
}
