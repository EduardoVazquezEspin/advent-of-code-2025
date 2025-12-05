require "helpers.InheritanceObject"

---@class Reader : InheritanceObject
Reader = InheritanceObject:new()

---@param path string
---@return boolean
function Reader:file_exists(path)
  local f = io.open(path, "rb")
  if f then f:close() end
  return f ~= nil
end

---@param path string
---@return table<number, string>
function Reader:read_file(path)
  if not self:file_exists(path) then return {} end
  local lines = {}
  for line in io.lines(path) do 
    lines[#lines + 1] = line
  end
  return lines
end
