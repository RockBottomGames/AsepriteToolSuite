local ShapeDrawingUtils = dofile("../../../Utility/Drawing/shapes.lua")

local DrawTilesUtils = {
    colors = {
        edge = Color{ r=181, g=38, b=110},
        edgeOutline = Color{ r=252, g=91, b=153},
        inner = Color{ r=24, g=40, b=74},
        innerOutline = Color{ r=50, g=77, b=136},
    },
    colorIndex = {
        [1] = "edge",
        [2] = "edgeOutline",
        [3] = "inner",
        [4] = "innerOutline",
    },
    corners = {
        topLeft = 1,
        topRight = 2,
        bottomRight = 3,
        bottomLeft = 4
    },
    quarterSizeKey = {
        -- parent = 1
        [1] = {
            --children
            [1] = {
                width = 2,
                height = 2,
                outlines = {
                    [1] = true,
                    [4] = true,
                },
            },
            [2] = {
                width = 1,
                height = 2,
                outlines = {
                    [1] = true,
                },
            },
            [3] = {
                width = 1,
                height = 1,
                outlines = {
                },
            },
            [4] = {
                width = 2,
                height = 1,
                outlines = {
                    [4] = true,
                },
            },
        },
        -- parent = 2
        [2] = {
            [1] = {
                width = 1,
                height = 2,
                outlines = {
                    [1] = true,
                },
            },
            [2] = {
                width = 2,
                height = 2,
                outlines = {
                    [1] = true,
                    [2] = true,
                },
            },
            [3] = {
                width = 2,
                height = 1,
                outlines = {
                    [2] = true,
                },
            },
            [4] = {
                width = 1,
                height = 1,
                outlines = {
                },
            },
        },
        -- parent = 3
        [3] = {
            [1] = {
                width = 1,
                height = 1,
                outlines = {
                },
            },
            [2] = {
                width = 2,
                height = 1,
                outlines = {
                    [2] = true,
                },
            },
            [3] = {
                width = 2,
                height = 2,
                outlines = {
                    [2] = true,
                    [3] = true,
                },
            },
            [4] = {
                width = 1,
                height = 2,
                outlines = {
                    [3] = true,
                },
            },
        },
        -- parent = 4
        [4] = {
            [1] = {
                width = 2,
                height = 1,
                outlines = {
                    [4] = true,
                },
            },
            [2] = {
                width = 2,
                height = 2,
                outlines = {
                },
            },
            [3] = {
                width = 1,
                height = 2,
                outlines = {
                    [3] = true,
                },
            },
            [4] = {
                width = 1,
                height = 1,
                outlines = {
                    [3] = true,
                    [4] = true,
                },
            },
        },
    }
}

function DrawTilesUtils:getQuarterTileSize(
    parentCornerLocation,
    cornerLocation,
    halfTileWidth,
    halfTileHeight
)
    local size = self.quarterSizeKey[parentCornerLocation][cornerLocation]
    return {
        width = size.width == 1 and math.floor(halfTileWidth / 2.0) or math.ceil(halfTileWidth / 2.0),
        height = size.height == 1 and math.floor(halfTileHeight / 2.0) or math.ceil(halfTileHeight / 2.0),
        outlines = size.outlines
    }
end

function DrawTilesUtils:drawQuarterTile(
    parentRect,
    parentCornerLocation,
    cornerLocation,
    colorIndex,
    halfTileWidth,
    halfTileHeight,
    layer
)
    local xDiff = 0
    local yDiff = 0
    if cornerLocation == 2 or cornerLocation == 3 then
        xDiff = self:getQuarterTileSize(
            parentCornerLocation,
            1,
            halfTileWidth,
            halfTileHeight
        ).width
    end
    if cornerLocation == 3 or cornerLocation == 4 then
        yDiff = self:getQuarterTileSize(
            parentCornerLocation,
            1,
            halfTileWidth,
            halfTileHeight
        ).height
    end
    local rectColor = self.colors[self.colorIndex[colorIndex]]
    local outlineColor = self.colors[self.colorIndex[colorIndex + 1]]
    local size = self:getQuarterTileSize(
        parentCornerLocation,
        cornerLocation,
        halfTileWidth,
        halfTileHeight
    )
    local rect = Rectangle(
        parentRect.x + xDiff,
        parentRect.y + yDiff,
        size.width,
        size.height
    )
    ShapeDrawingUtils:drawRectFromRect(
        rect,
        rectColor,
        layer,
        true,
        1
    )
    ShapeDrawingUtils:drawOutlineFromRect(
        rect,
        outlineColor,
        layer,
        size.outlines[1] ~= nil,
        size.outlines[2] ~= nil,
        size.outlines[3] ~= nil,
        size.outlines[4] ~= nil,
        1
    )
end

function DrawTilesUtils:drawHalfTile(
    parentRect,
    cornerLocation,
    colorIndices,
    halfTileWidth,
    halfTileHeight,
    layer
)
    local xDiff = 0
    local yDiff = 0
    if cornerLocation == 2 or cornerLocation == 3 then
        xDiff = halfTileWidth
    end
    if cornerLocation == 3 or cornerLocation == 4 then
        yDiff = halfTileHeight
    end
    local rect = Rectangle(
        parentRect.x + xDiff,
        parentRect.y + yDiff,
        halfTileWidth,
        halfTileHeight
    )
    for i, colorIndex in pairs(colorIndices) do
        self:drawQuarterTile(
            rect,
            cornerLocation,
            i,
            colorIndex,
            halfTileWidth,
            halfTileHeight,
            layer
        )
    end
end

function DrawTilesUtils.convertTileRectToActual(
    tile,
    halfTileWidth,
    halfTileHeight
)
    return Rectangle(
        tile.rect.x * halfTileWidth,
        tile.rect.y * halfTileHeight,
        halfTileWidth * 2,
        halfTileHeight * 2
    )
end

function DrawTilesUtils:drawTile(
    tile,
    halfTileWidth,
    halfTileHeight,
    layer
)
    for i, halfTile in ipairs(tile.halfTiles) do
        self:drawHalfTile(
            self.convertTileRectToActual(
                tile,
                halfTileWidth,
                halfTileHeight
            ),
            i,
            halfTile.colorIndices,
            halfTileWidth,
            halfTileHeight,
            layer
        )
    end
end

function DrawTilesUtils.newHalfTile(colorIndices)
    local halfTile = {
        colorIndices = colorIndices
    }

    function halfTile:flip(flips)
        local topLeft = self.colorIndices[1]
        local topRight = self.colorIndices[2]
        local bottomRight = self.colorIndices[3]
        local bottomLeft = self.colorIndices[4]
        local tempSwitch = nil

        for _, flip in ipairs(flips) do
            if flip == "d" then
                tempSwitch = topRight
                topRight = bottomLeft
                bottomLeft = tempSwitch
            end

            if flip == "x" then
                tempSwitch = topLeft
                topLeft = topRight
                topRight = tempSwitch
                
                tempSwitch = bottomLeft
                bottomLeft = bottomRight
                bottomRight = tempSwitch
            end

            if flip == "y" then
                tempSwitch = topLeft
                topLeft = bottomLeft
                bottomLeft = tempSwitch
                
                tempSwitch = topRight
                topRight = bottomRight
                bottomRight = tempSwitch
            end
        end

        return DrawTilesUtils.newHalfTile(
            {
                [1] = topLeft,
                [2] = topRight,
                [3] = bottomRight,
                [4] = bottomLeft
            }
        )
    end

    return halfTile
end

function DrawTilesUtils.newTile(halfTiles)
    return DrawTilesUtils.newPlacedTile(halfTiles, Rectangle(0,0,1,1))
end

function DrawTilesUtils.newPlacedTile(halfTiles, rect)
    local tile = {
        halfTiles = halfTiles,
        rect = rect
    }

    function tile:place(rect)
        return DrawTilesUtils.newPlacedTile(self.halfTiles, rect)
    end

    function tile:flip(flips)
        local topLeft = self.halfTiles[1]
        local topRight = self.halfTiles[2]
        local bottomRight = self.halfTiles[3]
        local bottomLeft = self.halfTiles[4]
        local tempSwitch = self.halfTiles[1]

        for _, flip in ipairs(flips) do
            if flip == "d" then
                tempSwitch = topRight
                topRight = bottomLeft
                bottomLeft = tempSwitch

                if topLeft ~=nil then
                    topLeft = topLeft:flip({"d"})
                end
                if topRight ~=nil then
                    topRight = topRight:flip({"d"})
                end
                if bottomRight ~=nil then
                    bottomRight = bottomRight:flip({"d"})
                end
                if bottomLeft ~=nil then
                    bottomLeft = bottomLeft:flip({"d"})
                end
            end

            if flip == "x" then
                tempSwitch = topLeft
                topLeft = topRight
                topRight = tempSwitch
                
                tempSwitch = bottomLeft
                bottomLeft = bottomRight
                bottomRight = tempSwitch

                if topLeft ~=nil then
                    topLeft = topLeft:flip({"x"})
                end
                if topRight ~=nil then
                    topRight = topRight:flip({"x"})
                end
                if bottomRight ~=nil then
                    bottomRight = bottomRight:flip({"x"})
                end
                if bottomLeft ~=nil then
                    bottomLeft = bottomLeft:flip({"x"})
                end
            end

            if flip == "y" then
                tempSwitch = topLeft
                topLeft = bottomLeft
                bottomLeft = tempSwitch
                
                tempSwitch = topRight
                topRight = bottomRight
                bottomRight = tempSwitch
                
                if topLeft ~=nil then
                    topLeft = topLeft:flip({"y"})
                end
                if topRight ~=nil then
                    topRight = topRight:flip({"y"})
                end
                if bottomRight ~=nil then
                    bottomRight = bottomRight:flip({"y"})
                end
                if bottomLeft ~=nil then
                    bottomLeft = bottomLeft:flip({"y"})
                end
            end
        end

        return DrawTilesUtils.newPlacedTile(
            {
                [1] = topLeft,
                [2] = topRight,
                [3] = bottomRight,
                [4] = bottomLeft
            },
            self.rect
        )
    end

    return tile
end

return DrawTilesUtils