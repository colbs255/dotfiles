---@diagnostic disable
local xplr = xplr -- The globally exposed configuration to be overridden.
version = '0.21.2'
---@diagnostic enable

-- ### General Configuration --------------------------------------------------

xplr.config.general.panel_ui.default.border_style = { fg = "Blue" }
xplr.config.node_types.directory.meta.icon = "d"
xplr.config.node_types.file.meta.icon = "ƒ"
xplr.config.node_types.symlink.meta.icon = "§"

-- xplr.config.node_types.extension.md = { meta = { icon = "" }, style = { fg = "Blue" } }
-- xplr.config.node_types.extension.rs = { meta = { icon = "🦀" } }
xplr.config.node_types.extension = {}

xplr.config.general.table.header.cols = {
  { format = "",            style = {} },
  { format = "╭─── path", style = {} },
  { format = "perm",              style = {} },
  { format = "size",              style = {} },
  { format = "modified",          style = {} },
}

xplr.config.general.table.col_widths = {
  { Percentage = 10 },
  { Percentage = 50 },
  { Percentage = 10 },
  { Percentage = 10 },
  { Percentage = 20 },
}


-- ### Layouts ----------------------------------------------------------------
--
-- xplr layouts define the structure of the UI, i.e. how many panel we see,
-- placement and size of the panels, how they look etc.
--
-- This is configuration exposed via the `xplr.config.layouts` API.
--
-- `xplr.config.layouts.builtin` contain some built-in panels which can be
-- overridden, but you can't add or remove panels in it.
--
-- You can add new panels in `xplr.config.layouts.custom`.
--
-- ##### Example: Defining Custom Layout
--
-- ![demo](https://s6.gifyu.com/images/layout.png)
--
-- ```lua
-- xplr.config.layouts.builtin.default = {
--   Horizontal = {
--     config = {
--       margin = 1,
--       horizontal_margin = 2,
--       vertical_margin = 3,
--       constraints = {
--         { Percentage = 50 },
--         { Percentage = 50 },
--       }
--     },
--     splits = {
--       "Table",
--       "HelpMenu",
--     }
--   }
-- }
-- ```

-- The default layout
--
-- Type: [Layout](https://xplr.dev/en/layout)
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
--
-- Type: [Layout](https://xplr.dev/en/layout)
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
--
-- Type: [Layout](https://xplr.dev/en/layout)
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
--
-- Type: [Layout](https://xplr.dev/en/layout)
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

-- ### Table columns --------------------------------------------------
-- Renders the first column in the table
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

-- Renders the second column in the table
xplr.fn.builtin.fmt_general_table_row_cols_1 = function(m)
  local nl = xplr.util.paint("\\n", { add_modifiers = { "Italic", "Dim" } })
  local r = m.tree .. m.prefix
  local style = xplr.util.lscolor(m.absolute_path)
  style = xplr.util.style_mix({ style, m.style })

  if m.meta.icon == nil then
    r = r .. ""
  else
    r = r .. m.meta.icon .. " "
  end

  local rel = m.relative_path
  if m.is_dir then
    rel = rel .. "/"
  end
  r = r .. xplr.util.paint(xplr.util.shell_escape(rel), style)

  r = r .. m.suffix .. " "

  if m.is_symlink then
    r = r .. "-> "

    if m.is_broken then
      r = r .. "×"
    else
      local symlink_path = xplr.util.shorten(m.symlink.absolute_path)
      if m.symlink.is_dir then
        symlink_path = symlink_path .. "/"
      end
      r = r .. symlink_path:gsub("\n", nl)
    end
  end

  return r
end

-- Renders the third column in the table
xplr.fn.builtin.fmt_general_table_row_cols_2 = function(m)
  local r = xplr.util.paint("r", { fg = "Green" })
  local w = xplr.util.paint("w", { fg = "Yellow" })
  local x = xplr.util.paint("x", { fg = "Red" })
  local s = xplr.util.paint("s", { fg = "Red" })
  local S = xplr.util.paint("S", { fg = "Red" })
  local t = xplr.util.paint("t", { fg = "Red" })
  local T = xplr.util.paint("T", { fg = "Red" })

  return xplr.util
      .permissions_rwx(m.permissions)
      :gsub("r", r)
      :gsub("w", w)
      :gsub("x", x)
      :gsub("s", s)
      :gsub("S", S)
      :gsub("t", t)
      :gsub("T", T)
end

-- Renders the fourth column in the table
xplr.fn.builtin.fmt_general_table_row_cols_3 = function(m)
  if not m.is_dir then
    return m.human_size
  else
    return ""
  end
end

-- Renders the fifth column in the table
xplr.fn.builtin.fmt_general_table_row_cols_4 = function(m)
  return tostring(os.date("%a %b %d %H:%M:%S %Y", m.last_modified / 1000000000))
end

-- This is where the custom functions can be added.
--
-- There is currently no restriction on what kind of functions can be defined
-- in `xplr.fn.custom`.
--
-- You can also use nested tables such as
-- `xplr.fn.custom.my_plugin.my_function` to define custom functions.
xplr.fn.custom = {}

return {
  on_load = {},
  on_directory_change = {},
  on_focus_change = {},
  on_mode_switch = {},
  on_layout_switch = {},
}
