require "day1.InputReader"
require "day1.Dial"

local reader = InputReader:new()

local input = reader:read("./day1/part1/input.txt")

local dial = Dial:new()

for i=1,#input do
    if input[i].goRight then
        dial:TurnRight(input[i].number)
    else 
        dial:TurnLeft(input[i].number)
    end
end

print(dial.zero_counter) -- 3