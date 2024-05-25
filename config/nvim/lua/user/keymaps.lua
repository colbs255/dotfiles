local function set_keymap(mode, lhs, rhs, description)
    opts = { noremap = true, silent = true, desc = description }
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- stylua: ignore start
set_keymap("n", "x", '"_x', "Prevent delete char from overwriting register")
set_keymap("v", "p", '"_dP', "Prevents visual paste from overwriting register")

set_keymap("n", "<C-d>", "<C-d>zz", "Scroll down and center cursor")
set_keymap("n", "<C-u>", "<C-u>zz", "Scroll up and center cursor")

set_keymap("v", "<", "<gv", "Indent left and stay in indent mode")
set_keymap("v", ">", ">gv", "Indent right and stay in indent mode")

set_keymap("n", "<leader>oq", ":e ~/quick.md<CR>", "Go to quick links file")
set_keymap("n", "<leader>os",
    function()
        local scratch_buffer = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_buf_set_name(scratch_buffer, "__scratch__")
        vim.api.nvim_set_current_buf(scratch_buffer)
    end,
    "Open scratch buffer"
)
-- stylua: ignore end

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

-- stylua: ignore start
set_keymap("n", "<leader>us", function() toggleOption("spell") end, "Toggle spelling")
set_keymap("n", "<leader>uw", function() toggleOption("wrap") end, "Toggle word wrap")
set_keymap("n", "<leader>ul", function() toggleNumber() end, "Toggle line numbers")
set_keymap("n", "<leader>uL", function() toggleOption("relativenumber") end, "Toggle relative line numbers")
set_keymap("n", "<leader>ur", "<CMD>nohlsearch<CR>", "Turn off search highlight (nohlsearch)")
set_keymap("n", "<leader>ud", function() toggleDiagnostics() end, "Toggle diagnostics")
-- stylua: ignore end
