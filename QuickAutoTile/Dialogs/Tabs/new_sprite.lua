local LayerProperties = dofile("../../Utility/Sprite/layer_properties.lua")
local SpriteUtilsProperties = dofile("../../Utility/Sprite/properties.lua")
local DefaultTileMap = dofile("../../Utility/Drawing/default_tile_map.lua")

local constants = {
    NEW_SPRITE_TAB_ID = "qat_new_sprite_tab",
    NEW_SPRITE_BUTTON_ID = "qat_new_sprite_button",
    NEW_SPRITE_DRAWING_LABEL_ID = "qat_new_sprite_drawing_label",
    NEW_SPRITE_HALF_TILE_WIDTH_ID = "qat_new_sprite_half_tile_width",
    NEW_SPRITE_HALF_TILE_HEIGHT_ID = "qat_new_sprite_half_tile_height",
    NEW_SPRITE_MIRROR_X_ID = "qat_new_sprite_mirror_x",
    NEW_SPRITE_MIRROR_Y_ID = "qat_new_sprite_mirror_y",
    NEW_SPRITE_MIRROR_D_ID = "qat_new_sprite_mirror_d",
    REFERENCE_LAYER_NAME = "Reference Layer"
}

local QuickAutoTileActionsNewSpriteTab = {
    dialog = nil,
    drawingLayerName = "New Layer",
    halfTileWidth = 18,
    halfTileHeight = 18,
    constants = constants,
    -- mirrorX = false,
    -- mirrorY = false,
    -- mirrorD = false,
}

function QuickAutoTileActionsNewSpriteTab:Init(dialog)
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
    
    -- self.dialog:check {
    --     id = constants.NEW_SPRITE_MIRROR_X_ID,
    --     label = "Mirror X",
    --     value = self.mirrorX,
    --     selected = self.mirrorX,
    --     onclick = function()
    --         self.mirrorX = self.dialog.data[constants.NEW_SPRITE_MIRROR_X_ID]
    --     end
    -- }
    
    -- self.dialog:check {
    --     id = constants.NEW_SPRITE_MIRROR_Y_ID,
    --     label = "Mirror Y",
    --     value = self.mirrorY,
    --     selected = self.mirrorY,
    --     onclick = function()
    --         self.mirrorY = self.dialog.data[constants.NEW_SPRITE_MIRROR_Y_ID]
    --     end
    -- }
    
    -- self.dialog:check {
    --     id = constants.NEW_SPRITE_MIRROR_D_ID,
    --     label = "Mirror D",
    --     value = self.mirrorD,
    --     selected = self.mirrorD,
    --     onclick = function()
    --         self.mirrorD = self.dialog.data[constants.NEW_SPRITE_MIRROR_D_ID]
    --     end
    -- }

    -- self.dialog:separator {
    --     id = constants.NEW_SPRITE_BUTTON_SEPARATOR_ID,
    -- }

    self.dialog:button{
        id = constants.NEW_SPRITE_BUTTON_ID,
        label = "Create New Autotile Sprite",
        text = "Create Sprite",
        selected = false,
        focus = false,
        onclick = function()
            local drawingLayerProperties
            drawingLayerProperties = SpriteUtilsProperties.createSpriteWithPropertiesReturnDrawingLayerProperties(self.halfTileWidth, self.halfTileHeight, self.drawingLayerName)
            app.transaction(
                "Draw starting tiles",
                function()
                    DefaultTileMap:draw(self.halfTileWidth, self.halfTileHeight, drawingLayerProperties.layer)
                end
            )
            local tilemap = false
            local top = false
            local before = true
            local fromClipboard = true
            app.layer = drawingLayerProperties.layer
            LayerProperties.createLayerFromSpriteReturnLayerPropertiesObject(constants.REFERENCE_LAYER_NAME, LayerProperties.layerTypes.REFERENCE_LAYER, tilemap, top, before, fromClipboard)
            local brushSize = 1
            local brush = Brush(brushSize)
            app.layer = drawingLayerProperties.layer
            app.useTool{
                tool = "rectangular_marquee",
                brush = brush,
                points = {Point(2,2)},
                button = MouseButton.left,
                layer = drawingLayerProperties.layer,
                tilemapMode=TilemapMode.PIXELS,
                tilesetMode=TilesetMode.MANUAL,
                selection=SelectionMode.REPLACE,
                freehandAlgorithm=1,
                contiguous=true,
            }
            app.useTool{
                tool = "rectangular_marquee",
                brush = brush,
                points = {Point(2,2)},
                button = MouseButton.right,
                layer = drawingLayerProperties.layer,
                tilemapMode=TilemapMode.PIXELS,
                tilesetMode=TilesetMode.MANUAL,
                selection=SelectionMode.SUBTRACT,
                freehandAlgorithm=1,
                contiguous=true,
            }
            app.tool = "pencil"
        end
    }
end

function QuickAutoTileActionsNewSpriteTab:Update()
end

return QuickAutoTileActionsNewSpriteTab