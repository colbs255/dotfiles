local function augroup(name)
end

local lsp_augroup = vim.api.nvim_create_augroup("user_lsp", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "haskell",
    group = lsp_augroup,
    callback = function()
        local client = vim.lsp.start({
            cmd = { 'haskell-language-server-wrapper', '--lsp' },
            filetypes = { 'haskell', 'lhaskell' },
            root_dir = vim.fs.dirname(vim.fs.find({'hie.yaml', 'stack.yaml', 'cabal.project', '*.cabal', 'package.yaml'}, { upward = true })[1]),
            single_file_support = true,
        })
        vim.lsp.buf_attach_client(0, client)
    end,
})
