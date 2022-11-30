-- Update with :PackerSync
-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- The necessities
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ":TSUpdate" -- may error when installing, but works after
    }
    use 'tpope/vim-surround'
    use {
        'TimUntersberger/neogit',
        requires = 'nvim-lua/plenary.nvim'
    }

    -- Colorscheme
    use 'folke/tokyonight.nvim'
end)
