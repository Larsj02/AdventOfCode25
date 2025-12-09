local input = require("Input")

---@enum COLOR
local COLOR = {
    RED = 1,
    GREEN = 2,
    NONE = 3
}

---@class Tile
local Tile = {
    ---@type number
    _x = 0,
    ---@type number
    _y = 0,
    ---@type COLOR
    _color = COLOR.NONE
}

---@param x number
---@param y number
---@param color COLOR|nil
---@return Tile tile
function Tile:New(x, y, color)
    local tile = setmetatable({}, { __index = self })
    tile._x = x
    tile._y = y
    tile._color = color or COLOR.NONE
    return tile
end

---@class TileList
local TileList = {
    ---@type Tile[]
    _tiles = {}
}

---@return TileList tileList
function TileList:New()
    local tileList = setmetatable({}, { __index = self })
    tileList._tiles = {}
    return tileList
end

---@param tile Tile
function TileList:AddTile(tile)
    table.insert(self._tiles, tile)
end

---@param str string
function TileList:ParseList(str)
    for x, y in str:gmatch("(%d+),(%d+)\n*") do
        self:AddTile(Tile:New(tonumber(x), tonumber(y), COLOR.RED))
    end
end

---@param tileA Tile
---@param tileB Tile
---@return number area
function TileList:GetSquareArea(tileA, tileB)
    local width = math.abs(tileA._x - tileB._x) + 1
    local height = math.abs(tileA._y - tileB._y) + 1
    return width * height
end

---@return number area, {tileA: Tile, tileB: Tile} biggestTiles
function TileList:GetBiggestSquare()
    local biggestArea = 0
    ---@type {tileA: Tile, tileB: Tile}
    local biggestTiles = {}
    for _, tileA in ipairs(self._tiles) do
        for _, tileB in ipairs(self._tiles) do
            if tileA ~= tileB then
                local area = self:GetSquareArea(tileA, tileB)
                if area > biggestArea then
                    biggestArea = area
                    biggestTiles = { tileA = tileA, tileB = tileB }
                end
            end
        end
    end
    return biggestArea, biggestTiles
end

local tileList = TileList:New()
tileList:ParseList(input)
local area = tileList:GetBiggestSquare()
print(("Solution 1: %d"):format(area))