return {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {},
    init = function()
        -- Use mini.icons behind the scenes when a plugin asks for devicons
        package.preload["nvim-web-devicons"] = function()
            require("mini.icons").mock_nvim_web_devicons()
            return package.loaded["nvim-web-devicons"]
        end
    end,
}
