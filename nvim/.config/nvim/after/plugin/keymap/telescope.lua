local Remap = require("colbs.keymap")
local nnoremap = Remap.nnoremap

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
