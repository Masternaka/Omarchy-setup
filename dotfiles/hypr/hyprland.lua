-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })

-- Charger les affectations et raccourcis globaux après les valeurs par défaut.
require("hypr.workspaces")

-- Omarchy's Mirror Display toggle takes effect over the profile while it is on.
do
  local state = os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")
  local path = state .. "/omarchy/toggles/hypr/internal-monitor-mirror.lua"
  local file = io.open(path, "r")
  if type(o) == "table" and file then
    file:close()
    dofile(path)
  elseif file then
    file:close()
  end
end
