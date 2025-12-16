---@class Day10
Day10 = {}

---@alias Day10.Input.Lights {[number]: boolean}
---@alias Day10.Input.Buttons {[number]: {[number]: integer}}
---@alias Day10.Input.Joltage {[number]: integer}
---@alias Day10.Input.Machine {["lights"]: Day10.Input.Lights, ["buttons"]: Day10.Input.Buttons, ["joltage"]: Day10.Input.Joltage}
---@alias Day10.Input {[number]: Day10.Input.Machine}