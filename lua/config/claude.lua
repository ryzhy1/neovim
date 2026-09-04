local M = {}

local config = {
  border = "rounded",
  width = 0.8,
  height = 0.8,
  cmd = { "claude" },
  filetype = "claude",
  keymaps = {
    quit = "<C-q>",
  },
}

local state = {
  buf = nil,
  win = nil,
  job = nil,
}

local function create_buf()
  local buf = vim.api.nvim_create_buf(false, false)

  vim.api.nvim_set_option_value("bufhidden", "hide", { buf = buf })
  vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
  vim.api.nvim_set_option_value("filetype", config.filetype, { buf = buf })

  if config.keymaps.quit then
    local quit_cmd = [[<cmd>lua require("config.claude").close()<CR>]]
    vim.api.nvim_buf_set_keymap(
      buf,
      "t",
      config.keymaps.quit,
      [[<C-\><C-n>]] .. quit_cmd,
      { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(buf, "n", config.keymaps.quit, quit_cmd, { noremap = true, silent = true })
  end

  return buf
end

local function open_window()
  local width = math.floor(vim.o.columns * config.width)
  local height = math.floor(vim.o.lines * config.height)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  state.win = vim.api.nvim_open_win(state.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = config.border,
  })
end

local function reset_dead_buffer()
  if state.job or not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    return
  end

  pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
  state.buf = nil
end

function M.open()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_set_current_win(state.win)
    return
  end

  if vim.fn.executable(config.cmd[1]) == 0 then
    if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
      state.buf = create_buf()
    end

    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, {
      "Claude CLI not found.",
      "",
      "Expected executable:",
      "  claude",
    })
    open_window()
    return
  end

  reset_dead_buffer()

  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    state.buf = create_buf()
  end

  open_window()

  if not state.job then
    state.job = vim.fn.termopen(config.cmd, {
      cwd = vim.uv.cwd(),
      on_exit = function()
        state.job = nil
      end,
    })
  end
end

function M.close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end

  state.win = nil
end

function M.toggle()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    M.close()
  else
    M.open()
  end
end

function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})

  vim.api.nvim_create_user_command("Claude", function()
    M.toggle()
  end, { desc = "Toggle Claude popup" })

  vim.api.nvim_create_user_command("ClaudeToggle", function()
    M.toggle()
  end, { desc = "Toggle Claude popup" })
end

return M
