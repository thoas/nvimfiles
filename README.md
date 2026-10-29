# nvimfiles

My Neovim config: a file tree, fuzzy finding, completion and LSP for Go, Python and JavaScript/TypeScript, with the molokai color scheme.

Requires **Neovim 0.12+**. Plugins are managed by the built-in `vim.pack`, so there's no plugin manager to bootstrap.

## Install

```bash
git clone git@github.com:thoas/nvimfiles.git ~/.config/nvim
nvim
```

On first start, `vim.pack` installs the plugins at the versions pinned in `nvim-pack-lock.json`, and Mason installs the language servers.

Needs `git` and, for the language servers, `go` (gopls) and `npm` (pyright, ts_ls).

## What's inside

| | |
|---|---|
| File tree | [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua) |
| Fuzzy finder | [Telescope](https://github.com/nvim-telescope/telescope.nvim) |
| Completion | [blink.cmp](https://github.com/saghen/blink.cmp) |
| Language servers | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig), installed by [Mason](https://github.com/mason-org/mason.nvim) |
| Status line / git | [lualine](https://github.com/nvim-lualine/lualine.nvim), [gitsigns](https://github.com/lewis6991/gitsigns.nvim) |
| Color scheme | molokai (`colors/molokai.vim`) |

### Language servers

| Language | Servers | Format on save |
|---|---|---|
| Go | gopls (gofumpt, staticcheck) | yes |
| Python | pyright, ruff | yes (ruff) |
| JavaScript / TypeScript | ts_ls | no |

**Python projects using mypy:** when a project's `.venv` has `pylsp-mypy` installed (e.g. Django with django-stubs), type errors come from mypy through the project's own `pylsp`, and pyright's type checking is turned off. Pyright still provides completion and navigation, and uses the project's `.venv` either way.

## Keymaps

Leader is `,`.

### General

| Keys | Action |
|---|---|
| `Ctrl-s` | Save (normal, insert, visual) |
| `,w` | Save |
| `Ctrl-w` | Close buffer |
| `Ctrl-h/j/k/l` | Move between windows |
| `←` / `→` | Previous / next tab |
| `↑` / `↓` | Previous / next buffer |
| `,tn` / `,tc` | New tab / close tab |
| `,<Space>` or `Esc` | Clear search highlight |
| `Tab` / `Shift-Tab` | Indent / dedent line (insert) or selection (visual) |

### File tree and search

| Keys | Action |
|---|---|
| `F9` or `,e` | Toggle the tree |
| `,E` | Reveal the current file in the tree |
| `s` / `i` / `t` (in tree) | Open in vertical split / horizontal split / new tab |
| `,ff` / `,fg` / `,fb` | Find files / live grep / buffers |

### LSP

| Keys | Action |
|---|---|
| `gd` / `gD` / `gy` | Definition / declaration / type definition |
| `grr` / `gri` | References / implementation |
| `K` | Hover docs |
| `,rn` | Rename |
| `,ca` | Code action |
| `,cf` | Format |
| `[d` / `]d` | Previous / next diagnostic |
| `,d` / `,q` | Line diagnostic / all diagnostics to location list |

### Completion

The menu opens as you type.

| Keys | Action |
|---|---|
| `Ctrl-n` | Open the menu, or select next |
| `Ctrl-p` | Select previous |
| `Enter` | Accept |
| `Ctrl-e` | Close |

### Python debugger shortcuts

Type the trigger alone on a line, then press `Tab`:

| Trigger | Inserts |
|---|---|
| `pdb` | `import pdb; pdb.set_trace()` |
| `ipdb` | `import ipdb; ipdb.set_trace()` |
| `bp` | `breakpoint()` |

## Layout

```
init.lua                  leader, loads everything below
lua/config/options.lua    editor options, per-language indentation
lua/config/keymaps.lua    general keymaps
lua/config/lsp.lua        language servers, LSP keymaps, format on save
lua/plugins.lua           plugin list and setup
after/ftplugin/python.lua Python debugger shortcuts
colors/molokai.vim        color scheme
nvim-pack-lock.json       pinned plugin versions
```

## Updating

```vim
:lua vim.pack.update()   " plugins
:Mason                   " language servers
```
