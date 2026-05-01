return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local ok, ts = pcall(require, "nvim-treesitter")
      if not ok then
        return
      end

      local languages = { "python", "lua", "nix", "go", "gomod" }

      ts.setup()
      ts.install(languages)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = languages,
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    build = "cargo build --release",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local ok, blink = pcall(require, "blink.cmp")
      if not ok then
        return
      end

      blink.setup({
        fuzzy = { implementation = "prefer_rust_with_warning" },
        signature = { enabled = true },
        keymap = {
          preset = "default",
          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
          ["<C-p>"] = {},
          ["<Tab>"] = { "select_and_accept", "fallback" },
          ["<S-Tab>"] = { "select_prev", "fallback" },
          ["<C-y>"] = { "select_and_accept" },
          ["<C-n>"] = { "select_next", "fallback" },
          ["<C-k>"] = { "select_prev", "fallback" },
          ["<C-j>"] = { "select_next", "fallback" },
          ["<C-b>"] = { "scroll_documentation_down", "fallback" },
          ["<C-f>"] = { "scroll_documentation_up", "fallback" },
          ["<C-l>"] = { "snippet_forward", "fallback" },
          ["<C-h>"] = { "snippet_backward", "fallback" },
        },
        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = "normal",
        },
        completion = {
          menu = {
            auto_show = true,
            auto_show_delay_ms = 100,
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
          },
        },
        cmdline = {
          keymap = {
            preset = "inherit",
            ["<CR>"] = { "accept_and_enter", "fallback" },
          },
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
        snippets = { preset = "luasnip" },
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      local ok, npairs = pcall(require, "nvim-autopairs")
      if not ok then
        return
      end

      npairs.setup({})
    end,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      local ok, comment = pcall(require, "Comment")
      if not ok then
        return
      end

      comment.setup()
    end,
  },
  {
    "mason-org/mason.nvim",
    config = function()
      local ok, mason = pcall(require, "mason")
      if not ok then
        return
      end

      mason.setup()
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local ok, conform = pcall(require, "conform")
      if not ok then
        return
      end

      conform.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "ruff_format" },
          go = { "gofumpt" },
        },
        format_on_save = function(bufnr)
          local filetype = vim.bo[bufnr].filetype
          if filetype == "python" or filetype == "go" or filetype == "lua" then
            return { lsp_format = "fallback", timeout_ms = 800 }
          end
        end,
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local ok, lint = pcall(require, "lint")
      if not ok then
        return
      end

      lint.linters_by_ft = {
        python = { "ruff" },
        go = { "golangcilint" },
      }

      local group = vim.api.nvim_create_augroup("NvimLint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = group,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod", "gowork", "gotmpl" },
    dependencies = {
      "ray-x/guihua.lua",
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local ok, go = pcall(require, "go")
      if not ok then
        return
      end

      go.setup({
        lsp_cfg = true,
        lsp_keymaps = false,
        gofmt = "gofumpt",
      })
    end,
  },
  {
    "ibhagwan/fzf-lua",
    config = function()
      local ok, fzf = pcall(require, "fzf-lua")
      if not ok then
        return
      end

      fzf.setup({
        winopts = { backdrop = 85 },
        keymap = {
          builtin = {
            ["<C-f>"] = "preview-page-down",
            ["<C-b>"] = "preview-page-up",
            ["<C-p>"] = "toggle-preview",
          },
          fzf = {
            ["ctrl-a"] = "toggle-all",
            ["ctrl-t"] = "first",
            ["ctrl-g"] = "last",
            ["ctrl-d"] = "half-page-down",
            ["ctrl-u"] = "half-page-up",
          },
        },
        actions = {
          files = {
            ["ctrl-q"] = fzf.actions.file_sel_to_qf,
            ["ctrl-n"] = fzf.actions.toggle_ignore,
            ["ctrl-h"] = fzf.actions.toggle_hidden,
            enter = fzf.actions.file_edit_or_qf,
          },
        },
      })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    config = function()
      pcall(function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end)
    end,
  },
  "rafamadriz/friendly-snippets",
  "neovim/nvim-lspconfig",
}
