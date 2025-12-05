require "day2.InputReader"
require "day2.common"
require "helpers.helpers"

local reader = InputReader:new()

local input = reader:read("./day2/part1/input.txt")

local result = 0

for i=1,#input do
    local min = tonumber(input[i][1])
    local max = tonumber(input[i][2])
    for val = min,max do
        if isLen2InvalidId(tostring(val)) then
            print(val)
            result = result + val
        end
    end
end

print(result) -- 1227775554