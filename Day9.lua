local input = require("Input")

---@class Tile
local Tile = {
    ---@type number
    _x = 0,
    ---@type number
    _y = 0,
}

---@param x number
---@param y number
---@return Tile tile
function Tile:New(x, y)
    local tile = setmetatable({}, { __index = self })
    tile._x = x
    tile._y = y
    return tile
end

---@return number x
function Tile:GetX()
    return self._x
end

---@return number y
function Tile:GetY()
    return self._y
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
        self:AddTile(Tile:New(tonumber(x), tonumber(y)))
    end
end

---@param tileA Tile
---@param tileB Tile
---@return number area
function TileList:GetSquareArea(tileA, tileB)
    local width = math.abs(tileA:GetX() - tileB:GetX()) + 1
    local height = math.abs(tileA:GetY() - tileB:GetY()) + 1
    return width * height
end

---@param index number
---@return Tile tile
function TileList:GetTile(index)
    return self._tiles[index]
end

---@return number size
function TileList:GetSize()
    return #self._tiles
end

---@param tileA Tile
---@param tileB Tile
---@return boolean isValid
function TileList:IsSquareValid(tileA, tileB)
    local minX, maxX = math.min(tileA:GetX(), tileB:GetX()), math.max(tileA:GetX(), tileB:GetX())
    local minY, maxY = math.min(tileA:GetY(), tileB:GetY()), math.max(tileA:GetY(), tileB:GetY())

    local midX, midY = (minX + maxX) / 2, (minY + maxY) / 2
    local inside = false
    local size = self:GetSize()

    for tileIndex, tile1 in self:IterateTiles() do
        ---@cast tileIndex number
        ---@cast tile1 Tile
        local tile2 = self:GetTile((tileIndex % size) + 1)
        if ((tile1:GetY() > midY) ~= (tile2:GetY() > midY)) then
            if (midX < (tile2:GetX() - tile1:GetX()) * (midY - tile1:GetY()) / (tile2:GetY() - tile1:GetY()) + tile1:GetX()) then
                inside = not inside
            end
        end
    end

    if not inside then return false end

    for tileIndex, tile1 in self:IterateTiles() do
        ---@cast tileIndex number
        ---@cast tile1 Tile
        local tile2 = self:GetTile((tileIndex % size) + 1)

        if tile1:GetX() == tile2:GetX() then
            local edgeX = tile1:GetX()
            local edgeYMin, edgeYMax = math.min(tile1:GetY(), tile2:GetY()), math.max(tile1:GetY(), tile2:GetY())
            if edgeX > minX and edgeX < maxX then
                if math.max(edgeYMin, minY) < math.min(edgeYMax, maxY) then
                    return false
                end
            end

        elseif tile1:GetY() == tile2:GetY() then
            local edgeY = tile1:GetY()
            local edgeXMin, edgeXMax = math.min(tile1:GetX(), tile2:GetX()), math.max(tile1:GetX(), tile2:GetX())
            if edgeY > minY and edgeY < maxY then
                if math.max(edgeXMin, minX) < math.min(edgeXMax, maxX) then
                    return false
                end
            end
        end
    end

    return true
end

---@return fun(): (number|nil, Tile|nil) iterator
function TileList:IterateTiles()
    local index = 0
    local size = self:GetSize()
    return function()
        index = index + 1
        if index <= size then
            return index, self:GetTile(index)
        end
    end
end

---@param tileAIndex number
---@param tileBIndex number
---@param checkedList table<string, boolean>
---@return boolean isInList
function TileList:IsInCheckedList(tileAIndex, tileBIndex, checkedList)
    local lowIndex = math.min(tileAIndex, tileBIndex)
    local highIndex = math.max(tileAIndex, tileBIndex)
    local key = ("%d-%d"):format(lowIndex, highIndex)

    local isInList = checkedList[key] ~= nil
    if not isInList then
        checkedList[key] = true
    end
    return isInList
end

---@param onlyColored boolean|nil
---@return number area, {tileA: Tile, tileB: Tile} biggestTiles
function TileList:GetBiggestSquare(onlyColored)
    local checkedList = {}
    local biggestArea = 0
    ---@type {tileA: Tile, tileB: Tile}
    local biggestTiles = {}
    for tileAIndex, tileA in self:IterateTiles() do
        ---@cast tileA Tile
        ---@cast tileAIndex number
        for tileBIndex, tileB in self:IterateTiles() do
            ---@cast tileB Tile
            ---@cast tileBIndex number
            if tileAIndex ~= tileBIndex and not self:IsInCheckedList(tileAIndex, tileBIndex, checkedList) then
                local area = self:GetSquareArea(tileA, tileB)
                if area > biggestArea and ((onlyColored and self:IsSquareValid(tileA, tileB)) or not onlyColored) then
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
print(("Solution 1: %d"):format(tileList:GetBiggestSquare()))
print(("Solution 2: %d"):format(tileList:GetBiggestSquare(true)))