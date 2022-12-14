require'nvim-treesitter.configs'.setup {
    ensure_installed = { 'java', 'python', 'bash', 'json', 'c', 'yaml' },
    sync_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    autopairs = {
		enable = true,
	},
	indent = { enable = true, disable = { "python", "css" } },
}
