---@class InheritanceObject
InheritanceObject = {}

---@generic T : InheritanceObject
---@param o? table Default values
---@return T
function InheritanceObject:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

