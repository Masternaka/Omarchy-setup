if type(o) == "table" and type(o.workspaces) == "table" and type(o.workspaces.reconcile) == "function" and type(o.rebind) == "function" then
  -- Les callbacks Omarchy consultent ce module au démarrage, au rechargement
  -- et au branchement des écrans. Conserver les affectations globales ci-dessous.
  o.workspaces.enabled = false
  o.workspaces.reconcile = function() end

  local function action(expression, fn)
    o.bind_expressions[fn] = expression
    return fn
  end

  function o.workspaces.focus(workspace)
    return action("o.workspaces.focus(" .. string.format("%q", tostring(workspace)) .. ")", function()
      hl.dispatch(hl.dsp.focus({ workspace = tostring(workspace) }))
    end)
  end

  function o.workspaces.move_window(workspace, follow)
    return action("o.workspaces.move_window(" .. workspace .. ", " .. tostring(follow ~= false) .. ")", function()
      hl.dispatch(hl.dsp.window.move({ workspace = tostring(workspace), follow = follow ~= false }))
    end)
  end

  function o.workspaces.move_to_monitor(direction)
    return action("o.workspaces.move_to_monitor(" .. string.format("%q", direction) .. ")", function()
      hl.dispatch(hl.dsp.workspace.move({ monitor = direction }))
    end)
  end

  -- Replace Omarchy's monitor-local number bindings with global destinations.
  for workspace = 1, 10 do
    local key = "code:" .. tostring(workspace + 9)
    o.rebind("SUPER + " .. key, "Switch to workspace " .. workspace, o.workspaces.focus(workspace))
    o.rebind("SUPER + SHIFT + " .. key, "Move window to workspace " .. workspace, o.workspaces.move_window(workspace))
    o.rebind("SUPER + SHIFT + ALT + " .. key, "Move window silently to workspace " .. workspace, o.workspaces.move_window(workspace, false))
  end

  o.rebind("SUPER + TAB", "Next workspace", o.workspaces.focus("e+1"))
  o.rebind("SUPER + SHIFT + TAB", "Previous workspace", o.workspaces.focus("e-1"))
  o.rebind("SUPER + CTRL + TAB", "Former workspace", o.workspaces.focus("previous"))
  o.rebind("SUPER + mouse_down", "Scroll active workspace forward", o.workspaces.focus("e+1"))
  o.rebind("SUPER + mouse_up", "Scroll active workspace backward", o.workspaces.focus("e-1"))

  for key, direction in pairs({ LEFT = "l", RIGHT = "r", UP = "u", DOWN = "d" }) do
    o.rebind("SUPER + SHIFT + ALT + " .. key, "Move workspace to " .. key:lower() .. " monitor", o.workspaces.move_to_monitor(direction))
  end
end

hl.workspace_rule({ workspace = "1", monitor = "desc:Dell Inc. DELL S2309W F906G9251HYL", default = true, persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "desc:Dell Inc. DELL S2309W F906G9251HYL", persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "desc:Dell Inc. DELL S2309W F906G9251HYL", persistent = true })
hl.workspace_rule({ workspace = "4", monitor = "desc:Dell Inc. DELL S2309W F906G9251HYL", persistent = true })
hl.workspace_rule({ workspace = "5", monitor = "desc:Dell Inc. DELL S2309W F906G9251HYL", persistent = true })
hl.workspace_rule({ workspace = "6", monitor = "desc:Ancor Communications Inc VE228 C2LMQS067753", default = true, persistent = true })
hl.workspace_rule({ workspace = "7", monitor = "desc:Ancor Communications Inc VE228 C2LMQS067753" })
hl.workspace_rule({ workspace = "8", monitor = "desc:Ancor Communications Inc VE228 C2LMQS067753" })
hl.workspace_rule({ workspace = "9", monitor = "desc:Ancor Communications Inc VE228 C2LMQS067753" })
hl.workspace_rule({ workspace = "10", monitor = "desc:Ancor Communications Inc VE228 C2LMQS067753" })

