require "helpers.InheritanceObject"

---@class Dial : InheritanceObject
---@field value integer
SlowDial = InheritanceObject:new({value = 50, zero_counter = 0})

local TurnRightOnce = function (self)
    self.value = self.value + 1
    if self.value == 100 then
        self.value = 0
        self.zero_counter = self.zero_counter + 1
    end
end

local TurnLeftOnce = function (self)
    self.value = (self.value - 1)%100
    if self.value == 0 then
        self.zero_counter = self.zero_counter + 1
    end
end

function SlowDial:TurnRight(amount)
    for i = 1,amount do
        TurnRightOnce(self)
    end
end

function SlowDial:TurnLeft(amount)
    for i = 1,amount do
        TurnLeftOnce(self)
    end
end

