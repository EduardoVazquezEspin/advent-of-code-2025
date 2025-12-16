require "helpers.InheritanceObject"

---@class BigUInt : InheritanceObject
---@field _small_value number
---@field _big_value number
BigUInt = InheritanceObject:new()

local LIMIT = 1000000000

---@param value number
---@return BigUInt
function BigUInt:new(value)
    local instance = InheritanceObject.new(self, {
        _small_value = value % LIMIT,
        _big_value = math.floor(value / LIMIT)
    })
    return instance
end

---@param value BigUInt
---@return BigUInt
function BigUInt:add(value)
    local small_value = value._small_value + self._small_value
    local big_value = value._big_value + self._big_value
    local result = BigUInt:new(0)
    result._small_value = small_value % LIMIT
    result._big_value = big_value + math.floor(small_value / LIMIT)
    return result
end

---@return string
function BigUInt:to_string()
    return self._big_value .. self._small_value
end