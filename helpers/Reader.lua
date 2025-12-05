require "helpers.InheritanceObject"

---@class Reader : InheritanceObject
Reader = InheritanceObject:new()

-- see if the file exists
function Reader:file_exists(path)
  local f = io.open(path, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function Reader:read_file(path)
  if not self:file_exists(path) then return {} end
  local lines = {}
  for line in io.lines(path) do 
    lines[#lines + 1] = line
  end
  return lines
end
