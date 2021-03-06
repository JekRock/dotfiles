local execute = vim.api.nvim_command
local fn = vim.fn

-- returns the require for use in `config` parameter of packer's use
-- expects the name of the config file
function get_config(name)
    return string.format("require(\"config/%s\")", name)
end

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

-- bootstrap packer if not installed
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        "git", "clone", '--depth', '1', "https://github.com/wbthomason/packer.nvim",
        install_path
    })
    execute "packadd packer.nvim"
end

-- Reload neovim when plugins.lua file is saved
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end


-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- packer.reset()

local use = packer.use

-- actual plugins list
use "wbthomason/packer.nvim"
use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins

use {
    "nvim-treesitter/nvim-treesitter",
    config = get_config("treesitter"),
    run = ":TSUpdate"
}

-- LSP

use {"neovim/nvim-lspconfig", config = get_config("lsp")}                       -- enable LSP
use {"williamboman/nvim-lsp-installer", config = get_config("lsp-installer")}   -- simple to use language server installer
use "tamago324/nlsp-settings.nvim"                                              -- language server settings defined in json for
use "jose-elias-alvarez/null-ls.nvim"                                           -- for formatters and linters

use {'kyazdani42/nvim-tree.lua', requires = {                                   -- file explorer
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    }, config = get_config("nvim-tree") }

if PACKER_BOOTSTRAP then
  require("packer").sync()
end
