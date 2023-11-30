return {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "java", "python", "bash", "json", "c", "yaml", "rust", "lua", "haskell" },
            -- Only sync_install if running headless.
            -- From: https://github.com/nvim-treesitter/nvim-treesitter/issues/3579#issuecomment-1278662119
            sync_install = #vim.api.nvim_list_uis() == 0,

            highlight = {
                enable = true,
                disable = { "help" },
            },
            autopairs = { enable = true },
            indent = { enable = true, disable = { "python", "css" } },
        })

        -- Override default folding options.
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        vim.opt.foldlevel = 999999 -- Leave unfolded by default.
        vim.opt.foldmethod = "expr"
    end,
    build = ":TSUpdate",
}
