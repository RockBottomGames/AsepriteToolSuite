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

    local layerProperties = LayerProperties.searchForLayerByName(actualDrawingLayerName, LayerProperties.constants.DRAWING_LAYER_TYPE)
    layerProperties:UpdateLayerProperties()

    return layerProperties
end

return SpriteUtilsProperties