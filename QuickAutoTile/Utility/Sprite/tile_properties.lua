local TileProperties = {}

function TileProperties.new(
    halfTileWidth,
    halfTileHeight
)
    local TilePropertiesObject = {
        halfTileWidth = halfTileWidth,
        halfTileHeight = halfTileHeight,
        tileWidth = halfTileWidth * 2,
        tileHeight = halfTileHeight * 2,
        canvasWidth = halfTileWidth * 24,
        canvasHeight = halfTileHeight * 16
    }

    function TilePropertiesObject:NewSprite()
        local sprite = Sprite(self.canvasWidth, self.canvasHeight)
        self:SetSpriteProperties(sprite)
        return sprite
    end

    function TilePropertiesObject:UpdateSprite(sprite)
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
    if sprite.properties.halfTileWidth ~= nil and sprite.properties.halfTileHeight ~= nil then
        return TileProperties.new(sprite.properties.halfTileWidth, sprite.properties.halfTileHeight)
    end
    return nil
end

return TileProperties