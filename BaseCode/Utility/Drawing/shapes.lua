local ShapesUtil = {
    
}

function ShapesUtil:drawLine(pt1, pt2, lineColor, layer, brushSize)
    if brushSize == nil then
        brushSize = 1
    end
    local brush = Brush(brushSize)
    -- local actualPt2 = Point(pt2.x - 1 + (brushSize - 1), pt2.y - 1 + (brushSize - 1))
    app.useTool{
        tool = "line",
        brush = brush,
        color = lineColor,
        points = {pt1, pt2},
        button = MouseButton.left,
        layer = layer,
        tilemapMode=TilemapMode.PIXELS,
        tilesetMode=TilesetMode.AUTO,
        freehandAlgorithm=1,
        contiguous=true,
    }
end

function ShapesUtil:drawRect(pt1, pt2, rectColor, layer, isFill, brushSize)
    if brushSize == nil then
        brushSize = 1
    end
    local brush = Brush(brushSize)
    local actualPt2 = Point(pt2.x - 1 + (brushSize - 1), pt2.y - 1 + (brushSize - 1))
    -- print("drawing rectangle:")
    -- print("on layer:")
    -- print(layer.name)
    -- print("brush size:")
    -- print(brushSize)
    -- print("topLeft:")
    -- print(pt1)
    -- print("bottomRight:")
    -- print(actualPt2)
    if isFill then
        app.useTool{
            tool = "filled_rectangle",
            brush = brush,
            color = rectColor,
            points = {pt1, actualPt2},
            button = MouseButton.left,
            layer = layer,
            tilemapMode=TilemapMode.PIXELS,
            tilesetMode=TilesetMode.AUTO,
            freehandAlgorithm=1,
            contiguous=true,
        }
    else
        app.useTool{
            tool = "rectangle",
            brush = brush,
            color = rectColor,
            points = {pt1, actualPt2},
            button = MouseButton.left,
            layer = layer,
            tilemapMode=TilemapMode.PIXELS,
            tilesetMode=TilesetMode.AUTO,
            freehandAlgorithm=1,
            contiguous=true,
        }
    end
end

function ShapesUtil:drawRectFromRect(rect, rectColor, layer, isFill, brushSize)
    local pt1 = Point(rect.x, rect.y)
    local pt2 = Point(rect.x + rect.width, rect.y + rect.height)
    self:drawRect(pt1, pt2, rectColor, layer, isFill, brushSize)
end

function ShapesUtil:drawOutlineFromRect(
    rect,
    outlineColor,
    layer,
    hasTopOutline,
    hasRightOutline,
    hasBottomOutline,
    hasLeftOutline,
    brushSize
)
    local pt1
    local pt2
    if hasTopOutline then
        pt1 = Point(rect.x, rect.y)
        pt2 = Point(rect.x + rect.width - 1 + (brushSize - 1), rect.y)
        self:drawLine(pt1, pt2, outlineColor, layer, brushSize)
    end
    if hasRightOutline then
        pt1 = Point(rect.x + rect.width - 1 + (brushSize - 1), rect.y)
        pt2 = Point(rect.x + rect.width - 1 + (brushSize - 1), rect.y + rect.height - 1 + (brushSize - 1))
        self:drawLine(pt1, pt2, outlineColor, layer, brushSize)
    end
    if hasBottomOutline then
        pt1 = Point(rect.x + rect.width - 1 + (brushSize - 1), rect.y + rect.height - 1 + (brushSize - 1))
        pt2 = Point(rect.x, rect.y + rect.height - 1 + (brushSize - 1))
        self:drawLine(pt1, pt2, outlineColor, layer, brushSize)
    end
    if hasLeftOutline then
        pt1 = Point(rect.x, rect.y + rect.height - 1 + (brushSize - 1))
        pt2 = Point(rect.x, rect.y)
        self:drawLine(pt1, pt2, outlineColor, layer, brushSize)
    end
end

return ShapesUtil