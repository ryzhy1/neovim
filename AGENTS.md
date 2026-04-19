# Repository Guidelines

## Project Structure & Module Organization
This repository is a personal Neovim configuration written primarily in Lua. `init.lua` is the main entrypoint: it sets core options, bootstraps `lazy.nvim`, registers plugins, and wires theme logic. Reusable modules live under `lua/`, with current splits for editor behavior such as [`lua/lsp.lua`](/home/yaroslav/.config/nvim/lua/lsp.lua:1) and [`lua/keymap.lua`](/home/yaroslav/.config/nvim/lua/keymap.lua:1). LSP-specific definitions live under `lsp/` as return-value tables, for example `lsp/lua_ls.lua`. Static palette data is kept in `matugen_colors.lua`. `lazy-lock.json` pins plugin versions and should be updated intentionally.

## Build, Test, and Development Commands
Use Neovim itself as the runtime and test harness.

- `nvim`: start the config normally for interactive testing.
- `nvim --headless "+Lazy! sync" +qa`: install or update plugins from `init.lua`.
- `nvim --headless "+checkhealth" +qa`: run built-in diagnostics for providers, LSPs, and plugin prerequisites.
- `nvim --headless "+lua vim.print(vim.fn.has('nvim-0.10'))" +qa`: quick sanity check against expected Neovim features.

If `stylua` is installed locally, run `stylua init.lua lua/**/*.lua lsp/**/*.lua` before submitting changes.

## Coding Style & Naming Conventions
Use Lua with 2-space indentation only where the surrounding file already uses it; otherwise preserve the existing style in-place. Prefer small modules with `require(...)` boundaries instead of expanding `init.lua`. Use snake_case for file names (`matugen_colors.lua`) and descriptive module names. Keep plugin specs declarative and place nontrivial setup in `config`, `opts`, or dedicated modules. Avoid hard crashes on optional plugins; this repo commonly uses `pcall(require, ...)`.

## Testing Guidelines
There is no dedicated automated test suite in this repo. Validate changes with headless startup checks and one interactive smoke test in `nvim`. For keymaps, verify both the mapping and the underlying command. For LSP changes, open a matching filetype and confirm attach behavior, diagnostics, and completion.

## Commit & Pull Request Guidelines
Local Git history is not available in this directory, so no repository-specific commit convention could be inferred. Use short imperative commit messages such as `Add Codex LSP defaults` or `Refactor theme reload logic`. Pull requests should include a concise summary, any changed commands or prerequisites, and screenshots or terminal captures for visible UI changes such as colorscheme, statusline, tree, or floating window behavior.
