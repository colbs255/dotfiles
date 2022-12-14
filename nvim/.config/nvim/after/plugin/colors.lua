vim.g.tokyonight_transparent_sidebar = true
vim.g.tokyonight_transparent = true
-- Dark by default, but just to make it explicit
vim.opt.background = "dark"

local colorscheme = "tokyonight"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
    vim.notify("Unable to load colorscheme: " .. colorscheme, vim.log.levels.WARN)
  return
end
