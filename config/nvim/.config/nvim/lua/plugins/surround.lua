return {
    "echasnovski/mini.surround",
    opts = {
        -- Change default bindings so they don't conflict with flash.nvim
        mappings = {
            add = "gza", -- Add surrounding in Normal and Visual modes
            delete = "gzd", -- Delete surrounding
            find = "gzf", -- Find surrounding (to the right)
            find_left = "gzF", -- Find surrounding (to the left)
            highlight = "gzh", -- Highlight surrounding
            replace = "gzc", -- Replace surrounding
            update_n_lines = "gzn", -- Update `n_lines`
        },
    },
}
