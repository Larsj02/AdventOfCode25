---@class Row
local Row = {
    ---@type number[]
    _nums = {}
}

---@param nums string
---@return Row row
function Row:New(nums)
    local row = setmetatable({}, {__index = Row})

    local numTbl = {}
    for num in nums:gmatch("%d") do table.insert(numTbl, tonumber(num)) end
    row._nums = numTbl

    return row
end

---@param batteryCount number
---@return number maxJolt
function Row:GetMaxJolt(batteryCount)
    local high, lastI = "", 1

    for i = 1, batteryCount do
        local maxNum, maxI = -1, -1
        for numI = lastI, #self._nums - (batteryCount - i) do
            local num = self._nums[numI]
            if num > maxNum then
                maxNum = num
                maxI = numI
            end
        end

        high = high .. maxNum
        lastI = maxI + 1
    end

    return tonumber(high)
end

---@class Bank
local Bank = {
    ---@type Row[]
    _rows = {},
    ---@type number
    _batteryCount = 2
}

---@param rowsStr string
---@param batteryCount number
---@return Bank bank
function Bank:New(rowsStr, batteryCount)
    local bank = setmetatable({}, {__index = Bank})

    local rows = {}
    for rowStr in rowsStr:gmatch("[^\n]+") do
        local row = Row:New(rowStr)
        table.insert(rows, row)
    end
    bank._rows = rows
    bank._batteryCount = batteryCount
    return bank
end

---@return number totalJolt
function Bank:GetTotalJolt()
    local sum = 0
    for _, row in ipairs(self._rows) do
        sum = sum + row:GetMaxJolt(self._batteryCount)
    end

    return sum
end

local input = require("Input")
local p1 = Bank:New(input, 2)
print(("Solution 1: %d"):format(p1:GetTotalJolt()))
local p2 = Bank:New(input, 12)
print(("Solution 2: %d"):format(p2:GetTotalJolt()))