local constants = {
    selectActionTypes = {
        SELECT_ONLY = 1,
        SELECT_AND_COPY = 2,
        SELECT_AND_CUT = 3,
        SELECT_AND_CLEAR = 4
    },
    BASIC_BRUSH = Brush(1)
}

local DrawingFunctions = {
    constants = constants,
}

DrawingFunctions.select = function(selectAction, selectRect, layer)
    if app.sprite == nil or layer == nil then
        return
    end
    if selectAction == nil then
        selectAction = constants.selectActionTypes.SELECT_ONLY
    end
    app.layer = layer
    if selectRect == nil then
        app.command.MaskAll()
    else 
        app.useTool{
            tool = "rectangular_marquee",
            brush = constants.BASIC_BRUSH,
            points = {Point(selectRect.x,selectRect.y), Point(selectRect.width, selectRect.height)},
            button = MouseButton.left,
            layer = layer,
            tilemapMode=TilemapMode.PIXELS,
            tilesetMode=TilesetMode.MANUAL,
            freehandAlgorithm=1,
            contiguous=true,
        }
    end

    if selectAction == constants.selectActionTypes.SELECT_AND_COPY then
        app.command.Copy()
    elseif selectAction == constants.selectActionTypes.SELECT_AND_CUT then
        app.command.Cut()
    elseif selectAction == constants.selectActionTypes.SELECT_AND_CLEAR then
        app.command.Clear()
    end
end

DrawingFunctions.selectAll = function(selectAction, layer)
    DrawingFunctions.select(selectAction, nil, layer)
end

DrawingFunctions.copyFrom = function(selectAction, selectRect, layerFrom, layerTo)
    if layerFrom == nil or layerTo == nil then
        return
    end
    if selectAction == nil or selectAction == constants.selectActionTypes.SELECT_ONLY then
        selectAction = constants.selectActionTypes.SELECT_AND_COPY
    end
    if selectRect == nil then
        DrawingFunctions.selectAll(selectAction, layerFrom)
    else
        DrawingFunctions.select(selectAction, selectRect, layerFrom)
    end
    app.layer = layerTo
    app.command.Paste()
end

DrawingFunctions.copyAllFrom = function(selectAction, layerFrom, layerTo)
    return DrawingFunctions.copyFrom(selectAction, nil, layerFrom, layerTo)
end



DrawingFunctions.switchToPencil = function(layer)
    if layer == nil then
        return
    end
    app.useTool{
        tool = "rectangular_marquee",
        brush = constants.BASIC_BRUSH,
        points = {Point(0,0)},
        button = MouseButton.left,
        layer = layer,
        tilemapMode=TilemapMode.PIXELS,
        tilesetMode=TilesetMode.MANUAL,
        selection=SelectionMode.REPLACE,
        freehandAlgorithm=1,
        contiguous=true,
    }
    app.useTool{
        tool = "rectangular_marquee",
        brush = constants.BASIC_BRUSH,
        points = {Point(0,0)},
        button = MouseButton.right,
        layer = layer,
        tilemapMode=TilemapMode.PIXELS,
        tilesetMode=TilesetMode.MANUAL,
        selection=SelectionMode.SUBTRACT,
        freehandAlgorithm=1,
        contiguous=true,
    }
    app.tool = "pencil"
end

return DrawingFunctions