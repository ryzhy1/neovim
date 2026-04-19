# Repository Guidelines

## Project Structure & Module Organization
This repository is a personal Neovim configuration written in Lua. `init.lua` is intentionally thin and only wires core modules from `lua/config/`:

- `lua/config/options.lua` — editor options and leader keys
- `lua/config/lazy.lua` — `lazy.nvim` bootstrap and plugin import
- `lua/config/lsp.lua` — diagnostics + LSP startup (`basedpyright`, `lua_ls`, `nil_ls`)
- `lua/config/keymaps.lua` — global keymaps
- `lua/config/autocmds.lua` — autocommands
- `lua/config/theme.lua` — colorscheme and lualine orchestration

Plugins are split by domain under `lua/plugins/` (`coding.lua`, `ui.lua`, `notebooks.lua`, `codex.lua`, `markdown.lua`) and loaded through `{ import = "plugins" }`. `lazy-lock.json` pins plugin versions and should be changed intentionally.

Compatibility shims `lua/lsp.lua` and `lua/keymap.lua` currently re-export `config.*`; prefer editing `lua/config/*` directly. Static palette data is in `matugen_colors.lua`.

## Build, Test, and Development Commands
Use Neovim itself as the runtime and test harness.

- `nvim`: start the config normally for interactive testing.
- `nvim --headless "+Lazy! sync" +qa`: install or update plugins from `init.lua`.
- `nvim --headless "+checkhealth" +qa`: run built-in diagnostics for providers, LSPs, and plugin prerequisites.
- `nvim --headless "+lua vim.print(vim.fn.has('nvim-0.10'))" +qa`: quick sanity check against expected Neovim features.
- `luac -p lua/config/*.lua lua/plugins/*.lua`: syntax check for changed Lua modules.

If `stylua` is installed locally, run `stylua init.lua lua/**/*.lua lsp/**/*.lua` before submitting changes.

## Coding Style & Naming Conventions
Use Lua with 2-space indentation only where the surrounding file already uses it; otherwise preserve the existing style in-place. Prefer small modules with `require(...)` boundaries instead of expanding `init.lua`. Use snake_case for file names (`matugen_colors.lua`) and descriptive module names. Keep plugin specs declarative and place nontrivial setup in `config`, `opts`, or dedicated modules. Avoid hard crashes on optional plugins; this repo commonly uses `pcall(require, ...)`.

## Testing Guidelines
There is no dedicated automated test suite in this repo. Validate changes with headless startup checks and one interactive smoke test in `nvim`. For keymaps, verify both the mapping and the underlying command. For LSP changes, open a matching filetype and confirm attach behavior, diagnostics, and completion.

## Commit & Pull Request Guidelines
Git history is available in this directory. Use short imperative commit messages such as `Add markdown renderer` or `Align Python LSP with basedpyright`. Pull requests should include a concise summary, changed commands/prerequisites, and screenshots or terminal captures for visible UI changes (colorscheme, statusline, tree, floating windows, markdown rendering).
