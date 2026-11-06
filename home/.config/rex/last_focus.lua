-- last_focus.lua: tmux last-pane, last-window and last-session, until Rex
-- ships them. init.lua can't receive events, so this file runs in two roles:
--
--   watcher                                 init.lua
--   session_view_changed ──▶ FOCUS_PATH ──▶ last_pane, last_tab
--                                 session keys ──▶ SESSION_PATH ──▶ last_session
--
-- Start the watcher with: rex do ~/.config/rex/last_focus.lua --all watch=true
--
-- The server never learns which session the app shows, so session history
-- comes from the keys that run session_nav. A switch made with the mouse is
-- only noticed at the next tracked key.

local CACHE_DIR = os.getenv("HOME") .. "/Library/Caches"
local FOCUS_PATH = CACHE_DIR .. "/rex-last-focus.json"
local SESSION_PATH = CACHE_DIR .. "/rex-last-session.json"

local function load_json(path)
  local f = io.open(path, "r")
  if f == nil then return {} end

  local text = f:read("*a")
  f:close()

  local ok, value = pcall(rex.json.decode, text)
  return ok and value or {}
end

-- Rename so an action never reads a half-written file
local function save_json(path, value)
  local tmp = path .. ".tmp"
  local f = assert(io.open(tmp, "w"))
  f:write(rex.json.encode(value))
  f:close()
  assert(os.rename(tmp, path))
end

-- Most recent first, dropping ids that no longer exist
-- e.g. touch({ "a", "b", "gone" }, "b", live) -> { "b", "a" }
local function touch(stack, id, live)
  local result = { id }
  for _, old in ipairs(stack or {}) do
    if old ~= id and live[old] then
      result[#result + 1] = old
    end
  end
  return result
end

-- First id in stack that isn't current
local function previous(stack, current)
  for _, id in ipairs(stack or {}) do
    if id ~= current then return id end
  end
end

-- Fold one session view into its pane and tab histories
local function record(state, view)
  local old = state[view.session_id] or {}
  local old_panes = old.panes or {}
  local panes, tabs_live = {}, {}

  for _, w in ipairs(view.windows) do
    local live = {}
    for _, layer in ipairs(w.layers) do
      for _, b in ipairs(layer.blocks) do
        live[b.block_id] = true
      end
    end

    tabs_live[w.window_id] = true
    panes[w.window_id] = touch(old_panes[w.window_id], w.focused_block_id, live)
  end

  state[view.session_id] = {
    panes = panes,
    tabs  = touch(old.tabs, view.active_window_id, tabs_live),
  }
end

local function watch()
  local saved = load_json(FOCUS_PATH)
  local state = {}

  local function refresh(session_id)
    local view = rex.session.view{ session_id = session_id }
    if view == nil then return end

    record(state, view)
    save_json(FOCUS_PATH, state)
  end

  -- Keep history across restarts for sessions that still exist
  local list, err = rex.call("session.list")
  if err ~= nil then error(err, 0) end
  for _, s in ipairs(list.sessions or {}) do
    state[s.session_id] = saved[s.session_id]

    -- --all delivers events, but view needs an attached session
    rex.session.attach{ session_id = s.session_id }
    refresh(s.session_id)
  end

  rex.on("session_view_changed", function(ctx)
    refresh(ctx.session_id)
  end)

  rex.on("session_destroyed", function(_, ev)
    state[ev.session_id] = nil
    save_json(FOCUS_PATH, state)
  end)
end

if rex.args ~= nil and rex.args.watch then
  watch()
  return
end

-- Current session and the one before it
-- e.g. A then B -> { current = "B", last = "A" }
local function note_session(session_id)
  local s = load_json(SESSION_PATH)
  if s.current == session_id then return s end

  s = { current = session_id, last = s.current }
  save_json(SESSION_PATH, s)
  return s
end

local function session_exists(session_id)
  local list = rex.call("session.list")
  for _, s in ipairs(list and list.sessions or {}) do
    if s.session_id == session_id then return true end
  end
  return false
end

local function focus_entry(session_id)
  local entry = load_json(FOCUS_PATH)[session_id]
  if entry == nil then error("last_focus: watcher not running", 0) end
  return entry
end

rex.action{
  name  = "last_pane",
  title = "Focus Last Pane",
  run   = function(ctx)
    note_session(ctx.session_id)

    local view, err = rex.session.view{}
    if err ~= nil then error(err, 0) end

    local stack = focus_entry(ctx.session_id).panes[view.active_window_id]
    local id = previous(stack, ctx.block_id)
    if id == nil then return end

    rex.session.focus_block{ block_id = id }
  end,
}

rex.action{
  name  = "last_tab",
  title = "Show Last Tab",
  run   = function(ctx)
    note_session(ctx.session_id)

    local view, err = rex.session.view{}
    if err ~= nil then error(err, 0) end

    local id = previous(focus_entry(ctx.session_id).tabs, view.active_window_id)
    if id == nil then return end

    -- Ask the app: focus_window moves the server's tab, not the one on screen
    rex.client.queue("session.select", {
      session_id = ctx.session_id,
      window_id  = id,
    })
  end,
}

rex.action{
  name  = "last_session",
  title = "Show Last Session",
  run   = function(ctx)
    local s = note_session(ctx.session_id)
    if s.last == nil or not session_exists(s.last) then return end

    -- Swap now: the app reports nothing when the switch lands
    save_json(SESSION_PATH, { current = s.last, last = ctx.session_id })
    rex.client.queue("session.select", { session_id = s.last })
  end,
}

-- Run a session key, noting the session it leaves
rex.action{
  name  = "session_nav",
  title = "Change Session (Tracked)",
  args  = { action = "string" },
  run   = function(ctx, args)
    note_session(ctx.session_id)
    rex.client.queue(args.action)
  end,
}
