require "day4.InputReader"
require "helpers.helpers"

---@type Day4.InputReader
local reader = InputReader:new()

local map = reader:read("./day4/part1/input.txt")

---@type boolean
local any_paper_removed = true
---@type integer
local total_paper_removed = 0
while any_paper_removed do
    any_paper_removed = false
    for i=1,map.height do
        for j=1,map.width do
            if map:get(i, j) then
                ---@type {[number]: boolean}
                local adj = map:get_adjacents(i, j)
                local adjacent_papers = 0
                for t=1,#adj do
                    if adj[t] then
                        adjacent_papers = adjacent_papers +1
                    end
                end
                if adjacent_papers < 4 then
                    map:set(i, j, false)
                    any_paper_removed = true
                    total_paper_removed = total_paper_removed + 1
                end
            end
        end
    end
end

print(total_paper_removed) --43