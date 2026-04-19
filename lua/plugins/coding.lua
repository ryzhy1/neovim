return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local ok, ts = pcall(require, "nvim-treesitter.configs")
      if not ok then
        return
      end

      ts.setup({
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    build = "cargo build --release",
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
          ["<C-space>"] = {},
          ["<C-p>"] = {},
          ["<Tab>"] = {},
          ["<S-Tab>"] = {},
          ["<C-y>"] = { "show", "show_documentation", "hide_documentation" },
          ["<C-n>"] = { "select_and_accept" },
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
          default = { "lsp" },
        },
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
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  {
    "L3MON4D3/LuaSnip",
    config = function()
      pcall(function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end)
    end,
  },
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  "neovim/nvim-lspconfig",
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local ok_cmp, cmp = pcall(require, "cmp")
      local ok_luasnip, luasnip = pcall(require, "luasnip")
      if not (ok_cmp and ok_luasnip) then
        return
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },
}
