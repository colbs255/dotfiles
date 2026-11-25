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

local home = os.getenv("HOME")
local worktrees = home .. "/.local/share/rex/worktrees"

-- The Rex server runs with launchd's bare PATH, so put Nix's tools on it.
local function run(argv)
    local cmd = { "/usr/bin/env", "PATH=" .. home .. "/.nix-profile/bin:/usr/bin:/bin" }
    for _, arg in ipairs(argv) do
        table.insert(cmd, arg)
    end
    local r, err = rex.exec(cmd)
    if r == nil then
        error(err, 0)
    end
    if not r.ok then
        error(r.stderr, 0)
    end
    return (r.stdout:gsub("%s+$", ""))
end

-- A short kebab-case branch name for the task, falling back to a timestamp.
local function slug(prompt)
    local ok, raw = pcall(run, {
        "claude",
        "-p",
        "--model",
        "haiku",
        "Summarize the following task as a short slug: 2 to 4 lowercase words separated by hyphens, "
            .. "no punctuation, no quotes, no other text in your response.\n\nTask:\n"
            .. prompt,
    })
    local name = ok and raw:lower():gsub("[^a-z0-9]+", "-"):gsub("^-+", ""):gsub("-+$", ""):sub(1, 40) or ""
    if name == "" then
        name = "task"
    end
    return name .. "-" .. os.time() % 100000
end

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

        local prompt = rex.ui.input({
            title = "Prompt for Claude",
            placeholder = "Leave empty for a plain shell",
            confirm = "Launch",
        })
        if prompt == nil then
            return
        end

        -- An empty prompt opens the project itself; a prompt gets its own
        -- worktree and branch with Claude started on the task.
        local repo = dir:match("[^/]+$")
        local label = repo
        local options = { cwd = dir }
        if prompt:match("%S") then
            local branch = slug(prompt)
            local path = worktrees .. "/" .. repo .. "/" .. branch
            run({ "git", "-C", dir, "worktree", "add", "-b", branch, path })
            label = repo .. "/" .. branch
            options.cwd = path
            options.initial_input = "claude --dangerously-skip-permissions '" .. prompt:gsub("'", "'\\''") .. "'\r"
        end

        local session, create_err = rex.call("session.create", {
            label = label,
            initial_windows = {
                { layout = rex.layout.block({ flavor = "com.superlogical.terminal.shell", options = options }) },
            },
        })
        if session == nil then
            error(create_err, 0)
        end
        rex.client.queue("session.select", { session_id = session.session_id })
    end,
})
rex.bind("ctrl+space>d", "open_project")
