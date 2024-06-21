local TileProperties = dofile("./tile_properties.lua")
local LayerProperties = {
    layerTypes = {
        DRAWING_LAYER = 2,
        REFERENCE_LAYER = 1
    }
}

function LayerProperties.new(
    layer,
    layerType
)
    if layerType == nil then
        layerType = LayerProperties.DRAWING_LAYER
    end

    local LayerPropertiesObject = {
        layerType = layerType,
        layer = layer
    }

    function LayerPropertiesObject:UpdateLayerProperties()
        if self.layer ~= nil then
            self.layer.properties.layerType = layerType
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
            self.layer.properties.layerType = nil
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
    if layer ~= nil and layer.properties ~= nil and layer.properties.layerType ~= nil then
        return LayerProperties.new(layer, layer.properties.layerType)
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

function LayerProperties.searchForLayerByType(layerType)
    if app.sprite == nil then
        return nil
    end
    local searchLayers 
    searchLayers = function(layers)
        for _,layer in ipairs(layers) do
            if layer.properties ~= nil and layer.properties.layerType == layerType then
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

function LayerProperties.searchForLayersByType(layerType)
    if app.sprite == nil then
        return nil
    end
    local foundLayers = {}
    local index = 1
    local searchLayers 
    searchLayers = function(layers)
        for _,layer in ipairs(layers) do
            if layer.properties ~= nil and layer.properties.layerType == layerType then
                foundLayers[index] = layer
                index = index + 1
            end
            if layer.isGroup then
                local subLayerSearch = searchLayers(layer.layers)
                for _, subLayer in ipairs(subLayerSearch) do
                    foundLayers[index] = subLayer
                    index = index + 1
                end
            end
        end
        return foundLayers
    end
    return searchLayers(app.sprite.layers)
end

function LayerProperties.createNewLayer(
    layerName,
    tilemap,
    gridbounds,
    top,
    before,
    fromClipboard
)
    if fromClipboard == nil then
        fromClipboard = false
    end
    if before == nil then
        before = false
    end
    if top == nil then
        top = true
    end
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
        top=top,
        fromClipboard=fromClipboard,
        before=before
    }

    return nextLayerName
end

function LayerProperties.createLayerFromSpriteReturnLayerPropertiesObject(
    layerName,
    layerType,
    tilemap,
    top,
    before,
    fromClipboard
)
    if app.sprite == nil then
        return
    end
    local tileProperties = TileProperties.getFromSprite(app.sprite)
    if not tileProperties.isValid then
        return
    end
    if tilemap == nil then
        tilemap = true
    end

    local actualDrawingLayerName = LayerProperties.createNewLayer(
        layerName,
        tilemap,
        Rectangle(0, 0, tileProperties.halfTileWidth, tileProperties.halfTileHeight),
        top,
        before,
        fromClipboard
    )

    local layer = LayerProperties.searchForLayerByName(actualDrawingLayerName)
    local layerProperties = LayerProperties.new(layer, layerType)
    layerProperties:UpdateLayerProperties()

    return layerProperties
end

return LayerProperties