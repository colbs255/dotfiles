local function setup()
    local xplr = xplr
    xplr.config.general.table.header.cols = {
        { format = "",            style = {} },
        { format = "╭─── Path", style = {} },
        { format = "Size",              style = {} },
        { format = "Modified",          style = {} },
        { format = "",              style = {} },
    }

    xplr.config.general.table.col_widths = {
        { Percentage = 10 },
        { Percentage = 60 },
        { Percentage = 10 },
        { Percentage = 20 },
        { Percentage = 0 },
    }

    -- Index
    xplr.fn.builtin.fmt_general_table_row_cols_0 = function(m)
        local r = ""
        if m.is_before_focus then
            r = r .. " -"
        else
            r = r .. "  "
        end

        r = r .. m.relative_index .. "│" .. m.index

        return r
    end

    -- Size
    xplr.fn.builtin.fmt_general_table_row_cols_2 = function(m)
        if not m.is_dir then
            return m.human_size
        else
            return ""
        end
    end

    -- Time
    xplr.fn.builtin.fmt_general_table_row_cols_3 = function(m)
        return tostring(os.date("%b %d, %H:%M:%S %Y", m.last_modified / 1000000000))
    end

    -- Perms
    xplr.fn.builtin.fmt_general_table_row_cols_4 = function(m)
        return ""
    end
end

return { setup = setup }
