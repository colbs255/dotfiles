local xplr = xplr

local function setup()
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
end

return { setup = setup }
