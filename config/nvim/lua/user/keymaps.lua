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
    vim.api.nvim_buf_set_name(scratch_buffer, "__scratch__")
    vim.api.nvim_set_current_buf(scratch_buffer)
end)

-- Diagnsotics ==================================
nnoremap("gl", vim.diagnostic.open_float)
nnoremap("[d", vim.diagnostic.goto_prev)
nnoremap("]d", vim.diagnostic.goto_next)

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

local function toggleDiagnostics()
    if vim.diagnostic.is_disabled() then
        vim.diagnostic.enable()
    else
        vim.diagnostic.disable()
    end
end

nnoremap("<leader>us", function() toggleOption("spell") end, { desc = "Toggle spelling" })
nnoremap("<leader>uw", function() toggleOption("wrap") end, { desc = "Toggle word wrap" })
nnoremap("<leader>ul", function() toggleNumber() end, { desc = "Toggle line numbers" })
nnoremap("<leader>uL", function() toggleOption("relativenumber") end, { desc = "Toggle relative line numbers" })
nnoremap("<leader>ur", "<CMD>nohlsearch<CR>", { desc = "Turn off search highlight (nohlsearch)" })
nnoremap("<leader>ud", function() toggleDiagnostics() end, { desc = "Toggle diagnostics" })
