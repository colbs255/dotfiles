local lsp_augroup = vim.api.nvim_create_augroup("user_lsp", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "haskell",
    group = lsp_augroup,
    callback = function()
        local client = vim.lsp.start({
            cmd = { "haskell-language-server-wrapper", "--lsp" },
            filetypes = { "haskell", "lhaskell" },
            root_dir = vim.fs.dirname(
                vim.fs.find({ "hie.yaml", "stack.yaml", "cabal.project", "*.cabal", "package.yaml" }, { upward = true })[1]
            ),
            single_file_support = true,
        })
        vim.lsp.buf_attach_client(0, client)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    group = lsp_augroup,
    callback = function()
        local client = vim.lsp.start({
            cmd = { "rust-analyzer" },
            filetypes = { "rust" },
            root_dir = vim.fs.dirname(
                vim.fs.find({ "Cargo.toml" }, { upward = true })[1]
            ),
            single_file_support = true,
        })
        vim.lsp.buf_attach_client(0, client)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "sh",
    group = lsp_augroup,
    callback = function()
        local client = vim.lsp.start({
            cmd = { "bash-language-server", "start" },
            settings = {
                bashIde = {
                    globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
                },
            },
            filetypes = { "sh" },
            single_file_support = true,
        })
        vim.lsp.buf_attach_client(0, client)
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_augroup,
    desc = "LSP actions",
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
        -- K will use vim.lsp.buf.hover() by default
        vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>cs", vim.lsp.buf.workspace_symbol, opts)
    end,
})
