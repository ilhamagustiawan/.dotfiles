-- Migrated from Herdr (~/.config/herdr/config.toml). Prefix: ctrl+f.

-- Pass the prefix through to programs on double press
rex.bind("ctrl+f>ctrl+f", "pane.send_key", { key = "ctrl+f" })

-- Client, sessions, tabs
rex.bind("ctrl+f>shift+s", "client.settings")
rex.bind("ctrl+f>w", "session.switch")
rex.bind("ctrl+f>r", "client.config.reload")
rex.bind("ctrl+f>ctrl+p", "session.previous")
rex.bind("ctrl+f>ctrl+n", "session.next")
rex.bind("ctrl+f>,", "client.tab.rename")
rex.bind("ctrl+f>shift+x", "client.tab.close")

-- Panes
rex.bind("ctrl+f>v", "pane.split", { direction = "right" })
rex.bind("ctrl+f>s", "pane.split", { direction = "down" })
-- tmux kill-pane: closing the last pane closes its tab
local function window_of(view, block_id)
  for _, w in ipairs(view.windows) do
    local count, found = 0, false
    for _, layer in ipairs(w.layers) do
      for _, b in ipairs(layer.blocks) do
        count = count + 1
        found = found or b.block_id == block_id
      end
    end
    if found then
      return w, count
    end
  end
end

rex.action{
  name  = "kill_pane",
  title = "Kill Pane",
  run   = function(ctx)
    local view, err = rex.session.view{}
    if err ~= nil then error(err, 0) end

    -- Last pane: close the whole tab
    local w, count = window_of(view, ctx.block_id)
    if w ~= nil and count == 1 then
      rex.session.close_window{ window_id = w.window_id }
      return
    end

    rex.client.queue("pane.close")
  end,
}

rex.bind("ctrl+f>x", "kill_pane")
rex.bind("ctrl+f>m", "pane.zoom")

-- Navigation: Herdr defaults (commented out in config.toml, so active there)

-- Workspaces map to sessions
rex.bind("ctrl+f>shift+n", "session.new")
rex.bind("ctrl+f>shift+w", "session.rename")
rex.bind("ctrl+f>shift+d", "session.close")
rex.bind("ctrl+f>g", "session.switch")

-- Tabs: c new, n/p cycle, 1-9 jump
rex.bind("ctrl+f>c", "client.tab.new")
rex.bind("ctrl+f>n", "client.tab.next")
rex.bind("ctrl+f>p", "client.tab.previous")
for i = 1, 9 do
  rex.bind("ctrl+f>" .. i, "client.tab.goto", { index = i })
end

-- Panes: hjkl focus, shift+hjkl swap, tab cycles
local dirs = { h = "left", j = "down", k = "up", l = "right" }
for key, dir in pairs(dirs) do
  rex.bind("ctrl+f>" .. key, "pane.focus", { direction = dir })
  rex.bind("ctrl+f>shift+" .. key, "pane.move", { direction = dir })
end
rex.bind("ctrl+f>tab", "pane.focus_next")
rex.bind("ctrl+f>shift+tab", "pane.focus_previous")

-- Sidebar
rex.bind("ctrl+f>b", "client.sidebar.toggle")

-- Resize mode: arrows resize, enter/escape leave
rex.mode("resize", { exclusive = true })
rex.bind("resize/enter", "client.mode.exit")
rex.bind("resize/escape", "client.mode.exit")
rex.bind("ctrl+f>shift+r", "client.mode.enter", { name = "resize" })
rex.bind("resize/left", "pane.resize", { direction = "left" })
rex.bind("resize/down", "pane.resize", { direction = "down" })
rex.bind("resize/up", "pane.resize", { direction = "up" })
rex.bind("resize/right", "pane.resize", { direction = "right" })
