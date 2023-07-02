---@diagnostic disable
local xplr = xplr -- The globally exposed configuration to be overridden.
version = '0.21.2'
---@diagnostic enable

-- ###########################################################################
-- ### General Configuration --------------------------------------------------
-- ###########################################################################
local home = os.getenv("HOME")
package.path = home
    .. "/.config/xplr/plugins/?/init.lua;"
    .. home
    .. "/.config/xplr/plugins/?.lua;"
    .. package.path
require("icons").setup()
require("file-table").setup()
require("zoxide").setup()

xplr.config.general.panel_ui.default.border_style = { fg = "Blue" }
xplr.config.general.show_hidden = true

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

-- ### Required --------------------------------------------------
return {
    on_load = {},
    on_directory_change = {},
    on_focus_change = {},
    on_mode_switch = {},
    on_layout_switch = {},
}
