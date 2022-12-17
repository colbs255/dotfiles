-- Update with :PackerSync

-- bootstraps packer
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        -- Only required if you have packer configured as `opt`
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local bootstrapping_packer = ensure_packer()

return require('packer').startup(function(use)
    -- The necessities
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'

    -- Useful
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
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }
    use {
        "ThePrimeagen/refactoring.nvim",
        requires = {
            {"nvim-lua/plenary.nvim"},
            {"nvim-treesitter/nvim-treesitter"}
        }
    }
    use {
        "ThePrimeagen/harpoon"
    }

    -- Colorscheme
    use 'folke/tokyonight.nvim'

    -- Experimental
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Must be after all plugins
    if bootstrapping_packer then
        require('packer').sync()
    end
end)
