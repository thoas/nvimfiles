# nvimfiles

My Neovim config: a file tree, fuzzy finding, completion and LSP for Go, Python and JavaScript/TypeScript, with the molokai color scheme.

Requires **Neovim 0.12+**. Plugins are managed by the built-in `vim.pack`, so there's no plugin manager to bootstrap.

## Install

```bash
git clone git@github.com:thoas/nvimfiles.git ~/.config/nvim
nvim
```

On first start, `vim.pack` installs the plugins at the versions pinned in `nvim-pack-lock.json`, and Mason installs the language servers, prettier and goimports.

Needs `git`, `go` (gopls, goimports) and `npm` (pyright, ts_ls, prettier).

Optional, for the Go `iferr` snippet:

```bash
go install github.com/koron/iferr@latest
```

## What's inside

| | |
|---|---|
| File tree | [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua) |
| Fuzzy finder | [Telescope](https://github.com/nvim-telescope/telescope.nvim) |
| Completion | [blink.cmp](https://github.com/saghen/blink.cmp) |
| Auto-close brackets and quotes | [nvim-autopairs](https://github.com/windwp/nvim-autopairs) |
| Formatting | [conform.nvim](https://github.com/stevearc/conform.nvim) |
| Language servers | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig), installed by [Mason](https://github.com/mason-org/mason.nvim) |
| Status line / git | [lualine](https://github.com/nvim-lualine/lualine.nvim), [gitsigns](https://github.com/lewis6991/gitsigns.nvim) |
| Color scheme | molokai (`colors/molokai.vim`) |

### Language servers

| Language | Servers | Formatter (`,f`) | Format on save |
|---|---|---|---|
| Go | gopls (one shared instance for all nvims) | goimports | yes |
| Python | pyright, ruff | ruff (sort imports, then format) | yes |
| JavaScript / TypeScript | ts_ls | prettier | no |

**Auto-imports:** accepting a completion for something not imported yet adds the import (gopls, pyright, ts_ls; for JS, the project needs a `jsconfig.json` or `tsconfig.json`). In Go, goimports also adds missing and removes unused imports on save; in Python, imports are sorted on save.

prettier also formats JSON, CSS/SCSS, HTML, Markdown and YAML, and is taken from the project's `node_modules` when it has one. Other filetypes fall back to their language server's formatter.

**Python projects using mypy:** when a project's `.venv` has `pylsp-mypy` installed (e.g. Django with django-stubs), type errors come from mypy through the project's own `pylsp`, and pyright's type checking is turned off. Pyright still provides completion and navigation, and uses the project's `.venv` either way.

### Jinja2 templates

`.j2`, `.jinja` and `.jinja2` files, and `.html` files under a `templates/` folder, open as Jinja: HTML highlighting and indentation with Jinja tags highlighted on top (even inside attributes), and `gcc` comments with `{# #}`. Templates of a Django app (a `templates/` folder next to `apps.py` or `models.py`) stay Django templates.

There's no Jinja language server: jinja-lsp flags every variable passed from Python as undefined.

Snippets: type the prefix, then `Tab` (or pick it from the completion menu); `Tab` then jumps between the fields.

| Prefix | Inserts |
|---|---|
| `if` | `{% if … %}` … `{% endif %}` |
| `ifelse` | `{% if … %}` … `{% else %}` … `{% endif %}` |
| `endif` | `{% endif %}` |
| `for` | `{% for … in … %}` … `{% endfor %}` |
| `block` | `{% block … %}` … `{% endblock %}` |
| `extends` | `{% extends "…" %}` |
| `include` | `{% include "…" %}` |
| `url` | `{{ url('…') }}` |
| `static` | `{{ static('…') }}` |

They live in `snippets/jinja.json` (VS Code snippet format); add a `snippets/<filetype>.json` and call `require("config.snippets").tab_expand("<filetype>")` from its ftplugin for other languages.

## Keymaps

Leader is `,`.

### General

| Keys | Action |
|---|---|
| `Ctrl-s` | Save (normal, insert, visual) |
| `,w` | Save |
| `,f` | Format the file (normal) or selected lines (visual) |
| `Ctrl-w` | Close buffer |
| `Ctrl-q` | Close the file's window (`:q`) |
| `,r` | Reload the file from disk (refuses if it has unsaved changes) |
| `Ctrl-h/j/k/l` | Move between windows |
| `←` / `→` | Previous / next tab |
| `↑` / `↓` | Previous / next buffer |
| `,tn` / `,tc` | New tab / close tab |
| `j` / `k` | Down / up one screen line on wrapped text (`gj` / `gk`); with a count (`5j`), real lines |
| `,<Space>` or `Esc` | Clear search highlight |
| `Tab` / `Shift-Tab` | Indent / dedent line (insert) or selection (visual) |

### File tree and search

| Keys | Action |
|---|---|
| `F9` or `,e` | Toggle the tree |
| `,E` | Reveal the current file in the tree |
| `s` / `i` / `t` (in tree) | Open in vertical split / horizontal split / new tab |
| `,p` / `,g` / `,b` | Find files / live grep / buffers |

When closing a window (`:q`, `Ctrl-q`, `Ctrl-w`) leaves only the tree in a tab, the tab closes too, or nvim quits if it was the last tab.

### LSP

| Keys | Action |
|---|---|
| `gd` / `gD` / `gy` | Definition / declaration / type definition |
| `grr` / `gri` | References / implementation |
| `K` | Hover docs |
| `grn` | Rename |
| `,ca` | Code action |
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

### Go snippets

Type the prefix, then `Tab` (or pick it from the completion menu); `Tab` then jumps between the fields.

| Prefix | Inserts |
|---|---|
| `iferr` | `if err != nil {` `return …, err` `}`, with zero values matching the function's return types |
| `func` | `func name(…) error {` … `}` |

`iferr` uses [koron/iferr](https://github.com/koron/iferr) (found on `PATH` or in `$(go env GOPATH)/bin`), so in `func f() (*User, string, error)` it inserts `return nil, "", err`; `err` is a field to type over (e.g. with `fmt.Errorf`). Without the tool, or when the file doesn't parse yet, it inserts `return err`.

## Layout

```
init.lua                  leader, loads everything below
lua/config/options.lua    editor options, per-language indentation
lua/config/keymaps.lua    general keymaps
lua/config/lsp.lua        language servers, LSP keymaps
lua/plugins.lua           plugin list and setup, formatters
after/ftplugin/python.lua Python debugger shortcuts
after/ftplugin/jinja.lua  Jinja comment style, snippet Tab expansion
lua/config/snippets.lua   Tab expansion of snippets/<filetype>.json
lua/config/tabline.lua    tab line in the molokai/lualine colors
after/ftplugin/go.lua     Go snippet Tab expansion
snippets/jinja.json       Jinja snippets
snippets/go.json          Go snippets
syntax/jinja.vim          HTML + Jinja highlighting for .html templates
indent/jinja.vim          HTML indentation for .html templates
colors/molokai.vim        color scheme
nvim-pack-lock.json       pinned plugin versions
```

## Updating

```vim
:lua vim.pack.update()   " plugins
:Mason                   " language servers
```
