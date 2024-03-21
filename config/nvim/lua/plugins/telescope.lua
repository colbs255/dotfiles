return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
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
        -- stylua: ignore end
    },
    opts = {
        defaults = {
            prompt_prefix = " ",
            selection_caret = " ",
        },
    },
}
