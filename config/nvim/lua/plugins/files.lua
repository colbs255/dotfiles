local set_split_mapping = function(buf_id, lhs, direction)
    local rhs = function()
        -- Make new window and set it as target
        local new_target_window
        vim.api.nvim_win_call(MiniFiles.get_target_window(), function()
            vim.cmd(direction .. " split")
            new_target_window = vim.api.nvim_get_current_win()
        end)

        MiniFiles.set_target_window(new_target_window)
    end

    -- Adding `desc` will result into `show_help` entries
    local desc = "Split " .. direction
    vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

local mini_files_set_cwd = function(path)
    -- Works only if cursor is on the valid file system entry
    local cur_entry_path = MiniFiles.get_fs_entry().path
    local cur_directory = vim.fs.dirname(cur_entry_path)
    vim.fn.chdir(cur_directory)
end

return {
    "echasnovski/mini.files",
    keys = {
        {
            "<leader>-",
            function()
                require("mini.files").open(vim.api.nvim_buf_get_name(0), false)
            end,
            desc = "Open file explorer (directory of current buffer)",
        },
        {
            "<leader>_",
            function()
                require("mini.files").open(vim.loop.cwd(), false)
            end,
            desc = "Open file explorer (cwd)",
        },
    },
    config = function(opts)
        require("mini.files").setup()
        vim.api.nvim_create_autocmd("User", {
            pattern = "MiniFilesBufferCreate",
            callback = function(args)
                local buf_id = args.data.buf_id
                set_split_mapping(buf_id, "gs", "belowright horizontal")
                set_split_mapping(buf_id, "gv", "belowright vertical")
            end,
        })
        vim.api.nvim_create_autocmd("User", {
            pattern = "MiniFilesBufferCreate",
            callback = function(args)
                vim.keymap.set("n", "g~", mini_files_set_cwd, { buffer = args.data.buf_id })
            end,
        })
    end,
}
