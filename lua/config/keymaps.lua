vim.keymap.set("n", "<leader>e", "<Cmd>Explore<CR>")

vim.keymap.set("n", "<leader><leader>", function()
  require("fzf-lua").files()
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>/", function()
  require("fzf-lua").live_grep()
end, { desc = "Live grep" })

vim.keymap.set("t", "<C-q>", [[<C-\><C-n>]])

vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
  noremap = true,
  silent = true,
  desc = "Go to definition",
})

vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {
  noremap = true,
  silent = true,
  desc = "Go to declaration",
})

vim.keymap.set("n", "gr", vim.lsp.buf.references, {
  noremap = true,
  silent = true,
  desc = "Go to references",
})

vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>", { silent = true, desc = "Molten init" })
vim.keymap.set(
  "n",
  "<leader>me",
  ":MoltenEvaluateOperator<CR>",
  { silent = true, desc = "Evaluate operator" }
)
vim.keymap.set(
  "n",
  "<leader>ml",
  ":MoltenEvaluateLine<CR>",
  { silent = true, desc = "Evaluate line" }
)
vim.keymap.set(
  "v",
  "<leader>mr",
  ":<C-u>MoltenEvaluateVisual<CR>gv",
  { silent = true, desc = "Evaluate selection" }
)
vim.keymap.set("n", "<leader>mo", ":MoltenShowOutput<CR>", { silent = true, desc = "Show output" })
vim.keymap.set("n", "<leader>mh", ":MoltenHideOutput<CR>", { silent = true, desc = "Hide output" })
vim.keymap.set("n", "<leader>md", ":MoltenDelete<CR>", { silent = true, desc = "Delete cell output" })
vim.keymap.set("n", "<leader>mx", ":MoltenReevaluateCell<CR>", { silent = true, desc = "Re-run cell" })
vim.keymap.set(
  "n",
  "<leader>ms",
  ":noautocmd MoltenEnterOutput<CR>",
  { silent = true, desc = "Focus output" }
)

local term_buf = nil
local term_win = nil

vim.keymap.set("n", "<leader>tt", function()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    if #vim.api.nvim_list_wins() > 1 then
      vim.api.nvim_win_close(term_win, true)
    else
      vim.cmd("quit")
    end
    term_win = nil
    return
  end

  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.cmd("botright 12split")
    vim.api.nvim_win_set_buf(0, term_buf)
    term_win = vim.api.nvim_get_current_win()
    return
  end

  vim.cmd("botright 12split | terminal")
  term_buf = vim.api.nvim_get_current_buf()
  term_win = vim.api.nvim_get_current_win()
end)

vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })

vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Prev diagnostic" })

vim.keymap.set("n", "<leader>w", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics list" })

vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", {
  silent = true,
  desc = "Toggle file explorer",
})

vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>fg", function()
  require("telescope.builtin").live_grep()
end, { desc = "Live grep" })

vim.keymap.set("n", "<leader>fb", function()
  require("telescope.builtin").buffers()
end, { desc = "Find buffers" })

vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true })
vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })
vim.keymap.set("n", "<leader>x", ":bdelete<CR>", {
  silent = true,
  desc = "Close buffer",
})
