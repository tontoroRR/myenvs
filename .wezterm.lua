local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local app_path = 'D:\\Users\\masaaki\\scoop\\apps\\wezterm\\current\\'

local grey_radial = {
  colors = { 'grey', 'slategrey' },
  orientation = {
    Radial = {cx=0.65, cy=0.65, radius=0.45}
  }
}
local dim_and_bw = {brightness = 0.03, hue = 1, saturation = 0.7}

config = {
  default_prog = {'pwsh.exe'},
  window_decorations = 'RESIZE',

  color_scheme = 'Solarized Darcula (Gogh)',

  -- font = wezterm.font('HackGen35 Console NF') ,
  font = wezterm.font('Maple Mono NF'),
  font_size = 10.5,
  line_height = 0.9,

  foreground_text_hsb = { brightness = 1.2, saturation = 1.0 },
  background = {
    {
      source = {
        File = app_path .. 'Spring_post.png',
      },
      attachment = { Parallax = 0.05 }, --"Fixed",
      hsb = dim_and_bw,
      height = 1020,
      width = 650,
    },
    {
      source = {
        File = app_path .. 'Spring_post.png',
      },
      attachment = { Parallax = 0.3 }, --"Fixed",
      hsb = dim_and_bw,
      height = 620,
      width = 325,
      opacity = 0.5
    },
  },
}

return config
