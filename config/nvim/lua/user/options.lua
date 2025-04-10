-- To see what an option is, run :help <cmd>. For example, :help guicursor
-- To see list of all options, :options
vim.g.mapleader = " "

vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.spelllang = "en_us"

vim.opt.errorbells = false

local function set_indentation(spaces)
    vim.opt.tabstop = spaces
    vim.opt.softtabstop = spaces
    vim.opt.shiftwidth = spaces
end

set_indentation(4)

vim.api.nvim_create_user_command("SetIndentation", function(opts)
    set_indentation(tonumber(opts.fargs[1]))
end, { nargs = 1 })
vim.opt.expandtab = true

vim.opt.wrap = false
vim.opt.smartindent = true
vim.opt.breakindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
-- Vim state recovery, less state means faster startup
vim.opt.shada = "!,'0,/0,:10,<0,@0,f0,h,s20"

vim.opt.hlsearch = true
vim.opt.incsearch = true
-- Should be set together
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- gdefault is deprecated. It messes with plugins

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Give more space for displaying messages.
vim.opt.cmdheight = 1

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")

-- Clipboard
vim.g.clipboard = {
    name = "OSC 52",
    copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
        ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
        ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
}

-- Diagnostics
vim.diagnostic.config({
    -- Only shows diagnostic for current line
    virtual_lines = { current_line = true },
})

vim.filetype.add({
    extension = {
        mdx = "markdown",
    },
})
