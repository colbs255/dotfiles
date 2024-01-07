return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("harpoon"):setup()
    end,
    keys = {
        { "<Leader>qj", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon file 1" },
        { "<Leader>qk", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon file 2" },
        { "<Leader>ql", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon file 3" },
        { "<Leader>qm", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon quick menu" },
        { "<Leader>qa", function() require("harpoon.mark").add_file() end, desc = "Harpoon add file" },
    },
}
