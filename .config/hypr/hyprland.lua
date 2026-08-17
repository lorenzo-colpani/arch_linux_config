-----------------
---- MONITORS ----
-----------------
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1 })
hl.monitor({
	output = "desc:BNQ BenQ GW2790QT 69P00718019",
	mode = "preferred",
	position = "auto",
	scale = 1,
	transform = 1,
})
hl.monitor({ output = "desc:BNQ BenQ GW3290QT 97R00432019", mode = "preferred", position = "auto", scale = 1 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

---------------------
---- MY PROGRAMS ----
---------------------
local terminal = "kitty"
local menu = "fuzzel"
local clipmanager = "clipse"
local fileManager = "yazi"

-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function()
	hl.exec_cmd("[workspace 1] " .. terminal)
	hl.exec_cmd("nm-applet &")
	hl.exec_cmd("systemctl --user start hyprpolkitagent &")
	hl.exec_cmd("hyprctl set cursor left_ptr &")
	hl.exec_cmd([[sh -c "sleep 1 && mako"]])
	hl.exec_cmd("clipse -listen &")
	hl.exec_cmd("waybar &")
	hl.exec_cmd("hyprpaper &")
	hl.exec_cmd("blueman-applet &")
	hl.exec_cmd("spotify &")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("AQ_DRM_DEVICES", "/dev/dri/nvidia-dgpu:/dev/dri/intel-igpu")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("__GL_VRR_ALLOWED", "1")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
hl.env("WLR_DRM_NO_ATOMIC", "1")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 2,
		col = {
			active_border = "rgb(88c0d0)",
			inactive_border = "rgb(4c566a)",
		},
		layout = "dwindle",
		allow_tearing = true,
	},
	dwindle = {
		preserve_split = true,
	},
	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = false,
	},
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = false,
		},
	},
})

----------------------
---- WINDOW RULES ----
----------------------
-- Tearing
hl.window_rule({
	match = { class = "^(cs2)$" },
	immediate = true,
})

-- Suppress maximize requests
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Fix dragging issues with XWayland
hl.window_rule({
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- Clipse
hl.window_rule({
	name = "clipse_rule",
	match = { class = clipmanager },
	float = true,
	size = { 622, 652 },
	stay_focused = true,
})

-- Spotify
hl.window_rule({
	match = { class = "^(spotify)$" },
	workspace = "special:dwm-like",
})

-- Steam
hl.window_rule({
	name = "steam_floating",
	match = { title = "^(steam|Steam - News|Friends List|Steam Settings|Screenshot Uploader)$" },
	float = true,
})

---------------------
---- KEYBINDINGS ----
---------------------
local mainMod = "SUPER"

-- Applications & Utilities
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd(terminal))
hl.bind("CTRL + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("wlogout"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("brave --disable-features=WaylandWpColorManagerV1 &"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(terminal .. " --class clipse -e 'clipse'"))
hl.bind(mainMod .. " + 3", hl.dsp.exec_cmd("spotify-launcher &"))
hl.bind(mainMod .. " + 4", hl.dsp.exec_cmd("tuxedo-control-center &"))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("nohup steam > /dev/null 2>&1 &"))
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd("~/.config/hypr/scripts/single_monitor.sh"))
hl.bind(mainMod .. " + CTRL + G", hl.dsp.exec_cmd("~/.config/hypr/scripts/all_monitor.sh"))
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + bar", hl.dsp.layout("togglesplit"))

-- Move focus (directional)
hl.bind(mainMod .. " + ALT + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + ALT + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + ALT + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + ALT + J", hl.dsp.focus({ direction = "down" }))

-- Workspaces
local workspaces = {
	["1"] = "1",
	["2"] = "2",
	["5"] = "5",
	["7"] = "7",
	["8"] = "8",
	["9"] = "9",
	["F"] = "name:F",
	["D"] = "name:D",
	["J"] = "name:J",
	["K"] = "name:K",
	["L"] = "name:L",
	["colon"] = "name::",
}

for key, target in pairs(workspaces) do
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = target }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = target }))
end

-- Special Workspaces
hl.bind(mainMod .. " + Tab", hl.dsp.workspace.toggle_special("dwm-like"))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.window.move({ workspace = "special:dwm-like", silent = true }))
hl.bind(mainMod .. " + CTRL + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Mouse & Monitor Bindings
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ monitor = "+1" }))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ monitor = "-1" }))

-- Audio & Brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Media Keys
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd([[grim ~/Pictures/$(date +%s_grim.png)]]))
