hl.on("hyprland.start", function()
  hl.exec_cmd("noctalia")
end)

hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 10,
  },

  decoration = {
    rounding = 20,
    rounding_power = 2,

    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = 0xee1a1a1a,
    },

    blur = {
      enabled = true,
      xray = true,
      size = 3,
      passes = 2,
      vibrancy = 0.1696,
    },
  },
})

local mainMod = "SUPER"
local ipc = "noctalia msg "

-- Core binds
hl.bind(mainMod .. "+Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind(mainMod .. "+S", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
hl.bind(mainMod .. "+comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
hl.bind("ALT + Tab", hl.dsp.exec_cmd(ipc .. "window-switcher hold"))
hl.bind("ALT + SHIFT + Tab", hl.dsp.exec_cmd(ipc .. "window-switcher hold reverse"))

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"))

-- Noctalia Settings
hl.window_rule({
  match = { class = "dev.noctalia.Noctalia" },
  float = true,
  size = { 1080, 920 },
})

hl.layer_rule({
  name = "noctalia-no-anim",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
  },
  no_anim = true,
})

hl.layer_rule({
  name = "noctalia-blur",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
  },
  ignore_alpha = 0.5,
  blur = true,
  blur_popups = true,
})

hl.config({
  ecosystem = {
    enforce_permissions = true,
  },
})

hl.permission("^/usr/bin/noctalia$", "screencopy", "allow")
hl.permission("^hl-virtual-keyboard-noctalia$", "keyboard", "allow")

hl.config({
  ecosystem = {
    enforce_permissions = true,
  },
})

hl.permission("^/usr/bin/noctalia$", "screencopy", "allow")
hl.permission("^hl-virtual-keyboard-noctalia$", "keyboard", "allow")
