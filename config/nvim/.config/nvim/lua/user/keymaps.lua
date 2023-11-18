-- Makes vim mapping more convenient in lua configs
local function bind(op, outer_opts)
    outer_opts = outer_opts or { noremap = true }
    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force", outer_opts, opts or {})
        vim.keymap.set(op, lhs, rhs, opts)
    end
end

local nnoremap = bind("n")
local vnoremap = bind("v")
local xnoremap = bind("x")
local inoremap = bind("i")

-- General =======================================
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

-- Searches all files inside the git repo, respecting the gitignore
nnoremap("<Leader><space>", function() require("telescope.builtin").git_files() end)

-- Searches all files starting from your current working directory, respecting the gitignore
nnoremap("<Leader>ff", function() require("telescope.builtin").find_files() end)
nnoremap("<Leader>fh", function() require("telescope.builtin").help_tags() end)
nnoremap("<Leader>fm", function() require("telescope.builtin").man_pages() end)
nnoremap("<Leader>gb", function() require("telescope.builtin").git_branches() end)
nnoremap("<Leader>/", function() require("telescope.builtin").live_grep() end)
nnoremap("<Leader>,", function() require("telescope.builtin").buffers() end)
nnoremap("<Leader>:", function() require("telescope.builtin").command_history() end)

-- Harpoon =======================================
nnoremap("<Leader>qj", function() require("harpoon.ui").nav_file(1) end)
nnoremap("<Leader>qk", function() require("harpoon.ui").nav_file(2) end)
nnoremap("<Leader>ql", function() require("harpoon.ui").nav_file(3) end)
nnoremap("<Leader>qm", function() require("harpoon.ui").toggle_quick_menu() end)
nnoremap("<Leader>qa", function() require("harpoon.mark").add_file() end)

-- UI =======================================
local function toggleOption(option)
    vim.opt_local[option] = not vim.opt_local[option]:get()
end

local function toggleNumber()
    if vim.opt_local.number:get() or vim.opt_local.relativenumber:get() then
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    else
        vim.opt_local.number = true
        vim.opt_local.relativenumber = true
    end
end

nnoremap("<leader>us", function() toggleOption("spell") end, { desc = "Toggle Spelling" })
nnoremap("<leader>uw", function() toggleOption("wrap") end, { desc = "Toggle Word Wrap" })
nnoremap("<leader>ul", function() toggleNumber() end, { desc = "Toggle Line Numbers" })
nnoremap("<leader>uL", function() toggleOption("relativenumber") end, { desc = "Toggle Relative Line Numbers" })
