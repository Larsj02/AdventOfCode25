local input = require("Input")

local coords = {}

---@class Coordinate
---@field x number
---@field y number

---@param coord1 Coordinate
---@param coord2 Coordinate
---@return number area
local function getSquare(coord1, coord2)
    local width = math.abs(coord1.x - coord2.x) + 1
    local height = math.abs(coord1.y - coord2.y) + 1
    return width * height
end

local function getBiggestSquare()
    local biggestArea = 0
    local biggestCoords = nil
    for i = 1, #coords do
        for j = i + 1, #coords do
            local area = getSquare(coords[i], coords[j])
            if area > biggestArea then
                biggestArea = area
                biggestCoords = { coords[i], coords[j] }
            end
        end
    end
    return biggestArea, biggestCoords
end

for x, y in input:gmatch("(%d+),(%d+)\n*") do
    table.insert(coords, { x = tonumber(x), y = tonumber(y) })
end

local area, biggestCoords = getBiggestSquare()
print("Biggest area:", area)
print("Coordinates:")
for _, coord in ipairs(biggestCoords) do
    print(string.format("(%d, %d)", coord.x, coord.y))
end
