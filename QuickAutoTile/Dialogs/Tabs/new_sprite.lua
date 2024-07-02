local LayerProperties = dofile("../../Utility/Sprite/layer_properties.lua")
local SpriteUtilsProperties = dofile("../../Utility/Sprite/properties.lua")
local DefaultTileMap = dofile("../../Utility/Drawing/default_tile_map.lua")
local DrawingFunctions = dofile("../../CopyOfBaseCode/Utility/Drawing/functions.lua")
local PauseForMirrorStepDialog = dofile("../pause_for_mirror_step.lua")

local constants = {
    NEW_SPRITE_TAB_ID = "qat_new_sprite_tab",
    NEW_SPRITE_BUTTON_ID = "qat_new_sprite_button",
    NEW_SPRITE_DRAWING_LABEL_ID = "qat_new_sprite_drawing_label",
    NEW_SPRITE_HALF_TILE_WIDTH_ID = "qat_new_sprite_half_tile_width",
    NEW_SPRITE_HALF_TILE_HEIGHT_ID = "qat_new_sprite_half_tile_height",
    NEW_SPRITE_PAUSE_FOR_MIRROR_STEP_CHECK_ID = "qat_new_sprite_pause_for_mirror"
}

local QuickAutoTileActionsNewSpriteTab = {
    dialog = nil,
    drawingLayerName = "Drawing",
    halfTileWidth = 18,
    halfTileHeight = 18,
    constants = constants,
    pauseForMirrorStep = false,
    drawingLayerProperties = nil,
}

function QuickAutoTileActionsNewSpriteTab:MakeNewSprite()
    self.drawingLayerProperties = SpriteUtilsProperties.createSpriteWithPropertiesReturnDrawingLayerProperties(self.halfTileWidth, self.halfTileHeight, self.drawingLayerName)
end

function QuickAutoTileActionsNewSpriteTab:DrawDrawingLayer()
    DefaultTileMap:draw(self.halfTileWidth, self.halfTileHeight, self.drawingLayerProperties.layer,  DefaultTileMap.constants.selectActionTypes.SELECT_AND_CUT)
end

function QuickAutoTileActionsNewSpriteTab:MakeReferenceLayer()
    local tilemap = false
    local top = false
    local before = true
    local fromClipboard = true
    app.layer = self.drawingLayerProperties.layer
    local refLayerProperties = LayerProperties.createLayerFromSpriteReturnLayerPropertiesObject(LayerProperties.constants.REFERENCE_LAYER_NAME, LayerProperties.constants.REFERENCE_LAYER_TYPE, tilemap, top, before, fromClipboard)
    app.layer = refLayerProperties.layer
    app.command.LayerLock()
    app.layer = self.drawingLayerProperties.layer
    DrawingFunctions.switchToPencil(self.drawingLayerProperties.layer)
end

function QuickAutoTileActionsNewSpriteTab:Init(dialog)
    PauseForMirrorStepDialog:Init()
    self.dialog = dialog
    self.dialog:tab {
        id = constants.NEW_SPRITE_TAB_ID,
        text = "New Sprite"
    }
    self.dialog:entry {
        id = constants.NEW_SPRITE_DRAWING_LABEL_ID,
        label = "Tilemap Layer Name",
        value = self.drawingLayerName,
        text = self.drawingLayerName,
        onchange = function()
            self.drawingLayerName = self.dialog.data[constants.NEW_SPRITE_DRAWING_LABEL_ID]
        end
    }

    self.dialog:number {
        id = constants.NEW_SPRITE_HALF_TILE_WIDTH_ID,
        label = "Half Tile Width",
        decimals = 0,
        value = self.halfTileWidth,
        text = tostring(self.halfTileWidth),
        onchange = function()
            self.halfTileWidth = self.dialog.data[constants.NEW_SPRITE_HALF_TILE_WIDTH_ID]
        end
    }

    self.dialog:number {
        id = constants.NEW_SPRITE_HALF_TILE_HEIGHT_ID,
        label = "Half Tile Height",
        decimals = 0,
        value = self.halfTileHeight,
        text = tostring(self.halfTileHeight),
        onchange = function()
            self.halfTileHeight = self.dialog.data[constants.NEW_SPRITE_HALF_TILE_HEIGHT_ID]
        end
    }
    
    self.dialog:check{
        id = constants.NEW_SPRITE_PAUSE_FOR_MIRROR_STEP_CHECK_ID,
        label = "Pause To Set Tilemap Allowed Flips",
        selected = self.pauseForMirrorStep,
        onclick = function()
            self.pauseForMirrorStep = self.dialog.data[constants.NEW_SPRITE_PAUSE_FOR_MIRROR_STEP_CHECK_ID]
        end
    }

    self.dialog:button{
        id = constants.NEW_SPRITE_BUTTON_ID,
        label = "Create New Autotile Sprite",
        text = "Create Sprite",
        selected = false,
        focus = false,
        onclick = function()
            self.drawingLayerProperties = nil
            QuickAutoTileActionsNewSpriteTab:MakeNewSprite()
            local afterTilesetProperties = function()
                app.transaction(
                    "Build Drawing Layer Tile Set",
                    function()
                        QuickAutoTileActionsNewSpriteTab:DrawDrawingLayer()
                    end
                )
                app.transaction(
                    "Make Reference Layer",
                    function()
                        QuickAutoTileActionsNewSpriteTab:MakeReferenceLayer()
                    end
                )
            end
            if self.pauseForMirrorStep then
                PauseForMirrorStepDialog:Open(afterTilesetProperties, self.drawingLayerName)
            else
                afterTilesetProperties()
            end
        end
    }
end

function QuickAutoTileActionsNewSpriteTab:Update()
end

return QuickAutoTileActionsNewSpriteTab