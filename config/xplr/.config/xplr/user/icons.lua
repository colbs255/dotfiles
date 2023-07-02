local xplr = xplr

local function black(x) return "\x1b[30m" .. x .. "\x1b[0m" end
local function red(x) return "\x1b[31m" .. x .. "\x1b[0m" end
local function green(x) return "\x1b[32m" .. x .. "\x1b[0m" end
local function yellow(x) return "\x1b[33m" .. x .. "\x1b[0m" end
local function blue(x) return "\x1b[34m" .. x .. "\x1b[0m" end
local function magenta(x) return "\x1b[35m" .. x .. "\x1b[0m" end
local function cyan(x) return "\x1b[36m" .. x .. "\x1b[0m" end
local function white(x) return "\x1b[37m" .. x .. "\x1b[0m" end

local function setup()
    xplr.config.node_types.mime_essence = {
        audio = {
            ["*"] = { meta = { icon = yellow " " } },
        },
        video = {
            ["*"] = { meta = { icon = "ﳜ " } },
        },
        image = {
            ["*"] = { meta = { icon = " " } },
        },
        application = {
            -- application/zip
            zip = { meta = { icon = " " } },
        },
        text = {
            ["*"] = { meta = { icon = " " } },
        },
    }

    xplr.config.node_types.directory.meta.icon = blue "🗀 "
    xplr.config.node_types.file.meta.icon = cyan " "
    xplr.config.node_types.symlink.meta.icon = magenta " "

    xplr.config.node_types.extension.md = { meta = { icon = " " } }
    xplr.config.node_types.extension.adoc = { meta = { icon = " " } }
    xplr.config.node_types.extension.lua = { meta = { icon = blue " " } }
end

return { setup = setup }
