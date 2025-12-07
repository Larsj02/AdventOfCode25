local input = require("Input")

local arr = {}
local operations = {}
local rowCount = 1
for row in input:gmatch("[^\n]+") do
    local colCount = 1
    for col in row:gmatch("[^%s]+") do
        if not arr[colCount] then
            arr[colCount] = {}
        end
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

local totalSum = 0
for colNum, operation in pairs(operations) do
    if operation == "+" then
        local sum = 0
        for rowNum = 1, #arr[colNum] do
            sum = sum + arr[colNum][rowNum]
        end
        totalSum = totalSum + sum
    elseif operation == "*" then
        local sum = 1
        for rowNum = 1, #arr[colNum] do
            sum = sum * arr[colNum][rowNum]
        end
        totalSum = totalSum + sum
    end
end
print("Total Sum: " .. totalSum)
