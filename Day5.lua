---@class Range
local Range = {
    _min = 0,
    _max = 0,
}

---@param min number
---@param max number
---@return Range
function Range:new(min, max)
    local range = setmetatable({}, {__index = Range})
    range._min = min
    range._max = max
    return range
end

---@param value number
---@return boolean inRange
function Range:Contains(value)
    return value >= self._min and value <= self._max
end

---@class Ingredients
local Ingredients = {
    ---@type Range[]
    _freshRanges = {},
    ---@type number
    _freshCount = 0,
}

---@return Ingredients
function Ingredients:new()
    local ingredients = setmetatable({}, {__index = Ingredients})
    return ingredients
end

---@param inputLines string
function Ingredients:ParseInput(inputLines)
    for line in inputLines:gmatch("[^\n]+") do
        local rangeMin, rangeMax = line:match("(%d+)%-(%d+)")
        if rangeMin and rangeMax then
            table.insert(self._freshRanges, Range:new(tonumber(rangeMin), tonumber(rangeMax)))
        else
            local ingredient = line:match("%d+")
            if self:IsInRanges(tonumber(ingredient)) then
                self._freshCount = self._freshCount + 1
            end
        end
    end
end

---@param value number
---@return boolean inRanges
function Ingredients:IsInRanges(value)
    for _, range in ipairs(self._freshRanges) do
        if range:Contains(value) then
            return true
        end
    end
    return false
end

function Ingredients:GetFreshCount()
    return self._freshCount
end

local input = require("Input")
local p1 = Ingredients:new()
p1:ParseInput(input)
print(p1:GetFreshCount())