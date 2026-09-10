local ensure_installed = {
    "java",
    "python",
    "bash",
    "json",
    "c",
    "yaml",
    "rust",
    "lua",
    "haskell",
    "markdown",
    "markdown_inline",
}

-- Filetypes to skip treesitter-based indent for (the built-in indenter is better here).
local indent_disabled = { python = true, css = true }

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    -- Upstream: "This plugin does not support lazy-loading."
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").install(ensure_installed)

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                if args.match == "help" then
                    return
                end

                local ok = pcall(vim.treesitter.start)
                if not ok then
                    return
                end

                vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                vim.wo[0][0].foldmethod = "expr"
                vim.wo[0][0].foldlevel = 999999 -- Leave unfolded by default.

                if not indent_disabled[args.match] then
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}
