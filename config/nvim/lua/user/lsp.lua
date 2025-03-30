vim.lsp.config.haskell = {
    cmd = { "haskell-language-server-wrapper", "--lsp" },
    root_markers = { "*.cabal" },
    filetypes = { "haskell", "lhaskell" },
}

vim.lsp.config.rust = {
    cmd = { "rust-analyzer" },
    root_markers = { "Cargo.toml" },
    filetypes = { "rust" },
}

vim.lsp.config.sh = {
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh" },
}

vim.lsp.config.typescript = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json" },
}

vim.lsp.enable({ "rust", "sh", "haskell", "typescript" })

vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_augroup,
    desc = "LSP actions",
    callback = function(event)
        -- Enable autocompletion
        -- local client = vim.lsp.get_client_by_id(event.data.client_id)
        -- if client:supports_method('textDocument/completion') then
        --     vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
        -- end

        local opts = { buffer = event.buf }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        -- K will use vim.lsp.buf.hover() by default
        vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "di", vim.diagnostic.open_float, opts)
    end,
})
