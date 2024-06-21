local TileProperties = dofile("./tile_properties.lua")
local LayerProperties = dofile("./layer_properties.lua")
local SpriteUtilsProperties = {}

function SpriteUtilsProperties.createSpriteWithPropertiesReturnDrawingLayerProperties(
    halfTileWidth,
    halfTileHeight,
    drawingLayerName
)
    local tileProperties = TileProperties.new(halfTileWidth, halfTileHeight)
    app.sprite = tileProperties:NewSprite()

    local actualDrawingLayerName = LayerProperties.createNewLayer(
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