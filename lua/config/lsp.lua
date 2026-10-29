-- Server definitions come from nvim-lspconfig; mason installs the binaries
-- and mason-lspconfig calls vim.lsp.enable() for each installed server.

-- Advertise blink.cmp's completion capabilities to every server
vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
      usePlaceholders = true,
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

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = { border = "rounded" },
})

local format_on_save = { go = true, python = true }

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
    map("<leader>rn", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format")

    -- Pyright handles hover for Python; avoid duplicate popups from ruff
    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end

    if format_on_save[vim.bo[buf].filetype] and client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = buf,
        group = vim.api.nvim_create_augroup("lsp_format_" .. buf .. "_" .. client.id, { clear = true }),
        callback = function()
          -- Go: format with gopls; Python: format with ruff only
          local name = vim.bo[buf].filetype == "python" and "ruff" or client.name
          vim.lsp.buf.format({ bufnr = buf, name = name, timeout_ms = 2000 })
        end,
      })
    end
  end,
})
