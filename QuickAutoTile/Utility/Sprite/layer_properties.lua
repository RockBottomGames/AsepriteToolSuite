local TileProperties = dofile("./tile_properties.lua")
local LayerProperties = {}

function LayerProperties.new(
    layer
)
    local LayerPropertiesObject = {
        isDrawingLayer = true,
        layer = layer
    }

    function LayerPropertiesObject:UpdateLayerProperties()
        if self.layer ~= nil then
            self.layer.properties.isDrawingLayer = true
        end
    end

    function LayerPropertiesObject:SetLayerProperties(layer)
        self:ClearLayerProperties()
        self.layer = layer
        self:UpdateLayerProperties()
    end

    function LayerPropertiesObject:ClearLayerProperties()
        if self.layer ~= nil then
            self.layer.properties.isDrawingLayer = nil
        end
        self.layer = nil
    end

    return LayerPropertiesObject
end

function LayerProperties.clone(other)
    return LayerProperties.new(other.layer)
end

function LayerProperties.getFromLayer(layer)
    if layer ~= nil and layer.properties ~= nil and layer.properties.isDrawingLayer then
        return LayerProperties.new(layer)
    end
    return nil
end

function LayerProperties.searchForLayerByName(name)
    if app.sprite == nil then
        return nil
    end
    local searchLayers 
    searchLayers = function(layers)
        for _,layer in ipairs(layers) do
            if layer.name == name then
                return layer
            end
            if layer.isGroup then
                local subLayerSearch = searchLayers(layer.layers)
                if subLayerSearch ~= nil then
                    return subLayerSearch
                end
            end
        end
        return nil
    end
    return searchLayers(app.sprite.layers)
end

function LayerProperties.createNewLayer(
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

function LayerProperties.createLayerFromSpriteReturnDrawingLayerProperties(
    drawingLayerName
)
    if app.sprite == nil then
        return
    end
    local tileProperties = TileProperties.getFromSprite(app.sprite)
    if not tileProperties.isValid then
        return
    end

    local actualDrawingLayerName = LayerProperties.createNewLayer(
        drawingLayerName,
        true,
        Rectangle(0, 0, tileProperties.halfTileWidth, tileProperties.halfTileHeight),
        true
    )

    local layer = LayerProperties.searchForLayerByName(actualDrawingLayerName)
    local layerProperties = LayerProperties.new(layer)
    layerProperties:UpdateLayerProperties()

    return layerProperties
end

return LayerProperties