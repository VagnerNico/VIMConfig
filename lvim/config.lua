-- General
vim.opt.relativenumber = true
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "dracula"
lvim.autocommands.custom_groups = {
  { "CursorHold", "*", "lua vim.diagnostic.open_float()" },
}

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = ","

-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.visual_mode["S"] = ""

-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.dashboard.active = true
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0
lvim.builtin.dap.active = true

-- if you don't want all the parsers change this to a table of the ones you want

lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- ESLint
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  {
    exe = "eslint",
    filetypes = {
      "javascriptreact",
      "javascript",
      "typescriptreact",
      "typescript",
      "vue",
    },
  },
}

local code_actions = require "lvim.lsp.null-ls.code_actions"
code_actions.setup {
  {
    exe = "eslint",
    filetypes = {
      "javascriptreact",
      "javascript",
      "typescriptreact",
      "typescript",
      "vue",
    },
  },
}

-- Additional Plugins
lvim.plugins = {
  { "tpope/vim-surround" },
  { "dracula/vim", as = "dracula" },
  { "mattn/emmet-vim" },
  { "github/copilot.vim" },
  {
    "jose-elias-alvarez/nvim-lsp-ts-utils",
    ft = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    opt = true,
    event = "BufReadPre",
    before = "williamboman/nvim-lsp-installer",
  },
}

-- Emmet configuration
vim.g.user_emmet_leader_key = ','
vim.g.user_emmet_settings = {
  javascript = {
    extends = 'jsx',
  },
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }

vim.list_extend(lvim.lsp.override, { "eslint", "tsserver" })

local servers = require("nvim-lsp-installer.servers")
local status_ok, ts_utils = pcall(require, "nvim-lsp-ts-utils")
local eslint_available, eslint_server = servers.get_server("eslint")
local tsserver_available, tsserver_server = servers.get_server("tsserver")

if not status_ok then
  vim.cmd [[ packadd nvim-lsp-ts-utils ]]
  ts_utils = require "nvim-lsp-ts-utils"
end

if eslint_available and tsserver_available then
  local lvimLsp = require("lvim.lsp")
  local eslintOptions = {
    on_attach = function(client, bufnr)
        client.resolved_capabilities.document_formatting = true
        lvimLsp.common_on_attach(client, bufnr)
    end,
    settings = {
      format = {
        enable = true,
      },
    },
    cmd_env = eslint_server:get_default_options().cmd_env,
  }
  
  local tsserverOptions = {
    on_attach = function(client, bufnr)
        client.resolved_capabilities.document_formatting = false
        ts_utils.setup {
          debug = false,
          disable_commands = false,
          enable_import_on_completion = false,
          import_all_timeout = 5000, -- ms

          -- parentheses completion
          complete_parens = false,
          signature_help_in_parens = false,

          -- update imports on file move
          update_imports_on_move = true,
          require_confirmation_on_move = false,
          watch_dir = nil,
        }
        ts_utils.setup_client(client)
        lvimLsp.common_on_attach(client, bufnr)
    end,
    init_options = ts_utils.init_options,
    on_init = lvimLsp.common_on_init,
    settings = {
      format = {
        enable = false,
      },
    },
    cmd_env = tsserver_server:get_default_options().cmd_env,
  }
  
  require("lvim.lsp.manager").setup("eslint", eslintOptions)
  require("lvim.lsp.manager").setup("tsserver", tsserverOptions)
end

--Copilot overrides
local cmp = require "cmp"
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""
lvim.builtin.cmp.mapping["<Tab>"] = function(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  else
    local copilot_keys = vim.fn["copilot#Accept"]()
    if copilot_keys ~= "" then
      vim.api.nvim_feedkeys(copilot_keys, "i", true)
    else
      fallback()
    end
  end
end
