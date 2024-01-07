return {
    "echasnovski/mini.files",
    keys = {
        {
            "<leader>-", function()
                require("mini.files").open(vim.api.nvim_buf_get_name(0), false)
            end,
            desc = "Open file explorer (directory of current buffer)"
        },
        {
            "<leader>_", function()
                require("mini.files").open(vim.loop.cwd(), false)
            end,
            desc = "Open file explorer (cwd)"
        }
    },
    config = true
}
