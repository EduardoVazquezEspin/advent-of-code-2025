require "day7.InputReader"
require "day7.TachyonSim"

---@type Day7.InputReader
local reader = Day7.InputReader:new()

local input = reader:read("./day7/part1/input.txt")

local tachyonSim = Day7.TachyonSim:new({
    map = input
})

print(tachyonSim:Simulate()) --21