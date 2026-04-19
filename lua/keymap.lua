vim.keymap.set("n", "<leader>e", "<Cmd>Explore<CR>")

local fzf = require("fzf-lua")

vim.keymap.set("n", "<leader><leader>", fzf.files)
vim.keymap.set("n", "<leader>/", fzf.live_grep)
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

vim.keymap.set('n', '<leader>c', ':bd<CR>', { desc = 'Close tab' })

vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>", { silent = true, desc = "Molten init" })
vim.keymap.set("n", "<leader>me", ":MoltenEvaluateOperator<CR>", { silent = true, desc = "Evaluate operator" })
vim.keymap.set("n", "<leader>ml", ":MoltenEvaluateLine<CR>", { silent = true, desc = "Evaluate line" })
vim.keymap.set("v", "<leader>mr", ":<C-u>MoltenEvaluateVisual<CR>gv", { silent = true, desc = "Evaluate selection" })
vim.keymap.set("n", "<leader>mo", ":MoltenShowOutput<CR>", { silent = true, desc = "Show output" })
vim.keymap.set("n", "<leader>mh", ":MoltenHideOutput<CR>", { silent = true, desc = "Hide output" })
vim.keymap.set("n", "<leader>md", ":MoltenDelete<CR>", { silent = true, desc = "Delete cell output" })
vim.keymap.set("n", "<leader>mx", ":MoltenReevaluateCell<CR>", { silent = true, desc = "Re-run cell" })
vim.keymap.set("n", "<leader>ms", ":noautocmd MoltenEnterOutput<CR>", { silent = true, desc = "Focus output" })

local term_buf = nil
local term_win = nil

vim.keymap.set("n", "<leader>tt", function()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, true)
    term_win = nil
  else
    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
      vim.cmd("botright 12split")
      vim.api.nvim_win_set_buf(0, term_buf)
      term_win = vim.api.nvim_get_current_win()
    else
      vim.cmd("botright 12split | terminal")
      term_buf = vim.api.nvim_get_current_buf()
      term_win = vim.api.nvim_get_current_win()
    end
  end
end)

vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })

vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Prev diagnostic" })
vim.keymap.set("n", "<leader>w", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics list" })
