local TileProperties = dofile("./tile_properties.lua")
local LayerProperties = dofile("./layer_properties.lua")
local SpriteUtilsProperties = {}

function SpriteUtilsProperties.createNewLayer(
    layerName,
    tilemap,
    gridbounds,
    top
)
    local nextLayerName = layerName
    local foundLayer = LayerProperties.searchForLayerByName(nextLayerName)
    local count = 1
    while foundLayer ~= nil do
        count = count + 1
        nextLayerName = layerName .. " " .. tostring(count)
        foundLayer = LayerProperties.searchForLayerByName(nextLayerName)
    end

    app.command.NewLayer {
        name=nextLayerName,
        tilemap=tilemap,
        gridBounds=gridbounds,
        top=top
    }

    return nextLayerName
end

function SpriteUtilsProperties.createSpriteWithPropertiesReturnDrawingLayerProperties(
    halfTileWidth,
    halfTileHeight,
    drawingLayerName
)
    local tileProperties = TileProperties.new(halfTileWidth, halfTileHeight)
    app.sprite = tileProperties:NewSprite()

    local actualDrawingLayerName = SpriteUtilsProperties.createNewLayer(
        drawingLayerName,
        true,
        Rectangle(0, 0, halfTileWidth, halfTileHeight),
        true
    )

    local layer = LayerProperties.searchForLayerByName(actualDrawingLayerName)
    local layerProperties = LayerProperties.new(layer)
    layerProperties:UpdateLayerProperties()

    return layerProperties
end

return SpriteUtilsProperties