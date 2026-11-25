rex.bind("ctrl+space>ctrl+space", "pane.send_key", { key = "ctrl+space" })
rex.bind("ctrl+space>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+space>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+space>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+space>l", "pane.focus", { direction = "right" })
rex.bind("ctrl+space>x", "pane.close")

rex.bind("ctrl+space>.", "client.tab.next")
rex.bind("ctrl+space>,", "client.tab.previous")
rex.bind("ctrl+space>s", "session.switch")

rex.bind("ctrl+space>v", "pane.split", { direction = "right" })
rex.bind("ctrl+space>-", "pane.split", { direction = "down" })
rex.bind("ctrl+space>z", "pane.zoom")
rex.bind("ctrl+space>shift+h", "pane.move", { direction = "left" })
rex.bind("ctrl+space>shift+j", "pane.move", { direction = "down" })
rex.bind("ctrl+space>shift+k", "pane.move", { direction = "up" })
rex.bind("ctrl+space>shift+l", "pane.move", { direction = "right" })
rex.bind("ctrl+space>tab", "pane.focus_next")
rex.bind("ctrl+space>shift+tab", "pane.focus_previous")
rex.bind("ctrl+space>shift+p", "pane.rename")
rex.bind("ctrl+space>[", "pane.copy_mode.enter")
rex.bind("ctrl+space>b", "client.sidebar.toggle")
rex.bind("ctrl+space>c", "client.tab.new")
rex.bind("ctrl+space>shift+x", "client.tab.close")
rex.bind("ctrl+space>shift+t", "client.tab.rename")
for i = 1, 9 do
    rex.bind("ctrl+space>" .. i, "client.tab.goto", { index = i })
end
rex.bind("ctrl+space>shift+n", "session.new")
rex.bind("ctrl+space>shift+w", "session.rename")
rex.bind("ctrl+space>shift+d", "session.close")
rex.bind("ctrl+space>w", "session.switch")
rex.bind("ctrl+space>shift+r", "client.config.reload")

rex.action({
    name = "open_project",
    title = "Open Project…",
    run = function()
        local root = os.getenv("HOME") .. "/projects"
        local r, err =
            rex.exec({ "find", root, "-mindepth", "1", "-maxdepth", "1", "-type", "d", "-not", "-name", ".*" })
        if r == nil then
            error(err, 0)
        end
        if not r.ok then
            error(r.stderr, 0)
        end

        local items = {}
        for dir in r.stdout:gmatch("[^\n]+") do
            local name = dir:match("[^/]+$")
            table.insert(items, { id = dir, title = name, subtitle = "~/projects/" .. name, icon = "folder" })
        end
        table.sort(items, function(a, b)
            return a.title:lower() < b.title:lower()
        end)

        local dir = rex.ui.pick({ title = "Open project", placeholder = "Filter projects", items = items })
        if dir == nil then
            return
        end

        local session, create_err = rex.call("session.create", {
            label = dir:match("[^/]+$"),
            initial_windows = {
                { layout = rex.layout.block({ flavor = "com.superlogical.terminal.shell", options = { cwd = dir } }) },
            },
        })
        if session == nil then
            error(create_err, 0)
        end
        rex.client.queue("session.select", { session_id = session.session_id })
    end,
})
rex.bind("ctrl+space>d", "open_project")
