require "day10.definitions"

---@param array1 {[number]: any}
---@param array2 {[number]: any}
---@return boolean
local function are_equal(array1, array2)
    if #array1 ~= #array2 then
        return false
    end
    for i=1,#array1 do
        if array1[i] ~= array2[i] then
            return false
        end
    end
    return true
end

---@param array1 {[number]: number}
---@param array2 {[number]: number}
---@boolean
local function is_bounded_by(array1, array2)
    if #array1 ~= #array2 then
        error("Invalid arrays to compare")
    end
    for i=1,#array1 do
        if array1[i] > array2[i] then
            return false
        end
    end
    return true
end

---@param array {[number]: boolean}
---@return integer
local function evaluate_z2(array)
    local total = 0
    for i=1,#array do
        if array[i] then
            total = total + 1
        end
    end
    return total
end

---@param array {[number]: integer}
---@return integer
local function evaluate_zp(array)
    local total = 0
    for i=1,#array do
        total = total + array[i]
    end
    return total
end

---@param pieces {[number]: {[number]: integer}}
---@param objective {[number]: boolean}
---@param piece_index number
---@param solution_builder {[number]: boolean}
---@param objective_builder {[number]: boolean}
---@param current_min_solution {["solution"]: {[number]: boolean}}
---@param current_min_solution_evaluation {["evaluation"]: number | nil} 
local function find_min_z2_solution_rec(
    pieces, 
    objective, 
    piece_index, 
    solution_builder,
    objective_builder, 
    current_min_solution, 
    current_min_solution_evaluation
)
    if piece_index == #pieces + 1 then
        if not are_equal(objective_builder, objective) then
            return
        end
        local evaluation = evaluate_z2(solution_builder)
        if current_min_solution_evaluation.evaluation == nil or current_min_solution_evaluation.evaluation > evaluation then
            current_min_solution_evaluation.evaluation = evaluation
            current_min_solution.solution = {}
            for i = 1,#solution_builder do
                current_min_solution.solution[i] = solution_builder[i]
            end
        end
        return
    end

    local piece = pieces[piece_index]
    solution_builder[piece_index] = true
    for i=1,#piece do
        local index = piece[i] + 1
        objective_builder[index] = not objective_builder[index]
    end
    find_min_z2_solution_rec(
        pieces,
        objective,
        piece_index + 1,
        solution_builder,
        objective_builder,
        current_min_solution,
        current_min_solution_evaluation
    )
    solution_builder[piece_index] = false
    for i=1,#piece do
        local index = piece[i] + 1
        objective_builder[index] = not objective_builder[index]
    end
    find_min_z2_solution_rec(
        pieces,
        objective,
        piece_index + 1,
        solution_builder,
        objective_builder,
        current_min_solution,
        current_min_solution_evaluation
    )
end

---@param pieces {[number]: {[number]: integer}}
---@param objective {[number]: boolean}
---@return {["solution"]: {[number]: boolean}, ["evaluation"]: integer} | nil
function Day10.find_min_z2_solution(pieces, objective)
    local empty_objective = {}
    for i = 1, #objective do
        empty_objective[#empty_objective + 1] = false
    end

    local empty_solution = {}
    local solutionObj = {solution = {}}
    for i = 1, #pieces do
        empty_solution[#empty_solution + 1] = false
        solutionObj.solution[#solutionObj.solution + 1] = false
    end

    local evaluationObj = {evaluation = nil}

    find_min_z2_solution_rec(
        pieces, 
        objective, 
        1, 
         empty_solution, 
        empty_objective,
        solutionObj,
        evaluationObj
    )
    if evaluationObj.evaluation == nil then
        return nil
    end
    return {solution = solutionObj.solution, evaluation = evaluationObj.evaluation}
end


---@param pieces {[number]: {[number]: integer}}
---@param objective {[number]: integer}
---@param objective_evaluation integer
---@param piece_index number
---@param solution_builder {[number]: integer}
---@param objective_builder {[number]: integer}
---@param current_min_solution {["solution"]: {[number]: integer}}
---@param current_min_solution_evaluation {["evaluation"]: number | nil} 
local function find_min_zp_solution_rec(
    pieces, 
    objective, 
    objective_evaluation,
    piece_index, 
    solution_builder,
    objective_builder, 
    current_min_solution, 
    current_min_solution_evaluation
)
    if piece_index == #pieces + 1 then
        if not are_equal(objective_builder, objective) then
            return
        end
        local evaluation = evaluate_zp(solution_builder)
        if current_min_solution_evaluation.evaluation == nil or current_min_solution_evaluation.evaluation > evaluation then
            current_min_solution_evaluation.evaluation = evaluation
            current_min_solution.solution = {}
            for i = 1,#solution_builder do
                current_min_solution.solution[i] = solution_builder[i]
            end
        end
        return
    end

    local current_evaluation = evaluate_zp(objective_builder)
    local piece = pieces[piece_index]
    local applications = 0
    while current_evaluation <= objective_evaluation and is_bounded_by(objective_builder, objective) do
        find_min_zp_solution_rec(
            pieces,
            objective,
            objective_evaluation,
            piece_index +1,
            solution_builder,
            objective_builder,
            current_min_solution,
            current_min_solution_evaluation
        )
        for i = 1,#piece do
            local index = piece[i] + 1
            objective_builder[index] = objective_builder[index] + 1
        end
        solution_builder[piece_index] = solution_builder[piece_index] + 1
        current_evaluation = current_evaluation + #piece
        applications = applications + 1
    end
    for i = 1,#piece do
        local index = piece[i] + 1
        objective_builder[index] = objective_builder[index] - applications
    end
    solution_builder[piece_index] = 0
end

---@param pieces {[number]: {[number]: integer}}
---@param objective {[number]: integer}
---@return {["solution"]: {[number]: integer}, ["evaluation"]: integer} | nil
function Day10.find_min_zp_solution(pieces, objective)
    local empty_objective = {}
    for i = 1, #objective do
        empty_objective[#empty_objective + 1] = 0
    end

    local empty_solution = {}
    local solutionObj = {solution = {}}
    for i = 1, #pieces do
        empty_solution[#empty_solution + 1] = 0
        solutionObj.solution[#solutionObj.solution + 1] = 0
    end

    local evaluationObj = {evaluation = nil}

    find_min_zp_solution_rec(
        pieces, 
        objective, 
        evaluate_zp(objective),
        1, 
         empty_solution, 
        empty_objective,
        solutionObj,
        evaluationObj
    )
    if evaluationObj.evaluation == nil then
        return nil
    end
    return {solution = solutionObj.solution, evaluation = evaluationObj.evaluation}
end