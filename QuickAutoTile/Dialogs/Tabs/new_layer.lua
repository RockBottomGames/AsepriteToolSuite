local LayerProperties = dofile("../../Utility/Sprite/layer_properties.lua")
local TileProperties = dofile("../../Utility/Sprite/tile_properties.lua")
local DefaultTileMap = dofile("../../Utility/Drawing/default_tile_map.lua")
local DrawingFunctions = dofile("../../CopyOfBaseCode/Utility/Drawing/functions.lua")
local PauseForMirrorStepDialog = dofile("../pause_for_mirror_step.lua")

local constants = {
    NEW_LAYER_TAB_ID = "qat_new_layer_tab",
    NEW_LAYER_BUTTON_ID = "qat_new_layer_button",
    NEW_LAYER_DRAWING_LABEL_ID = "qat_new_layer_drawing_label",
    NEW_LAYER_HALF_TILE_WIDTH_ID = "qat_new_layer_half_tile_width",
    NEW_LAYER_HALF_TILE_HEIGHT_ID = "qat_new_layer_half_tile_height",
    NEW_LAYER_PAUSE_FOR_MIRROR_STEP_CHECK_ID = "qat_new_layer_pause_for_mirror_step",
    NEW_LAYER_FORCE_NEW_REFERENCE_LAYER_ID = "qat_new_layer_force_new_reference",
    NEW_LAYER_REFERENCE_LAYER_WARNING_ID_PREFIX = "qat_new_layer_reference_layer_warning_id_"
}

local QuickAutoTileActionsNewLayerTab = {
    dialog = nil,
    drawingLayerName = "Drawing",
    tempLayerName = "Temp",
    constants = constants,
    previousValid = nil,
    pauseForMirrorStep = false,
    forceNewReference = false,
    drawingLayerProperties = nil,
    referenceLayerProperties = nil,
    previousSprite = nil
}

function QuickAutoTileActionsNewLayerTab:MakeNewReferenceLayer(previousReferenceLayers)
    local tileProperties = TileProperties.getFromSprite(app.sprite)
    if not tileProperties.isValid then
        return
    end
    -- Clear any previous reference layer_properties
    for _, referenceLayerInfo in ipairs(previousReferenceLayers) do
        referenceLayerInfo:ClearLayerProperties()
    end
    
    local tilemap = false
    local top = false
    local before = true
    local fromClipboard = false
    self.referenceLayerProperties = LayerProperties.createLayerFromSpriteReturnLayerPropertiesObject(LayerProperties.constants.REFERENCE_LAYER_NAME, LayerProperties.constants.REFERENCE_LAYER_TYPE, tilemap, top, before, fromClipboard)
    app.layer = self.referenceLayerProperties.layer
    DefaultTileMap:draw(tileProperties.halfTileWidth, tileProperties.halfTileHeight, self.referenceLayerProperties.layer,  DefaultTileMap.constants.selectActionTypes.SELECT_ONLY)
    app.command.LayerLock()
end

function QuickAutoTileActionsNewLayerTab:MakeNewDrawingLayer()
    local tilemap = true
    local top = true
    local before = false
    local fromClipboard = false
    self.drawingLayerProperties = LayerProperties.createLayerFromSpriteReturnLayerPropertiesObject(self.drawingLayerName, LayerProperties.constants.DRAWING_LAYER_TYPE, tilemap, top, before, fromClipboard)
end

function QuickAutoTileActionsNewLayerTab:BuildTileSet()
    app.layer = self.drawingLayerProperties.layer
    DefaultTileMap:copyFromReferenceLayer(self.drawingLayerProperties.layer, self.referenceLayerProperties.layer)
    DrawingFunctions.switchToPencil(self.drawingLayerProperties.layer)
end

function QuickAutoTileActionsNewLayerTab:Init(dialog)
    PauseForMirrorStepDialog:Init()
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
    
    self.dialog:check{
        id = constants.NEW_LAYER_PAUSE_FOR_MIRROR_STEP_CHECK_ID,
        label = "Pause To Set Tilemap Allowed Flips",
        selected = self.pauseForMirrorStep,
        onclick = function()
            self.pauseForMirrorStep = self.dialog.data[constants.NEW_LAYER_PAUSE_FOR_MIRROR_STEP_CHECK_ID]
        end
    }

    self.dialog:label{
        id = constants.NEW_LAYER_REFERENCE_LAYER_WARNING_ID_PREFIX .. "1",
        label = "Warning:",
        text = "Reference layer will be used to make the new layer,"
    }

    self.dialog:label{
        id = constants.NEW_LAYER_REFERENCE_LAYER_WARNING_ID_PREFIX .. "2",
        label = "",
        text = "if you made any changes to it, check the flag below"
    }

    self.dialog:label{
        id = constants.NEW_LAYER_REFERENCE_LAYER_WARNING_ID_PREFIX .. "3",
        label = "",
        text = "to remove it as the reference layer and create"
    }

    self.dialog:label{
        id = constants.NEW_LAYER_REFERENCE_LAYER_WARNING_ID_PREFIX .. "4",
        label = "",
        text = "a new reference layer automatically."
    }
    
    self.dialog:check{
        id = constants.NEW_LAYER_FORCE_NEW_REFERENCE_LAYER_ID,
        label = "Force new reference layer",
        selected = self.forceNewReference,
        onclick = function()
            self.forceNewReference = self.dialog.data[constants.NEW_LAYER_FORCE_NEW_REFERENCE_LAYER_ID]
        end
    }

    self.dialog:button{
        id = constants.NEW_LAYER_BUTTON_ID,
        label = "Create New Autotile Layer",
        text = "Create Layer",
        selected = false,
        focus = false,
        onclick = function()
            local tileProperties = TileProperties.getFromSprite(app.sprite)
            if not tileProperties.isValid then
                return
            end
            local referenceLayers = LayerProperties.searchForLayersByType(LayerProperties.constants.REFERENCE_LAYER_TYPE)
            self.referenceLayerProperties = nil
            self.referenceLayerProperties = referenceLayers[1]
            if self.forceNewReference or self.referenceLayerProperties == nil or #referenceLayers > 1 then
                app.transaction(
                    "Make Reference Layer",
                    function()
                        QuickAutoTileActionsNewLayerTab:MakeNewReferenceLayer(referenceLayers)
                    end
                )
            end
            app.transaction(
                "Make Drawing Layer",
                function()
                    QuickAutoTileActionsNewLayerTab:MakeNewDrawingLayer()
                end
            )
            local afterTilesetProperties = function()
                app.transaction(
                    "Build Drawing Layer Tile Set",
                    function()
                        QuickAutoTileActionsNewLayerTab:BuildTileSet()
                    end
                )
                if self.forceNewReference then
                    self.forceNewReference = false
                    self.dialog:modify{
                        id = constants.NEW_LAYER_FORCE_NEW_REFERENCE_LAYER_ID,
                        selected = self.forceNewReference
                    }
                end
            end
            if self.pauseForMirrorStep then
                PauseForMirrorStepDialog:Open(afterTilesetProperties, self.drawingLayerName)
            else
                afterTilesetProperties()
            end
        end
    }
end

function QuickAutoTileActionsNewLayerTab:Update()
    if self.previousSprite == nil or app.sprite ~= self.previousSprite then
        self.previousSprite = app.sprite
        -- Clear the force new perspective flag when switching sprites
        if self.forceNewReference then
            self.forceNewReference = false
            self.dialog:modify{
                id = constants.NEW_LAYER_FORCE_NEW_REFERENCE_LAYER_ID,
                selected = self.forceNewReference
            }
        end
    end
    local tileProperties = TileProperties.getFromSprite(app.sprite)
    if self.previousValid == tileProperties.isValid then
        return
    end
    self.previousValid = tileProperties.isValid
    if not self.previousValid then
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