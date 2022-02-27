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
    exe = "eslint_d",
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
    exe = "eslint_d",
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
}
-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }
local lsp_installer = require "nvim-lsp-installer"

function CommonOnAttach(client, bufnr)
  client.languages = {
    "javascriptreact",
    "javascript",
    "typescriptreact",
    "typescript",
    "vue",
  }
end

lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = CommonOnAttach,
  }

  if server.name == "tsserver" then
    opts.on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
    end
    opts.settings = {
      format = {
        enable = false
      }
    }
  end

  if server.name == "eslint" then
    opts.on_attach = function(client, bufnr)
      -- neovim's LSP client does not currently support dynamic capabilities registration, so we need to set
      -- the resolved capabilities of the eslint server ourselves!
      client.resolved_capabilities.document_formatting = true
      CommonOnAttach(client, bufnr)
    end
    opts.settings = {
      format = {
        enable = true
      }, -- this will enable formatting
    }
  end

  server:setup(opts)
end)
