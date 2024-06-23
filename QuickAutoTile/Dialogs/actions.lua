local NewSpriteTab = dofile("./Tabs/new_sprite.lua")
local NewLayerTab = dofile("./Tabs/new_layer.lua")
local LayerActionsTabSet = dofile("./Tabs/layer_actions.lua")

local QuickAutoTileActionsDialog = {
    dialog = nil,
    onSiteChange = nil,
    isOpen = false,
}

local constants = {
    ACTION_TAB_SET_ID = "qat_actions_tabs",
}

function QuickAutoTileActionsDialog:Init(onClose)
    local mySelf = self
    self.dialog = Dialog {
        title = "Godot Quick Autotile Actions",
        onclose = function()
            app.events:off(mySelf.onSiteChange)
            mySelf.isOpen = false
            if onClose then
                onClose()
            end
        end
    }
    
    NewSpriteTab:Init(self.dialog)
    NewLayerTab:Init(self.dialog)

    self.dialog:endtabs {
        id = constants.ACTION_TAB_SET_ID,
        selected = NewSpriteTab.constants.NEW_SPRITE_TAB_ID
    }
    
    LayerActionsTabSet:Init(self.dialog)
end

function QuickAutoTileActionsDialog:Update()
    NewSpriteTab:Update()
    NewLayerTab:Update()
    LayerActionsTabSet:Update()
end

function QuickAutoTileActionsDialog:Open(onClose)
    if self.isOpen then
        return
    end

    self.isOpen = true
    self.onSiteChange = app.events:on('sitechange', function()
        self:Update()
    end)

    self:Update()

    self.dialog:show{wait = false}
end

return QuickAutoTileActionsDialog