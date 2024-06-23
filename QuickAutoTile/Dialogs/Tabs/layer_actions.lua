local constants = {
    LAYER_ACTIONS_TAB_SET_ID = "qat_layer_actions_tab_set",
    LAYER_ACTIONS_TAB_ID = "qat_layer_actions_",
    LAYER_ACTIONS_BUTTON_ID = "qat_layer_actions_",
    DRAWING_LAYER_TYPE_ID = 2,
    -- LAYER_ACTIONS_DRAWING_LABEL_ID = "qat_new_layer_drawing_label",
    -- LAYER_ACTIONS_HALF_TILE_WIDTH_ID = "qat_new_layer_half_tile_width",
    -- LAYER_ACTIONS_HALF_TILE_HEIGHT_ID = "qat_new_layer_half_tile_height",
}

local QuickAutoTileActionsLayerActionsTab = {}

function QuickAutoTileActionsLayerActionsTab.createAndInit(dialog, index)
    local LayerActionsTab = {
        constants = constants,
        index = index,
        layer = nil,
        dialog = dialog
    }

    function LayerActionsTab:Init()
        self.dialog:tab {
            id = constants.LAYER_ACTIONS_TAB_ID .. tostring(self.index),
            text = self.layer ~= nil and self.layer.name or "Placeholder " .. self.index
        }

        self.dialog:button{
            id = constants.LAYER_ACTIONS_BUTTON_ID .. tostring(self.index),
            label = "Reinitialize Layer",
            text = "Reinitialize",
            selected = false,
            focus = false,
            onclick = function()
                print("This is where I reinitialize the layer.")
                print(self.layer.name, " this layer.")
                -- local drawingLayerProperties
                -- drawingLayerProperties = LayerProperties.createLayerFromSpriteReturnLayerPropertiesObject(self.drawingLayerName)
                -- local tileProperties = TileProperties.getFromSprite(app.sprite)
                -- if not tileProperties.isValid then
                --     self.dialog:modify{
                --         id=constants.NEW_LAYER_TAB_ID,
                --         visible=false,
                --         enabled=false
                --     }
                --     return
                -- end
                
                -- app.transaction(
                --     "Draw starting tiles",
                --     function()
                --         DefaultTileMap:draw(tileProperties.halfTileWidth, tileProperties.halfTileHeight, drawingLayerProperties.layer)
                --     end
                -- )
            end
        }
    end

    function LayerActionsTab:Update(layer)
        if self.layer == layer then
            return
        end
        self.layer = layer
        if layer == nil then
            self.dialog:modify{
                id = constants.LAYER_ACTIONS_TAB_ID .. tostring(self.index),
                visible = false,
                enabled = false
            }
            return
        end
        self.dialog:modify{
            id = constants.LAYER_ACTIONS_TAB_ID .. tostring(self.index),
            visible = true,
            enabled = true,
            text = self.layer.name
        }
    end

    LayerActionsTab:Init()

    return LayerActionsTab
end

local QuickAutoTileActionsLayerActionsTabSet = {
    currentCount = 0,
    tabs = {},
    constants = constants,
}

function QuickAutoTileActionsLayerActionsTabSet:Init(dialog)
    for index=1,10 do 
        self.currentCount = self.currentCount + 1
        self.currentMax = self.currentMax + 1
        self.tabs[index] = QuickAutoTileActionsLayerActionsTab.createAndInit(dialog, index)
    end

    self.dialog:endtabs {
        id = constants.LAYER_ACTIONS_TAB_SET_ID,
        selected = constants.LAYER_ACTIONS_TAB_ID .. "1"
    }
end

function QuickAutoTileActionsLayerActionsTabSet:Update()
    self.currentCount = 0
    for _, layer in ipairs(app.sprite.layers) do
        if layer.properties.layerType == constants.DRAWING_LAYER_TYPE_ID then
            self.currentCount = self.currentCount + 1
            self.tabs[self.currentCount]:Update(layer)
        end
    end
    for layerIndex = self.currentCount + 1,10 do
        self.tabs[layerIndex]:Update()
    end
    
    if self.currentCount == 0 then
        self.dialog:modify{
            id = constants.LAYER_ACTIONS_TAB_SET_ID,
            visible = false,
            enabled = false
        }
        return
    end
    self.dialog:modify{
        id = constants.LAYER_ACTIONS_TAB_SET_ID,
        visible = true,
        enabled = true,
    }
end

return QuickAutoTileActionsLayerActionsTabSet