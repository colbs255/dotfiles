-- Makes vim mapping more convenient in lua configs
local function bind(op, outer_opts)
    outer_opts = outer_opts or {noremap = true}
    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force",
            outer_opts,
            opts or {}
        )
        vim.keymap.set(op, lhs, rhs, opts)
    end
end

local nmap = bind("n", {noremap = false})
local nnoremap = bind("n")
local vnoremap = bind("v")
local xnoremap = bind("x")
local inoremap = bind("i")

-- TOOD: Use keymap?
-- local keymap = vim.api.nvim_set_keymap

-- General =======================================
nnoremap("<leader>-", ":Ex<CR>")
-- Prevents delete char from overwriting register
nnoremap("x", '"_x')
-- Prevents visual paste from overwriting register
vnoremap("p", '"_dP')
-- Centers the cursor when scrolling
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")

-- Stay in indent mode
vnoremap("<", "<gv")
vnoremap(">", ">gv")
-- Buffers =====================================
nnoremap("<leader>bs", ":update<CR>")
nnoremap("<leader>br", ":%s///g<left><left><left>")

-- Shortcuts =====================================
nnoremap("<leader>oq", ":e ~/quick.md<CR>")
nnoremap("<leader>os", function()
    local scratch_buffer = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_name(scratch_buffer, "__scratch__.md")
    vim.api.nvim_set_current_buf(scratch_buffer)
end)

-- Telescope =====================================
nnoremap("<Leader><space>", function()
    require('telescope.builtin').git_files()
end)

nnoremap("<Leader>ff", function()
    require('telescope.builtin').find_files()
end)

nnoremap("<Leader>fh", function()
    require('telescope.builtin').help_tags()
end)

nnoremap("<Leader>gb", function()
    require('telescope.builtin').git_branches()
end)

nnoremap("<Leader>/", function()
    require('telescope.builtin').live_grep()
end)

nnoremap("<Leader>,", function()
    require('telescope.builtin').buffers()
end)

nnoremap("<Leader>:", function()
    require('telescope.builtin').command_history()
end)

-- Harpoon =======================================
nnoremap("<Leader>qj", function()
    require("harpoon.ui").nav_file(1)
end)
nnoremap("<Leader>qk", function()
    require("harpoon.ui").nav_file(2)
end)
nnoremap("<Leader>ql", function()
    require("harpoon.ui").nav_file(3)
end)
nnoremap("<Leader>qm", function()
    require("harpoon.ui").toggle_quick_menu()
end)
nnoremap("<Leader>qa", function()
    require("harpoon.mark").add_file()
end)
