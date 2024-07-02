local TileProperties = {}

function TileProperties.new(
    halfTileWidth,
    halfTileHeight,
    isValid
)
    if halfTileWidth == nil then
        halfTileWidth = 0
    end
    if halfTileHeight == nil then
        halfTileHeight = 0
    end
    if isValid == nil then
        isValid = halfTileWidth >= 2
    end
    local TilePropertiesObject = {
        halfTileWidth = halfTileWidth,
        halfTileHeight = halfTileHeight,
        tileWidth = halfTileWidth * 2,
        tileHeight = halfTileHeight * 2,
        canvasWidth = halfTileWidth * 24,
        canvasHeight = halfTileHeight * 16,
        halfCanvasHeight = halfTileHeight * 8,
        isValid = isValid,
    }

    function TilePropertiesObject:NewSprite()
        if not self.isValid then
            app.alert{ title="User Input Error",
                text="Half Tile Width and Half Tile Height must be Greater than or equal to 2"}
            return nil
        end
        local sprite = Sprite(self.canvasWidth, self.canvasHeight)
        self:SetSpriteProperties(sprite)
        return sprite
    end

    function TilePropertiesObject:UpdateSprite(sprite)
        if not self.isValid then
            app.alert{ title="User Input Error",
                text="Half Tile Width and Half Tile Height must be Greater than or equal to 2"}
            return nil
        end
        if sprite ~= nil then
            sprite:resize(self.canvasWidth, self.canvasHeight)
            self:SetSpriteProperties(sprite)
            return sprite
        else
            return nil
        end
    end

    function TilePropertiesObject:SetSpriteProperties(sprite)
        sprite.properties.halfTileWidth = self.halfTileWidth
        sprite.properties.halfTileHeight = self.halfTileHeight
    end

    return TilePropertiesObject
end

function TileProperties.clone(other)
    return TileProperties.new(other.halfTileWidth, other.halfTileHeight)
end

function TileProperties.getFromSprite(sprite)
    if sprite ~= nil and sprite.properties ~= nil and sprite.properties.halfTileWidth ~= nil and sprite.properties.halfTileHeight ~= nil then
        return TileProperties.new(sprite.properties.halfTileWidth, sprite.properties.halfTileHeight)
    end
    return TileProperties.new()
end

return TileProperties