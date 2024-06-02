return {
    "echasnovski/mini.diff",
    event = "VeryLazy",
    keys = {
        {
            "<leader>ghp",
            function()
                require("mini.diff").toggle_overlay()
            end,
        },
    },
    config = function()
        require("mini.diff").setup({
            view = {
                style = "sign",
                signs = {
                    add = "▎",
                    change = "▎",
                    delete = "",
                },
            },
        })
    end,
}
