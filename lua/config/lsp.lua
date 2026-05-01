vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  },
})

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set("n", "<leader>ci", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = {
        "source.addMissingImports",
        "source.addMissingImports.pyright",
      },
    },
  })
end, { desc = "Add missing imports" })

vim.api.nvim_create_user_command("LspAddMissingImports", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = {
        "source.addMissingImports",
        "source.addMissingImports.pyright",
      },
    },
  })
end, { desc = "Add missing imports using LSP" })

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_blink, blink = pcall(require, "blink.cmp")
if ok_blink then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

local function project_root(bufnr, markers)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local root = vim.fs.root(filename, markers)
  return root or vim.uv.cwd() or vim.fs.dirname(filename)
end

local function python_path(root_dir)
  local venv_python = root_dir .. "/.venv/bin/python"
  if vim.uv.fs_stat(venv_python) then
    return venv_python
  end

  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

vim.lsp.config("pyright", {
  capabilities = capabilities,
  root_dir = function(bufnr, on_dir)
    on_dir(project_root(bufnr, {
      "pyrightconfig.json",
      "pyproject.toml",
      "setup.py",
      "setup.cfg",
      "requirements.txt",
      "Pipfile",
      ".git",
    }))
  end,
  before_init = function(_, config)
    config.settings = config.settings or {}
    config.settings.python = config.settings.python or {}
    config.settings.python.pythonPath = python_path(config.root_dir)
  end,
  settings = {
    python = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        extraPaths = { "src" },
        useLibraryCodeForTypes = true,
      },
    },
  },
})

vim.lsp.config("nil_ls", {
  capabilities = capabilities,
})

vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      globals = { "vim" },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.enable({
  "pyright",
  "nil_ls",
  "lua_ls",
})
