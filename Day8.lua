local input = require("Input")

---@class JunctionBox
---@field x number
---@field y number
---@field z number

---@class ConnectionCandidate
---@field boxIndexA number
---@field boxIndexB number
---@field distanceSquared number

---@class CircuitSolver
---@field junctionBoxes JunctionBox[]
---@field parentIndices number[]
local CircuitSolver = {}
CircuitSolver.__index = CircuitSolver

---@param inputStr string
---@return CircuitSolver solver
function CircuitSolver:New(inputStr)
    local instance = setmetatable({}, self)
    instance.junctionBoxes = {}

    for xStr, yStr, zStr in inputStr:gmatch("(%d+),(%d+),(%d+)") do
        table.insert(instance.junctionBoxes, {
            x = tonumber(xStr),
            y = tonumber(yStr),
            z = tonumber(zStr)
        })
    end

    instance.parentIndices = {}
    for boxIndex = 1, #instance.junctionBoxes do
        instance.parentIndices[boxIndex] = boxIndex
    end

    return instance
end

---@param boxIndex number
---@return number representativeIndex
function CircuitSolver:FindRepresentative(boxIndex)
    if self.parentIndices[boxIndex] == boxIndex then
        return boxIndex
    end

    local representativeIndex = self:FindRepresentative(self.parentIndices[boxIndex])
    self.parentIndices[boxIndex] = representativeIndex

    return representativeIndex
end

---@param boxIndexA number
---@param boxIndexB number
---@return boolean wasMerged
function CircuitSolver:ConnectCircuits(boxIndexA, boxIndexB)
    local representativeA = self:FindRepresentative(boxIndexA)
    local representativeB = self:FindRepresentative(boxIndexB)

    if representativeA ~= representativeB then
        self.parentIndices[representativeA] = representativeB
        return true
    end

    return false
end

---@return ConnectionCandidate[]
function CircuitSolver:GenerateSortedConnections()
    local connections = {}
    local boxCount = #self.junctionBoxes

    for indexA = 1, boxCount do
        for indexB = indexA + 1, boxCount do
            local boxA = self.junctionBoxes[indexA]
            local boxB = self.junctionBoxes[indexB]
            local deltaX, deltaY, deltaZ = boxA.x - boxB.x, boxA.y - boxB.y, boxA.z - boxB.z

            table.insert(connections, {
                boxIndexA = indexA,
                boxIndexB = indexB,
                distanceSquared = (deltaX * deltaX) + (deltaY * deltaY) + (deltaZ * deltaZ)
            })
        end
    end

    table.sort(connections, function(a, b) return a.distanceSquared < b.distanceSquared end)
    return connections
end

function CircuitSolver:Reset()
    for i = 1, #self.junctionBoxes do self.parentIndices[i] = i end
end

---@return number result1
function CircuitSolver:GetSolution1()
    self:Reset()
    local allPossibleConnections = self:GenerateSortedConnections()

    for i = 1, math.min(1000, #allPossibleConnections) do
        local conn = allPossibleConnections[i]
        self:ConnectCircuits(conn.boxIndexA, conn.boxIndexB)
    end

    local circuitSizeMap = {}
    for boxIndex = 1, #self.junctionBoxes do
        local root = self:FindRepresentative(boxIndex)
        circuitSizeMap[root] = (circuitSizeMap[root] or 0) + 1
    end

    local sortedSizes = {}
    for _, size in pairs(circuitSizeMap) do table.insert(sortedSizes, size) end
    table.sort(sortedSizes, function(a, b) return a > b end)

    return (sortedSizes[1] or 0) * (sortedSizes[2] or 0) * (sortedSizes[3] or 0)
end

---@return number result2
function CircuitSolver:GetSolution2()
    self:Reset()
    local allPossibleConnections = self:GenerateSortedConnections()

    local distinctCircuits = #self.junctionBoxes

    for _, conn in ipairs(allPossibleConnections) do
        if self:ConnectCircuits(conn.boxIndexA, conn.boxIndexB) then
            distinctCircuits = distinctCircuits - 1

            if distinctCircuits == 1 then
                local bA = self.junctionBoxes[conn.boxIndexA]
                local bB = self.junctionBoxes[conn.boxIndexB]
                return bA.x * bB.x
            end
        end
    end
    return 0
end

local solver = CircuitSolver:New(input)
local result1 = solver:GetSolution1()
print(("Solution 1: %d"):format(result1))
local result2 = solver:GetSolution2()
print(("Solution 2: %d"):format(result2))