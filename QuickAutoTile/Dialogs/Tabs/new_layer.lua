local LayerProperties = dofile("../../Utility/Sprite/layer_properties.lua")
local TileProperties = dofile("../../Utility/Sprite/tile_properties.lua")
local DefaultTileMap = dofile("../../Utility/Drawing/default_tile_map.lua")

local constants = {
    NEW_LAYER_TAB_ID = "qat_new_layer_tab",
    NEW_LAYER_BUTTON_ID = "qat_new_layer_button",
    NEW_LAYER_DRAWING_LABEL_ID = "qat_new_layer_drawing_label",
    NEW_LAYER_HALF_TILE_WIDTH_ID = "qat_new_layer_half_tile_width",
    NEW_LAYER_HALF_TILE_HEIGHT_ID = "qat_new_layer_half_tile_height",
}

local QuickAutoTileActionsNewLayerTab = {
    dialog = nil,
    drawingLayerName = "New Layer",
    constants = constants,
}

function QuickAutoTileActionsNewLayerTab:Init(dialog)
    self.dialog = dialog
    self.dialog:tab {
        id = constants.NEW_LAYER_TAB_ID,
        text = "New Layer"
    }
    self.dialog:entry {
        id = constants.NEW_LAYER_DRAWING_LABEL_ID,
        label = "Tilemap Layer Name",
        value = self.drawingLayerName,
        text = self.drawingLayerName,
        onchange = function()
            self.drawingLayerName = self.dialog.data[constants.NEW_LAYER_DRAWING_LABEL_ID]
        end
    }

    self.dialog:button{
        id = constants.NEW_LAYER_BUTTON_ID,
        label = "Create New Autotile Layer",
        text = "Create Layer",
        selected = false,
        focus = false,
        onclick = function()
            local drawingLayerProperties
            drawingLayerProperties = LayerProperties.createLayerFromSpriteReturnLayerPropertiesObject(self.drawingLayerName)
            local tileProperties = TileProperties.getFromSprite(app.sprite)
            if not tileProperties.isValid then
                self.dialog:modify{
                    id=constants.NEW_LAYER_TAB_ID,
                    visible=false,
                    enabled=false
                }
                return
            end
            
            app.transaction(
                "Draw starting tiles",
                function()
                    DefaultTileMap:draw(tileProperties.halfTileWidth, tileProperties.halfTileHeight, drawingLayerProperties.layer)
                end
            )
        end
    }
end

function QuickAutoTileActionsNewLayerTab:Update()
    local tileProperties = TileProperties.getFromSprite(app.sprite)
    if not tileProperties.isValid then
        self.dialog:modify{
            id=constants.NEW_LAYER_TAB_ID,
            visible=false,
            enabled=false
        }
        return
    end
    self.dialog:modify{
        id=constants.NEW_LAYER_TAB_ID,
        visible=true,
        enabled=true
    }
end

return QuickAutoTileActionsNewLayerTab