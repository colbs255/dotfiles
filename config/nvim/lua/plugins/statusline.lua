local file_info = function(args)
    local filetype = vim.bo.filetype

    -- Don't show anything if no filetype or not inside a "normal buffer"
    if filetype == '' or vim.bo.buftype ~= '' then return '' end

    -- Construct output string if truncated
    if MiniStatusline.is_truncated(args.trunc_width) then return filetype end

    -- Construct output string with extra file info
    local encoding = vim.bo.fileencoding or vim.bo.encoding
    return string.format('%s   %s', filetype, encoding)
end

local content_active = function()
    local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
    local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
    local fileinfo      = file_info({ trunc_width = 120 })
    local location      = MiniStatusline.section_location({ trunc_width = 75 })

    -- Usage of `MiniStatusline.combine_groups()` ensures highlighting and
    -- correct padding with spaces between groups (accounts for 'missing'
    -- sections, etc.)
    return MiniStatusline.combine_groups({
        { hl = mode_hl,                  strings = { mode } },
        '%<', -- Mark general truncate point
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=', -- End left alignment
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
        { hl = mode_hl,                  strings = { location } },
    })
end

return {
    'echasnovski/mini.statusline',
    event = "VeryLazy",
    config = function()
        require('mini.statusline').setup({
            content = {
                active = content_active
            },
            -- set_vim_settings = true,
        })
    end,
}
