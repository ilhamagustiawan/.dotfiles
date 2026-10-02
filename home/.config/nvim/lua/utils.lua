local M = {}

M.functions = {}

M.P = function(v)
  print(vim.inspect(v))
  return v
end

local system_name
if vim.fn.has "mac" == 1 then
  system_name = "macOS"
elseif vim.fn.has "unix" == 1 then
  system_name = "Linux"
elseif vim.fn.has "win32" == 1 then
  system_name = "Windows"
elseif vim.fn.has "wsl" == 1 then
  system_name = "WSL"
else
  print "Unsupported system for sumneko"
end

M.system_name = system_name

return M
