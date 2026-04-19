# Neovim Config

Персональная конфигурация Neovim на Lua.

## Быстрый старт

```bash
nvim
nvim --headless "+Lazy! sync" +qa
nvim --headless "+checkhealth" +qa
```

## Структура

- `init.lua` — точка входа.
- `lua/config/options.lua` — базовые опции.
- `lua/config/keymaps.lua` — глобальные бинды.
- `lua/config/lsp.lua` — LSP и диагностика.
- `lua/config/theme.lua` — настройка темы и lualine.
- `lua/plugins/*.lua` — декларации плагинов по подсистемам.
- `lazy-lock.json` — pinned-версии плагинов.

## Базовые настройки

- `mapleader = " "` (Space), `maplocalleader = " "`.
- Нумерация: `number`, `relativenumber`.
- Буфер обмена: `clipboard=unnamedplus`.
- Undo history: `undofile=true`, `undodir=stdpath("state")/undo`.
- Поиск: `ignorecase + smartcase`.
- UI: `termguicolors`, `signcolumn=yes`.
- Автокоманда: при `TermOpen` сразу включается `startinsert`.

## Бинды

### Глобальные

| Mode | Бинд | Действие |
|---|---|---|
| `n` | `<leader>e` | `:Explore` |
| `n` | `<leader><leader>` | `fzf-lua`: поиск файлов |
| `n` | `<leader>/` | `fzf-lua`: live grep |
| `t` | `<C-q>` | выйти из terminal-mode в normal |
| `n` | `<leader>tt` | toggle встроенного терминала (нижний split) |
| `n` | `<C-n>` | toggle `NvimTree` |
| `n` | `<Tab>` / `<S-Tab>` | следующий / предыдущий буфер (`bufferline`) |
| `n` | `<leader>x` | закрыть буфер (`:bdelete`) |
| `n` | `<leader>c` | закрыть буфер (`:bd`) |

### Поиск (Telescope)

| Mode | Бинд | Действие |
|---|---|---|
| `n` | `<leader>ff` | `telescope.find_files` |
| `n` | `<leader>fg` | `telescope.live_grep` |
| `n` | `<leader>fb` | `telescope.buffers` |

### LSP и диагностика

| Mode | Бинд | Действие |
|---|---|---|
| `n` | `gd` | перейти к определению |
| `n` | `gD` | перейти к декларации |
| `n` | `gr` | найти референсы |
| `n` | `]d` / `[d` | след./пред. диагностика |
| `n` | `<leader>w` | float-окно диагностики |
| `n` | `<leader>q` | список диагностик (`loclist`) |

### Jupyter/Molten

| Mode | Бинд | Действие |
|---|---|---|
| `n` | `<leader>mi` | `:MoltenInit` |
| `n` | `<leader>me` | `:MoltenEvaluateOperator` |
| `n` | `<leader>ml` | `:MoltenEvaluateLine` |
| `v` | `<leader>mr` | `:MoltenEvaluateVisual` |
| `n` | `<leader>mo` | показать output |
| `n` | `<leader>mh` | скрыть output |
| `n` | `<leader>md` | удалить output ячейки |
| `n` | `<leader>mx` | переисполнить ячейку |
| `n` | `<leader>ms` | перейти в output-окно |

### Codex.nvim

| Mode | Бинд | Действие |
|---|---|---|
| `n`, `t` | `<leader>cc` | toggle Codex popup/panel |
| `t` | `<C-q>` | quit в Codex-терминале (и общий terminal escape) |

### Completion (Blink)

Кастомные клавиши в меню автодополнения:

- `<C-y>`: show/show docs/hide docs
- `<C-n>`: select and accept
- `<C-k>` / `<C-j>`: prev/next
- `<C-b>` / `<C-f>`: scroll docs down/up
- `<C-l>` / `<C-h>`: snippet forward/backward
- `<CR>` в cmdline: accept and enter

## LSP, форматирование, линтинг

### LSP серверы

- Python: `basedpyright`
- Nix: `nil_ls`
- Lua: `lua_ls`
- Go: `go.nvim` поднимает `gopls` для Go-файлов

### Форматирование (`conform.nvim`)

- `python` → `ruff_format`
- `go` → `gofumpt`
- `lua` → `stylua`

Формат на сохранение включен для `python`, `go`, `lua`.

### Линтинг (`nvim-lint`)

- `python` → `ruff`
- `go` → `golangci-lint`

Запуск линтинга на `BufEnter`, `BufWritePost`, `InsertLeave`.

## UI и плагины

- Тема: конфиг Catppuccin, фактически применяется `tokyonight`.
- Статуслайн: `lualine` c темой `tokyonight`.
- Файловое дерево: `nvim-tree`.
- Git signs: `gitsigns`.
- Отступы: `indent-blankline` (`ibl`).
- Подсказки клавиш: `which-key`.

## Важные заметки

- В конфиге включены оба completion-плагина: `blink.cmp` и `nvim-cmp`. Это может давать пересечение поведения completion.
- `go.nvim` настроен как владелец Go LSP (`gopls`), чтобы избежать дублей ручной настройки Go-сервера в общем LSP-модуле.
