-- Server definitions come from nvim-lspconfig; mason installs the binaries
-- and mason-lspconfig calls vim.lsp.enable() for each installed server.

-- Advertise blink.cmp's completion capabilities to every server
vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

vim.lsp.config("gopls", {
  -- All nvim instances share one gopls daemon (and its cache) instead of each
  -- loading the module on its own
  cmd = { "gopls", "-remote=auto" },
  settings = {
    gopls = {
      -- staticcheck kept gopls at full CPU for minutes on large modules (ulule/api)
      staticcheck = false,
      usePlaceholders = true,
      -- Default 100ms cuts off unimported-package members (`slices.`) in big
      -- modules, leaving a partial menu until the next keystroke
      completionBudget = "1s",
      analyses = { unusedparams = true, shadow = true },
    },
  },
})

-- Projects whose venv ships pylsp-mypy (e.g. Django + django-stubs) type-check
-- with mypy through pylsp, like their Zed setup; pyright then only does
-- completion/navigation, since without the Django plugin it flags every
-- generated attribute (reverse relations, `<fk>_id`, ...).
local function has_pylsp_mypy(root)
  return root ~= nil
    and vim.fn.executable(root .. "/.venv/bin/pylsp") == 1
    and #vim.fn.glob(root .. "/.venv/lib/*/site-packages/pylsp_mypy", false, true) > 0
end

local python_root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" }

vim.lsp.config("pyright", {
  settings = {
    -- Leave import organizing to ruff
    pyright = { disableOrganizeImports = true },
    python = { analysis = { typeCheckingMode = "basic" } },
  },
  before_init = function(_, config)
    local python = config.root_dir and config.root_dir .. "/.venv/bin/python"
    if python and vim.fn.executable(python) == 1 then
      config.settings.python.pythonPath = python
    end
    if has_pylsp_mypy(config.root_dir) then
      config.settings.python.analysis.typeCheckingMode = "off"
    end
  end,
})

vim.lsp.config("pylsp", {
  -- .venv/bin leads the PATH so pylsp-mypy runs the project's mypy
  cmd = function(dispatchers, config)
    local bin = config.root_dir .. "/.venv/bin"
    return vim.lsp.rpc.start({ bin .. "/pylsp" }, dispatchers, {
      cwd = config.root_dir,
      env = { PATH = bin .. ":" .. vim.env.PATH, VIRTUAL_ENV = config.root_dir .. "/.venv" },
    })
  end,
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, python_root_markers)
    if has_pylsp_mypy(root) then on_dir(root) end
  end,
  settings = {
    pylsp = {
      plugins = {
        pylsp_mypy = { enabled = true, live_mode = true },
        autopep8 = { enabled = false },
        flake8 = { enabled = false },
        jedi_completion = { enabled = false },
        jedi_definition = { enabled = false },
        jedi_hover = { enabled = false },
        jedi_references = { enabled = false },
        jedi_signature_help = { enabled = false },
        jedi_symbols = { enabled = false },
        mccabe = { enabled = false },
        preload = { enabled = false },
        pycodestyle = { enabled = false },
        pydocstyle = { enabled = false },
        pyflakes = { enabled = false },
        pylint = { enabled = false },
        rope_autoimport = { enabled = false },
        rope_completion = { enabled = false },
        yapf = { enabled = false },
      },
    },
  },
})
-- Not managed by mason: pylsp comes from each project's own venv
vim.lsp.enable("pylsp")

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "gopls",   -- Go
    "pyright", -- Python types/navigation
    "ruff",    -- Python lint + format
    "ts_ls",   -- JavaScript / TypeScript
  },
})

-- Formatters used by conform.nvim that aren't language servers
local registry = require("mason-registry")
registry.refresh(function()
  for _, name in ipairs({ "prettier", "goimports" }) do
    local pkg = registry.get_package(name)
    if not pkg:is_installed() then pkg:install() end
  end
end)

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = { border = "rounded" },
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local buf = args.buf
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
    end

    -- Built-in defaults already cover: K (hover), grn (rename), gra (code action),
    -- grr (references), gri (implementation), gO (symbols), [d / ]d (diagnostics)
    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("gy", vim.lsp.buf.type_definition, "Go to type definition")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    -- References / implementations in Telescope (with preview) instead of the quickfix list
    map("grr", "<cmd>Telescope lsp_references<CR>", "References")
    map("gri", "<cmd>Telescope lsp_implementations<CR>", "Implementations")

    -- Pyright handles hover for Python; avoid duplicate popups from ruff
    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end

    -- Keep Vim syntax colors: molokai has no @lsp.* groups, so semantic tokens
    -- recolor code (e.g. Go's `if`/`return` lose their Conditional/Statement pink)
    vim.lsp.semantic_tokens.enable(false, { bufnr = buf })
  end,
})
