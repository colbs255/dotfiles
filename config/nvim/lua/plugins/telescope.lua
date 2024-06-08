return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },
    keys = {
        -- stylua: ignore start
        { "<Leader><space>", function() require("telescope.builtin").git_files() end, desc = "Find git files" },
        { "<Leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files (root dir)" },
        { "<Leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help pages" },
        { "<Leader>fm", function() require("telescope.builtin").man_pages() end, desc = "Man pages" },
        { "<Leader>gb", function() require("telescope.builtin").git_branches() end, desc = "Git branches" },
        { "<Leader>/", function() require("telescope.builtin").live_grep() end, desc = "Grep (root dir)" },
        { "<Leader>,", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
        { "<Leader>:", function() require("telescope.builtin").command_history() end, desc = "Command History" },
        { "z=", function() require("telescope.builtin").spell_suggest() end, desc = "Spell suggestions" },
        -- stylua: ignore end
    },
    config = function()
        local actions = require("telescope.actions")
        local action_layout = require("telescope.actions.layout")
        require("telescope").setup({
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                layout_config = {
                    horizontal = { width = 0.95 },
                },
                path_display = {
                    "filename_first",
                },
                mappings = {
                    i = {
                        ["<esc>"] = actions.close,
                        ["<M-p>"] = action_layout.toggle_preview,
                    },
                },
            },
        })
        require("telescope").load_extension("fzf")
    end,
}
