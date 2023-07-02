local function setup()
    local xplr = xplr
    xplr.config.modes.builtin["default"].key_bindings.on_key["z"] = {
        help = "zoxide jump",
        messages = {
            {
                BashExec = [===[
              PTH="$(zoxide query -i)"
              if [ -d "$PTH" ]; then
                "$XPLR" -m "ChangeDirectory: %q" "${PTH:?}"
              fi
            ]===],
            },
            "PopMode",
        },
    }
end

return { setup = setup }

