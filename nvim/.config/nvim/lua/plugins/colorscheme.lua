return {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
        -- load the colorscheme here
        vim.g.tokyonight_transparent_sidebar = true
        vim.g.tokyonight_transparent = true
        vim.opt.background = "dark"
        vim.cmd([[colorscheme tokyonight]])
    end,
}
