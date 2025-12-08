local input = require("Input")

---@class CephalopodMath
local CephalopodMath = {
    ---@type string[]
    _lines = {},
    ---@type number
    _part1Total = 0,
    ---@type number
    _part2Total = 0,
}

---@return CephalopodMath solver
function CephalopodMath:new()
    local solver = setmetatable({}, {__index = CephalopodMath})
    return solver
end

---@param numbers number[]
---@param operator string
---@return number result
function CephalopodMath:CalculateBlock(numbers, operator)
    local result = 0
    if operator == "+" then
        result = 0
        for _, num in ipairs(numbers) do
            result = result + num
        end
    elseif operator == "*" then
        result = 1
        for _, num in ipairs(numbers) do
            result = result * num
        end
    end
    return result
end

---@param inputString string
function CephalopodMath:ParseAndSolve(inputString)
    for line in inputString:gmatch("[^\n]+") do
        table.insert(self._lines, line)
    end

    self:SolvePart1(inputString)
    self:SolvePart2()
end

---@param inputString string
function CephalopodMath:SolvePart1(inputString)
    local arr = {}
    local operations = {}
    local rowCount = 1

    for row in inputString:gmatch("[^\n]+") do
        local colCount = 1
        for col in row:gmatch("[^%s]+") do
            if not arr[colCount] then arr[colCount] = {} end

            local num = tonumber(col)
            if not num then
                operations[colCount] = col
            else
                arr[colCount][rowCount] = num
            end
            colCount = colCount + 1
        end
        rowCount = rowCount + 1
    end

    for colNum, operation in pairs(operations) do
        self._part1Total = self._part1Total + self:CalculateBlock(arr[colNum], operation)
    end
end

function CephalopodMath:SolvePart2()
    local maxWidth = 0
    for _, line in ipairs(self._lines) do
        if #line > maxWidth then maxWidth = #line end
    end

    local currentBlockNumbers = {}
    local currentOp = nil

    for col = 1, maxWidth + 1 do
        local isSeparator = true
        local colDigits = ""
        local foundOpInCol = nil

        for row = 1, #self._lines do
            local line = self._lines[row]
            local char = (col <= #line) and line:sub(col, col) or " "

            if char ~= " " then
                isSeparator = false
                if row == #self._lines then
                    foundOpInCol = char
                else
                    colDigits = colDigits .. char
                end
            end
        end

        if isSeparator then
            if #currentBlockNumbers > 0 and currentOp then
                self._part2Total = self._part2Total + self:CalculateBlock(currentBlockNumbers, currentOp)
            end
            currentBlockNumbers = {}
            currentOp = nil
        else
            if #colDigits > 0 then
                table.insert(currentBlockNumbers, tonumber(colDigits))
            end
            if foundOpInCol then
                currentOp = foundOpInCol
            end
        end
    end
end

---@return number result
function CephalopodMath:GetSolution1()
    return self._part1Total
end

---@return number result
function CephalopodMath:GetSolution2()
    return self._part2Total
end

local solver = CephalopodMath:new()
solver:ParseAndSolve(input)
print(("Solution 1: %.0f"):format(solver:GetSolution1()))
print(("Solution 2: %.0f"):format(solver:GetSolution2()))