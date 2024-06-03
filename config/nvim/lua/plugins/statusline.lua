local M = {}

M.section_percentage = function()
    local cur = vim.fn.line(".")
    local total = vim.fn.line("$")
    if cur == 1 then
        return "Top"
    elseif cur == total then
        return "Bot"
    end
    return string.format("%2d%%%%", math.floor(cur / total * 100))
end

M.section_location = function(args)
    -- Use virtual column number to allow update when past last column
    if MiniStatusline.is_truncated(args.trunc_width) then
        return "%l"
    end
    return "%3l:%-2v"
end

M.section_file_info = function(args)
    local filetype = vim.bo.filetype

    -- Don't show anything if no filetype or not inside a "normal buffer"
    if filetype == "" or vim.bo.buftype ~= "" then
        return ""
    end

    -- Construct output string if truncated
    if MiniStatusline.is_truncated(args.trunc_width) then
        return filetype
    end

    -- Construct output string with extra file info
    local encoding = vim.bo.fileencoding or vim.bo.encoding
    return string.format("%s   %s", filetype, encoding)
end

M.content_active = function()
    local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
    local filename = MiniStatusline.section_filename({ trunc_width = 140 })
    local fileinfo = M.section_file_info({ trunc_width = 120 })
    local location_percentage = M.section_percentage()
    local location = M.section_location({ trunc_width = 75 })

    -- Usage of `MiniStatusline.combine_groups()` ensures highlighting and
    -- correct padding with spaces between groups (accounts for 'missing'
    -- sections, etc.)
    return MiniStatusline.combine_groups({
        { hl = mode_hl, strings = { mode } },
        "%<", -- Mark general truncate point
        { hl = "MiniStatuslineFileinfo", strings = { filename } },
        "%=", -- End left alignment
        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
        { hl = "MiniStatuslineFilename", strings = { location_percentage } },
        { hl = mode_hl, strings = { location } },
    })
end

return {
    "echasnovski/mini.statusline",
    event = "VeryLazy",
    config = function()
        require("mini.statusline").setup({
            content = {
                active = M.content_active,
            },
            set_vim_settings = true,
        })
    end,
}
