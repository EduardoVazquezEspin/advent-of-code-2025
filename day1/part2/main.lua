require "day1.InputReader"
require "day1.SlowDial"

local reader = InputReader:new()

local input = reader:read("./day1/part2/input.txt")

local dial = SlowDial:new()

for i=1,#input do
    if input[i].goRight then
        dial:TurnRight(input[i].number)
    else 
        dial:TurnLeft(input[i].number)
    end
end

print(dial.zero_counter) -- 6