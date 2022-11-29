local Remap = require("colbs.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local nmap = Remap.nmap

nnoremap("<leader>-", ":Ex<CR>")
-- Prevents delete char from overwriting register
nnoremap("x", '"_x')
-- Prevents visual paste from overwriting register
vnoremap("p", '"_dP')
