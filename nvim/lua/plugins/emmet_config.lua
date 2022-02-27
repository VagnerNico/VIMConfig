local config = {}
--Remap Emmet shortcut
function config.emmetSetup()
  vim.g.user_emmet_leader_key = ','
  vim.g.user_emmet_settings = {
    javascript = {
      extends = 'jsx',
    },
  }
end

return config
