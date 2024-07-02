local LayerProperties = dofile("../../Utility/Sprite/layer_properties.lua")
local TileProperties = dofile("../../Utility/Sprite/tile_properties.lua")
local DefaultTileMap = dofile("../../Utility/Drawing/default_tile_map.lua")
local DrawingFunctions = dofile("../../CopyOfBaseCode/Utility/Drawing/functions.lua")
local PauseForMirrorStepDialog = dofile("../pause_for_mirror_step.lua")

local constants = {
    LAYER_ACTIONS_SECTION_BEGIN_SEPARATOR_ID = "qat_layer_actions_begin_section",
    LAYER_ACTIONS_REINITIALIZE_BUTTON_ID = "qat_layer_actions_reinitialize",
    LAYER_ACTIONS_FORCE_NEW_REFERENCE_LAYER_ID = "qat_layer_actions_force_new_reference",
    LAYER_ACTIONS_REFERENCE_LAYER_WARNING_ID_PREFIX = "qat_layer_actions_reference_layer_warning_id_",
    LAYER_ACTIONS_PAUSE_FOR_MIRROR_STEP_CHECK_ID = "qat_layer_actions_pause_for_mirror_step",
    LAYER_ACTIONS_TEMP_LAYER_NAME = "temp"
}

local QuickAutoTileActionsLayerActionsSection = {
    constants = constants,
    dialog = nil,
    layer = nil,
    forceNewReference = false,
    pauseForMirrorStep = false
}

function QuickAutoTileActionsLayerActionsSection:CheckAndMakeNewReferenceLayer(referenceLayer, switchToLayer)
    local tileProperties = TileProperties.getFromSprite(app.sprite)
    if not tileProperties.isValid then
        return
    end

    local referenceLayers = LayerProperties.searchForLayersByType(LayerProperties.constants.REFERENCE_LAYER_TYPE)

    local referenceLayerProperties = referenceLayers[1]
    if #referenceLayers == nil or #referenceLayers > 1 or self.forceNewReference then
        -- Clear any previous reference layer_properties
        for _, referenceLayerInfo in ipairs(referenceLayers) do
            referenceLayerInfo:ClearLayerProperties()
        end

        if referenceLayer ~= nil then
            app.layer = referenceLayer
            if not referenceLayer.isEditable then
                app.command.LayerLock()
            end
            referenceLayerProperties = LayerProperties.new(referenceLayer, LayerProperties.constants.REFERENCE_LAYER_TYPE)
            referenceLayerProperties:UpdateLayerProperties()
            DrawingFunctions.selectAll(DrawingFunctions.constants.selectActionTypes.SELECT_AND_CLEAR, referenceLayer)
        else
            local tilemap = false
            local top = false
            local before = true
            local fromClipboard = false
            referenceLayerProperties = LayerProperties.createLayerFromSpriteReturnLayerPropertiesObject(LayerProperties.constants.REFERENCE_LAYER_NAME, LayerProperties.constants.REFERENCE_LAYER_TYPE, tilemap, top, before, fromClipboard)
            app.layer = referenceLayerProperties.layer
        end
        DefaultTileMap:draw(tileProperties.halfTileWidth, tileProperties.halfTileHeight, referenceLayerProperties.layer,  DefaultTileMap.constants.selectActionTypes.SELECT_ONLY)
        app.command.LayerLock()
        app.layer = switchToLayer
        DrawingFunctions.switchToPencil(switchToLayer)
    end

    return referenceLayerProperties
end

function QuickAutoTileActionsLayerActionsSection:RedrawDrawingLayerBeforeFlip(referenceLayerProperties, drawingLayer)
    if drawingLayer == nil or referenceLayerProperties == nil or app.sprite == nil then
        return
    end
    local tileProperties = TileProperties.getFromSprite(app.sprite)
    if not tileProperties.isValid then
        return
    end
    if not referenceLayerProperties.layer.isEditable then
        app.command.LayerLock()
    end
    if not drawingLayer.isEditable then
        app.command.LayerLock()
    end

    -- Start on this Drawing Layer
    app.layer = drawingLayer
    -- Make it so tiles will be deleted
    app.command.TilesetMode{mode="auto"}
    DrawingFunctions.selectAll(DrawingFunctions.constants.selectActionTypes.SELECT_AND_CUT, drawingLayer)
    local tilemap = false
    local top = true
    local before = true
    local fromClipboard = true
    -- Create temp layer from clipboard
    local tempLayerProperties = LayerProperties.createLayerFromSpriteReturnLayerPropertiesObject(constants.LAYER_ACTIONS_TEMP_LAYER_NAME, LayerProperties.constants.DRAWING_LAYER_TYPE, tilemap, top, before, fromClipboard)
    -- Move to temp layer
    app.layer = tempLayerProperties.layer
    -- Switch to pencil on temp layer to solidify paste
    DrawingFunctions.switchToPencil(tempLayerProperties.layer)
    return tempLayerProperties
end

function QuickAutoTileActionsLayerActionsSection:RedrawDrawingLayerAfterFlip(referenceLayerProperties, drawingLayer, tempLayerProperties)
    -- Move to reference layer
    app.layer = referenceLayerProperties.layer
    -- Copy reference Layer
    DrawingFunctions.selectAll(DrawingFunctions.constants.selectActionTypes.SELECT_AND_COPY, referenceLayerProperties.layer)
    -- Move back to drawing layer
    app.layer = drawingLayer
    -- Paste reference layer
    app.command.Paste()
    -- Switch back to the mode so new tiles won't be deleted
    app.command.TilesetMode{mode="manual"}
    -- Clear drawing layer keeping tiles
    DrawingFunctions.selectAll(DrawingFunctions.constants.selectActionTypes.SELECT_AND_CLEAR, drawingLayer)
    -- Switch back to temp layer
    app.layer = tempLayerProperties.layer
    -- Select all and cut from temp
    DrawingFunctions.selectAll(DrawingFunctions.constants.selectActionTypes.SELECT_AND_CUT, tempLayerProperties.layer)
    -- Switch back to drawing layer
    app.layer = drawingLayer
    -- Paste temp layer back on drawing layer
    app.command.Paste()
    -- Switch back to pencil on drawing layer
    DrawingFunctions.switchToPencil(drawingLayer)
    -- Delete temp layer
    app.sprite:deleteLayer(tempLayerProperties.layer)
end

function QuickAutoTileActionsLayerActionsSection:Init(dialog)
    PauseForMirrorStepDialog:Init()
    self.dialog = dialog
    self.dialog:separator {
        id = constants.LAYER_ACTIONS_SECTION_BEGIN_SEPARATOR_ID,
        text = "Active Layer"
    }
    
    self.dialog:check{
        id = constants.LAYER_ACTIONS_PAUSE_FOR_MIRROR_STEP_CHECK_ID,
        label = "Pause To Set Tilemap Allowed Flips",
        selected = self.pauseForMirrorStep,
        onclick = function()
            self.pauseForMirrorStep = self.dialog.data[constants.LAYER_ACTIONS_PAUSE_FOR_MIRROR_STEP_CHECK_ID]
        end
    }

    self.dialog:label{
        id = constants.LAYER_ACTIONS_REFERENCE_LAYER_WARNING_ID_PREFIX .. "1",
        label = "Warning:",
        text = "Reference layer will be used to make the new layer,"
    }

    self.dialog:label{
        id = constants.LAYER_ACTIONS_REFERENCE_LAYER_WARNING_ID_PREFIX .. "2",
        label = "",
        text = "if you made any changes to it, check the flag below"
    }

    self.dialog:label{
        id = constants.LAYER_ACTIONS_REFERENCE_LAYER_WARNING_ID_PREFIX .. "3",
        label = "",
        text = "to remove it as the reference layer and create"
    }

    self.dialog:label{
        id = constants.LAYER_ACTIONS_REFERENCE_LAYER_WARNING_ID_PREFIX .. "4",
        label = "",
        text = "a new reference layer automatically."
    }
    
    self.dialog:check{
        id = constants.LAYER_ACTIONS_FORCE_NEW_REFERENCE_LAYER_ID,
        label = "Force new reference layer",
        selected = self.forceNewReference,
        onclick = function()
            self.forceNewReference = self.dialog.data[constants.LAYER_ACTIONS_FORCE_NEW_REFERENCE_LAYER_ID]
        end
    }

    self.dialog:button{
        id = constants.LAYER_ACTIONS_REINITIALIZE_BUTTON_ID,
        label = "Reinitialize Drawing Layer",
        text = "Reinitialize",
        selected = false,
        focus = false,
        onclick = function()
            if self.layer == nil then
                return
            end
            local actionLayer = self.layer
            if actionLayer.properties.layerType == LayerProperties.constants.REFERENCE_LAYER_TYPE then
                app.transaction(
                    "Reinitialize Reference Layer",
                    function()
                        QuickAutoTileActionsLayerActionsSection:CheckAndMakeNewReferenceLayer(actionLayer, actionLayer)
                    end
                )
            elseif actionLayer.properties.layerType == LayerProperties.constants.DRAWING_LAYER_TYPE then
                local referenceLayerProperties = nil
                app.transaction(
                    "Reinitialize Reference Layer",
                    function()
                        referenceLayerProperties = QuickAutoTileActionsLayerActionsSection:CheckAndMakeNewReferenceLayer(nil, actionLayer)
                    end
                )

                local tempLayerProperties = nil
                app.transaction(
                    "Reinitialize Reference Layer",
                    function()
                        tempLayerProperties = QuickAutoTileActionsLayerActionsSection:RedrawDrawingLayerBeforeFlip(referenceLayerProperties, actionLayer)
                    end
                )

                local afterTilesetProperties = function()
                    app.transaction(
                        "Reinitialize Reference Layer",
                        function()
                            tempLayerProperties = QuickAutoTileActionsLayerActionsSection:RedrawDrawingLayerAfterFlip(referenceLayerProperties, actionLayer, tempLayerProperties)
                        end
                    )
                end

                if self.pauseForMirrorStep then
                    PauseForMirrorStepDialog:Open(afterTilesetProperties, actionLayer.name)
                else
                    afterTilesetProperties()
                end
            end
        end
    }
end

function QuickAutoTileActionsLayerActionsSection:ModifyDialog(options)
    if options == nil then
        options = {}
    end
    self.dialog:modify{
        id = constants.LAYER_ACTIONS_SECTION_BEGIN_SEPARATOR_ID,
        visible = options.showSeparator ~= nil and options.showSeparator,
        enabled = options.showSeparator ~= nil and options.showSeparator,
        text = (options.name ~= nil and options.name or "Active Layer") .. " - " .. (options.layerTypeText ~= nil and options.layerTypeText or "Not Initialized")
    }

    self.dialog:modify{
        id = constants.LAYER_ACTIONS_REINITIALIZE_BUTTON_ID,
        visible = options.showReinitializeButton ~= nil and options.showReinitializeButton,
        enabled = options.showReinitializeButton ~= nil and options.showReinitializeButton,
        label = "Reinitialize " .. (options.layerTypeText ~= nil and options.layerTypeText or "Not Initialized")
    }

    self.dialog:modify{
        id = constants.LAYER_ACTIONS_PAUSE_FOR_MIRROR_STEP_CHECK_ID,
        visible = options.showMirrorStepCheckbox ~= nil and options.showMirrorStepCheckbox,
        enabled = options.showMirrorStepCheckbox ~= nil and options.showMirrorStepCheckbox,
    }

    self.forceNewReference = false
    self.dialog:modify{
        id = constants.LAYER_ACTIONS_FORCE_NEW_REFERENCE_LAYER_ID,
        visible = options.showForceWarningMessage ~= nil and options.showForceWarningMessage,
        enabled = options.showForceWarningMessage ~= nil and options.showForceWarningMessage,
        selected = false
    }
    for i=1,4 do
        self.dialog:modify{
            id = constants.LAYER_ACTIONS_REFERENCE_LAYER_WARNING_ID_PREFIX .. tostring(i),
            visible = options.showForceWarningMessage ~= nil and options.showForceWarningMessage,
            enabled = options.showForceWarningMessage ~= nil and options.showForceWarningMessage
        }
    end
end

function QuickAutoTileActionsLayerActionsSection:Update()
    self.layer = app.layer
    if app.sprite == nil or self.layer == nil or self.layer.properties.layerType == nil then
        self:ModifyDialog()
    elseif self.layer.properties.layerType == LayerProperties.constants.DRAWING_LAYER_TYPE then
        self:ModifyDialog{
            showSeparator = true,
            showReinitializeButton = true,
            name = self.layer.name,
            layerTypeText = "Drawing Layer",
            showForceWarningMessage = true,
            showMirrorStepCheckbox = true,
        }
    elseif self.layer.properties.layerType == LayerProperties.constants.REFERENCE_LAYER_TYPE then
        self:ModifyDialog{
            showSeparator = true,
            showReinitializeButton = true,
            name = self.layer.name,
            layerTypeText = "Reference Layer"
        }
        self.forceNewReference = true
    else
        self:ModifyDialog()
    end
end

return QuickAutoTileActionsLayerActionsSection