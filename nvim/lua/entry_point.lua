local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  use { "wbthomason/packer.nvim" }
  use { "jparise/vim-graphql" }
  use {
    "mattn/emmet-vim",
    setup = require('plugins.emmet_config').emmetSetup(),
  }
  use {
    'styled-components/vim-styled-components',
    branch = 'main'
  }
  use {
    "dracula/vim",
    as = "dracula"
  }
  use {
    'neoclide/coc.nvim',
    branch = 'master',
    run = 'yarn install --frozen-lockfile',
  }
  use { "morhetz/gruvbox" }
  use {
    "vim-airline/vim-airline",
    setup = require("plugins.airline_config").airlineSetup(),
  }
  use { "gko/vim-coloresque" }
  use { "cohama/lexima.vim" }
  use { "tpope/vim-surround" }
  use { "tpope/vim-fugitive" }
  use {
    "https://github.com/adelarsq/vim-matchit",
    setup = require('plugins.matchit_config').matchitSetup()
  }
  use { "github/copilot.vim" }
  use { "ryanoasis/vim-devicons" }
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate"
  }
  use { "kyazdani42/nvim-web-devicons" }
  use {
    "kyazdani42/nvim-tree.lua",
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
  }
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
