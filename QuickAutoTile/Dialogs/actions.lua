local NewSpriteTab = dofile("./Tabs/new_sprite.lua")
local NewLayerTab = dofile("./Tabs/new_layer.lua")
local LayerActionsSection = dofile("./Tabs/layer_actions.lua")

local QuickAutoTileActionsDialog = {
    dialog = nil,
    onSiteChange = nil,
    onSpriteChange = nil,
    previousSprite = nil,
    isOpen = false,
}

local constants = {
    ACTION_TAB_SET_ID = "qat_actions_tabs",
}

function QuickAutoTileActionsDialog:Init(onClose)
    self.dialog = Dialog {
        title = "Godot Quick Autotile Actions",
        onclose = function()
            app.events:off(self.onSiteChange)
            self.isOpen = false
            self.onSiteChange = nil
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
    
    LayerActionsSection:Init(self.dialog)
end

function QuickAutoTileActionsDialog:SiteChangeUpdate()
    if self.onSpriteChange ~= nil and self.previousSprite ~= app.sprite and self.previousSprite ~= nil then
        self.previousSprite.events:off(self.onSpriteChange)
        self.onSpriteChange = nil
    end
    if app.sprite ~= nil and app.sprite ~=self.previousSprite then
        self.onSpriteChange = app.sprite.events:on('change', function()
            self:SpriteChangeUpdate()
        end)
    end
    self.previousSprite = app.sprite
    self:SpriteChangeUpdate()
end

function QuickAutoTileActionsDialog:SpriteChangeUpdate()
    NewSpriteTab:Update()
    NewLayerTab:Update()
    LayerActionsSection:Update()
end

function QuickAutoTileActionsDialog:Open(onClose)
    if self.isOpen then
        return
    end

    self.isOpen = true
    self.onSiteChange = app.events:on('sitechange', function()
        self:SiteChangeUpdate()
    end)

    self:SiteChangeUpdate()

    self.dialog:show{wait = false}
end

return QuickAutoTileActionsDialog