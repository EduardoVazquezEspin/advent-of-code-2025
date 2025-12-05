require "helpers.InheritanceObject"

---@class Dial : InheritanceObject
---@field value integer
Dial = InheritanceObject:new({value = 50, zero_counter = 0})

local Turn = function (self, amount)
    self.value = (self.value + amount)%100
    if self.value == 0 then
        self.zero_counter = self.zero_counter + 1
    end
end

function Dial:TurnRight(amount)
    Turn(self, amount)
end

function Dial:TurnLeft(amount)
    Turn(self, -amount)
end

