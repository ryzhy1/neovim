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

vim.lsp.config("basedpyright", {
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp_lsp then
  capabilities = cmp_nvim_lsp.default_capabilities()
end

local function setup_server(server_name, config)
  local ok, server_config = pcall(require, "lspconfig.server_configurations." .. server_name)
  if not ok then
    return
  end

  local default_config = server_config.default_config
  local final_config = vim.tbl_deep_extend("force", default_config, config or {})
  final_config.capabilities = vim.tbl_deep_extend(
    "force",
    final_config.capabilities or {},
    capabilities
  )

  vim.api.nvim_create_autocmd("FileType", {
    pattern = final_config.filetypes,
    callback = function(args)
      local instance_config = vim.tbl_deep_extend("force", {}, final_config)
      local root_dir = final_config.root_dir

      if type(root_dir) == "function" then
        root_dir = root_dir(args.file)
      end

      instance_config.root_dir = root_dir or vim.fs.dirname(args.file)
      vim.lsp.start(instance_config)
    end,
  })
end

setup_server("basedpyright", {})
setup_server("nil_ls", {})
setup_server("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      globals = { "vim" },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})
