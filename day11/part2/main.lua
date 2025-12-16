require "day11.InputReader"

---@type Day11.InputReader
local reader = Day11.InputReader:new()

local graph = reader:read("./day11/part2/input.txt")

local paths = graph:count_paths_with_tags("svr", {"fft", "dac"})

local solution = paths["out"][true][true]

print(solution:to_string())

--- svr (aaa)? fft [bbb/ccc eee] dac hhh out