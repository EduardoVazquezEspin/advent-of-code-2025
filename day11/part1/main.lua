require "day11.InputReader"

---@type Day11.InputReader
local reader = Day11.InputReader:new()

local graph = reader:read("./day11/part1/input.txt")

local paths = graph:count_paths("you")

print(paths["out"]) --5