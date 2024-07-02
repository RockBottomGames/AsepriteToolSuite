local TileProperties = dofile("./tile_properties.lua")

local constants = {
    DRAWING_LAYER_TYPE = 2,
    REFERENCE_LAYER_TYPE = 1,
    REFERENCE_LAYER_NAME = "Reference Layer"
}

local LayerProperties = {
    constants = constants
}

function LayerProperties.new(
    layer,
    layerType
)
    if layerType == nil then
        layerType = constants.DRAWING_LAYER_TYPE
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

function LayerProperties.searchForLayerByName(name, layerType)
    if app.sprite == nil then
        return nil
    end
    if layerType == nil then
        layerType = constants.REFERENCE_LAYER_TYPE
    end
    local searchLayers 
    searchLayers = function(layers)
        for _,layer in ipairs(layers) do
            if layer.name == name then
                return LayerProperties.new(layer, layerType)
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
                return LayerProperties.new(layer, layerType)
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
                foundLayers[index] = LayerProperties.new(layer, layerType)
                index = index + 1
            end
            if layer.isGroup then
                local subLayerSearch = searchLayers(layer.layers)
                for _, subLayerProperties in ipairs(subLayerSearch) do
                    foundLayers[index] = subLayerProperties
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

    local actualLayerName = LayerProperties.createNewLayer(
        layerName,
        tilemap,
        Rectangle(0, 0, tileProperties.halfTileWidth, tileProperties.halfTileHeight),
        top,
        before,
        fromClipboard
    )

    local layerProperties = LayerProperties.searchForLayerByName(actualLayerName, layerType)
    layerProperties:UpdateLayerProperties()

    return layerProperties
end

return LayerProperties