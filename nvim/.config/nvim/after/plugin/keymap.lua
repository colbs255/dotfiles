local Remap = require("keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local nmap = Remap.nmap

-- General =======================================
nnoremap("<leader>-", ":Ex<CR>")
-- Prevents delete char from overwriting register
nnoremap("x", '"_x')
-- Prevents visual paste from overwriting register
vnoremap("p", '"_dP')

-- Shortcuts =====================================
nnoremap("<leader>oq", ":e ~/quick.md<CR>")

-- Telescope =====================================
nnoremap("<C-p>", function()
    require('telescope.builtin').git_files()
end)

nnoremap("<Leader>ff", function()
    require('telescope.builtin').find_files()
end)

nnoremap("<Leader>fg", function()
    require('telescope.builtin').live_grep()
end)

nnoremap("<Leader>fb", function()
    require('telescope.builtin').buffers()
end)

nnoremap("<Leader>fh", function()
    require('telescope.builtin').help_tags()
end)

-- Neogit ========================================
nnoremap("<Leader>gs", function()
    require('neogit').open()
end)
