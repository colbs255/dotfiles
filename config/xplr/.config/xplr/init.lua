---@diagnostic disable
local xplr = xplr -- The globally exposed configuration to be overridden.
version = '0.21.2'
---@diagnostic enable

-- ###########################################################################
-- ### General Configuration --------------------------------------------------
-- ###########################################################################
xplr.config.general.panel_ui.default.border_style = { fg = "Blue" }
xplr.config.node_types.directory.meta.icon = "🗀 "
xplr.config.node_types.file.meta.icon = "ƒ "
xplr.config.node_types.symlink.meta.icon = "§ "

xplr.config.node_types.extension.md = { meta = { icon = " " } }
xplr.config.node_types.extension.adoc = { meta = { icon = " " } }

-- ###########################################################################
-- ### Layouts ----------------------------------------------------------------
-- ###########################################################################
xplr.config.layouts.builtin.default = {
  Horizontal = {
    config = {
      constraints = {
        { Percentage = 70 },
        { Percentage = 30 },
      },
    },
    splits = {
      {
        Vertical = {
          config = {
            constraints = {
              { Min = 1 },
              { Length = 3 },
              { Length = 3 },
            },
          },
          splits = {
            "Table",
            "SortAndFilter",
            "InputAndLogs",
          },
        },
      },
      {
        Vertical = {
          config = {
            constraints = {
              { Percentage = 30 },
              { Percentage = 70 },
            },
          },
          splits = {
            "Selection",
            "HelpMenu",
          },
        },
      },
    },
  },
}

-- The layout without help menu
xplr.config.layouts.builtin.no_help = {
  Horizontal = {
    config = {
      constraints = {
        { Percentage = 70 },
        { Percentage = 30 },
      },
    },
    splits = {
      {
        Vertical = {
          config = {
            constraints = {
              { Length = 3 },
              { Min = 1 },
              { Length = 3 },
            },
          },
          splits = {
            "SortAndFilter",
            "Table",
            "InputAndLogs",
          },
        },
      },
      "Selection",
    },
  },
}

-- The layout without selection panel
xplr.config.layouts.builtin.no_selection = {
  Horizontal = {
    config = {
      constraints = {
        { Percentage = 70 },
        { Percentage = 30 },
      },
    },
    splits = {
      {
        Vertical = {
          config = {
            constraints = {
              { Length = 3 },
              { Min = 1 },
              { Length = 3 },
            },
          },
          splits = {
            "SortAndFilter",
            "Table",
            "InputAndLogs",
          },
        },
      },
      "HelpMenu",
    },
  },
}

-- The layout without help menu and selection panel
xplr.config.layouts.builtin.no_help_no_selection = {
  Vertical = {
    config = {
      constraints = {
        { Length = 3 },
        { Min = 1 },
        { Length = 3 },
      },
    },
    splits = {
      "SortAndFilter",
      "Table",
      "InputAndLogs",
    },
  },
}

-- ###########################################################################
-- ### File Table columns --------------------------------------------------
-- ###########################################################################
xplr.config.general.table.header.cols = {
  { format = "",            style = {} },
  { format = "╭─── path", style = {} },
  { format = "size",              style = {} },
  { format = "modified",          style = {} },
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

-- ### Required --------------------------------------------------
return {
  on_load = {},
  on_directory_change = {},
  on_focus_change = {},
  on_mode_switch = {},
  on_layout_switch = {},
}
