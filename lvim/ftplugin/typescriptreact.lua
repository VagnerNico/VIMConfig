local lvimLsp = require("lvim.lsp")
local status_ok, ts_utils = pcall(require, "nvim-lsp-ts-utils")

if not status_ok then
  vim.cmd [[ packadd nvim-lsp-ts-utils ]]
  ts_utils = require "nvim-lsp-ts-utils"
end

local tsserverOptions = {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
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
}

require("lvim.lsp.manager").setup("tsserver", tsserverOptions)
