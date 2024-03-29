return {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    opts = {
        delay = 200,
        large_file_cutoff = 2000,
        large_file_overrides = {
            providers = { "lsp" },
        },
        filetypes_denylist = { "netrw" },
    },
    config = function(_, opts)
        require("illuminate").configure(opts)
    end,
}
