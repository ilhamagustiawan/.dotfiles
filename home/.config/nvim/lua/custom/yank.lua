local M = {}

M.get_buffer_absolute = function()
  if vim.bo.filetype == "oil" then
    local ok, oil = pcall(require, "oil")
    if not ok then
      vim.notify("Oil is unavailable", vim.log.levels.WARN)
      return nil
    end

    local dir = oil.get_current_dir()
    if not dir then
      vim.notify("No local path available for this Oil buffer", vim.log.levels.WARN)
      return nil
    end

    local entry = oil.get_cursor_entry()
    return entry and vim.fs.normalize(dir .. (entry.parsed_name or entry.name)) or vim.fs.normalize(dir)
  end

  return vim.fn.expand "%:p"
end

M.get_buffer_cwd_relative = function()
  local path
  if vim.bo.filetype == "oil" then
    local absolute = M.get_buffer_absolute()
    if not absolute then
      return nil
    end
    path = vim.fn.fnamemodify(absolute, ":.")
  else
    path = vim.fn.expand "%:."
  end
  return path:gsub("\\", "/")
end

M.get_visual_bounds = function()
  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" then
    error("get_visual_bounds must be called in visual or visual-line mode (current mode: " .. vim.inspect(mode) .. ")")
  end
  local is_visual_line_mode = mode == "V"
  local start_pos = vim.fn.getpos "v"
  local end_pos = vim.fn.getpos "."

  return {
    start_line = math.min(start_pos[2], end_pos[2]),
    end_line = math.max(start_pos[2], end_pos[2]),
    start_col = is_visual_line_mode and 0 or math.min(start_pos[3], end_pos[3]) - 1,
    end_col = is_visual_line_mode and -1 or math.max(start_pos[3], end_pos[3]),
    mode = mode,
    start_pos = start_pos,
    end_pos = end_pos,
  }
end

M.format_line_range = function(start_line, end_line)
  return start_line == end_line and tostring(start_line) or start_line .. "-" .. end_line
end

M.simulate_yank_highlight = function()
  local bounds = M.get_visual_bounds()

  local ns = vim.api.nvim_create_namespace "simulate_yank_highlight"
  vim.highlight.range(
    0,
    ns,
    "IncSearch",
    { bounds.start_line - 1, bounds.start_col },
    { bounds.end_line - 1, bounds.end_col },
    { priority = 200 }
  )
  vim.defer_fn(function()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  end, 150)
end

M.exit_visual_mode = function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end

M.yank_path = function(path, label)
  if not path then
    return
  end
  vim.fn.setreg("+", path)
  print("Yanked " .. label .. " path: " .. path)
end

M.yank_visual_with_path = function(path, label)
  if not path then
    return
  end
  if vim.bo.filetype == "oil" then
    M.yank_path(path, label)
    M.simulate_yank_highlight()
    M.exit_visual_mode()
    return
  end

  local bounds = M.get_visual_bounds()

  local line_range = M.format_line_range(bounds.start_line, bounds.end_line)
  local path_with_lines = path .. ":" .. line_range

  local result = path_with_lines
  vim.fn.setreg("+", result)

  M.simulate_yank_highlight()

  M.exit_visual_mode()

  print("Yanked " .. label .. " with lines " .. line_range)
end

---Format diagnostics, most severe first.
---Example: `ERROR 13 [ts] Cannot find name 'save'. (2304)`
---@param diagnostics vim.Diagnostic[]
---@return string[]
M.format_diagnostics = function(diagnostics)
  table.sort(diagnostics, function(a, b)
    if a.severity ~= b.severity then
      return a.severity < b.severity
    end
    if a.lnum ~= b.lnum then
      return a.lnum < b.lnum
    end
    return a.col < b.col
  end)

  local lines = {}
  for _, d in ipairs(diagnostics) do
    -- Source falls back to namespace name (linter / LSP client)
    local source = d.source or vim.diagnostic.get_namespace(d.namespace).name
    local prefix = string.format("%-5s %d ", vim.diagnostic.severity[d.severity], d.lnum + 1)
    if source then
      prefix = prefix .. "[" .. source .. "] "
    end

    -- Multi-line messages: continuation lines aligned under the first
    local message = vim.split(vim.trim(d.message), "\n")
    if d.code then
      message[#message] = message[#message] .. " (" .. tostring(d.code) .. ")"
    end
    local indent = string.rep(" ", #prefix)
    for i, text in ipairs(message) do
      table.insert(lines, (i == 1 and prefix or indent) .. text)
    end
  end
  return lines
end

---Yank path, code and diagnostics of cursor line (normal) or selection (visual).
---@param path string|nil
---@param label string
M.yank_diagnostics = function(path, label)
  if not path then
    return
  end

  local mode = vim.fn.mode()
  local is_visual = mode == "v" or mode == "V"
  local start_line, end_line
  if is_visual then
    local bounds = M.get_visual_bounds()
    start_line, end_line = bounds.start_line, bounds.end_line
  else
    start_line = vim.fn.line "."
    end_line = start_line
  end

  -- Header and fenced code; fence language from extension (e.g. tsx)
  local line_range = M.format_line_range(start_line, end_line)
  local fence_lang = vim.fn.expand "%:e"
  if fence_lang == "" then
    fence_lang = vim.bo.filetype
  end
  local result = { path .. ":" .. line_range, "```" .. fence_lang }
  vim.list_extend(result, vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false))
  table.insert(result, "```")

  -- Diagnostics within range (lnum is 0-based); section omitted when none
  local diagnostics = vim.tbl_filter(function(d)
    return d.lnum + 1 >= start_line and d.lnum + 1 <= end_line
  end, vim.diagnostic.get(0))
  if #diagnostics > 0 then
    table.insert(result, "Diagnostics:")
    vim.list_extend(result, M.format_diagnostics(diagnostics))
  end

  vim.fn.setreg("+", table.concat(result, "\n"))

  if is_visual then
    M.simulate_yank_highlight()
    M.exit_visual_mode()
  end

  print("Yanked " .. label .. " with lines " .. line_range .. " and " .. #diagnostics .. " diagnostics")
end

return M
