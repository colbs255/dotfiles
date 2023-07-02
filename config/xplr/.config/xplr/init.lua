---@diagnostic disable
local xplr = xplr -- The globally exposed configuration to be overridden.
version = '0.21.2'
---@diagnostic enable

local home = os.getenv("HOME")
package.path = home
    .. "/.config/xplr/plugins/?/init.lua;"
    .. home
    .. "/.config/xplr/plugins/?.lua;"
    .. home
    .. "/.config/xplr/user/?.lua;"
    .. package.path

require("settings").setup()
require("icons").setup()
require("file-table").setup()
require("zoxide").setup()
require("layouts").setup()

-- ### Required --------------------------------------------------
return {
    on_load = {},
    on_directory_change = {},
    on_focus_change = {},
    on_mode_switch = {},
    on_layout_switch = {},
}
