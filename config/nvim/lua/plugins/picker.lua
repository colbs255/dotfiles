return {
    "folke/snacks.nvim",
    keys = {
        -- stylua: ignore start
        { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
        { "<Leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
        { "<Leader>fh", function() Snacks.picker.help() end, desc = "Help pages" },
        { "<Leader>/", function() Snacks.picker.grep() end, desc = "Grep (root dir)" },
        { "<Leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<Leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "z=", function() Snacks.picker.spelling() end, desc = "Spell suggestions" },
        -- stylua: ignore end
    },
    opts = {
        picker = {
            formatters = {
                file = { filename_first = true },
            },
        },
    },
}
