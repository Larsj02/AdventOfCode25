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

---@return number size
function Range:GetSize()
    return self._max - self._min + 1
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

function Ingredients:RemoveOverlappingRanges()
    table.sort(self._freshRanges, function(a, b) return a._min < b._min end)
    local mergedRanges = {}
    local currentRange = self._freshRanges[1]

    for i = 2, #self._freshRanges do
        local nextRange = self._freshRanges[i]
        if currentRange._max >= nextRange._min then
            if nextRange._max > currentRange._max then
                currentRange._max = nextRange._max
            end
        else
            table.insert(mergedRanges, currentRange)
            currentRange = nextRange
        end
    end
    table.insert(mergedRanges, currentRange)
    self._freshRanges = mergedRanges
end

---@param min number
---@param max number
function Ingredients:AddOrExpandRange(min, max)
    if self:IsInRanges(min) or self:IsInRanges(max) then
        for _, range in ipairs(self._freshRanges) do
            if range:Contains(min) then
                if max > range._max then
                    range._max = max
                end
            elseif range:Contains(max) then
                if min < range._min then
                    range._min = min
                end
            end
        end
    else
        table.insert(self._freshRanges, Range:new(min, max))
    end
    self:RemoveOverlappingRanges()
end

---@param inputLines string
function Ingredients:ParseInput(inputLines)
    for line in inputLines:gmatch("[^\n]+") do
        local rangeMin, rangeMax = line:match("(%d+)%-(%d+)")
        if rangeMin and rangeMax then
            self:AddOrExpandRange(tonumber(rangeMin), tonumber(rangeMax))
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

---@return number freshCount
function Ingredients:GetFreshCount()
    return self._freshCount
end

---@return number freshCount
function Ingredients:GetTotalFreshCount()
    local total = 0
    for _, range in ipairs(self._freshRanges) do
        total = total + range:GetSize()
    end
    return total
end

local input = require("Input")
local ingredients = Ingredients:new()
ingredients:ParseInput(input)
print(("Solution 1: %d"):format(ingredients:GetFreshCount()))
print(("Solution 2: %d"):format(ingredients:GetTotalFreshCount()))