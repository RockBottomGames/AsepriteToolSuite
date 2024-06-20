local constants = dofile("../constants.lua")
local QuickAutoTileActionsDialog = dofile("./Dialogs/actions.lua")

local QuickAutoTileCommands = {}

function QuickAutoTileCommands:Init(plugin, preferences, parent_id)
    parent_id = parent_id == nil and constants.TOOL_SUITE_GROUP_ID or parent_id

    plugin:newMenuGroup{
        id = constants.QUICK_AUTO_TILE_GROUP_ID,
        title = "Quick Auto Tile",
        group = parent_id
    }
    plugin:newCommand{
        id = constants.QUICK_AUTO_TILE_ENABLED_ID,
        title = "Quick Auto Tile Enabled/Disabled",
        group = constants.QUICK_AUTO_TILE_GROUP_ID,
        onenabled = function()
            return true
        end,
        onclick = function()
            preferences[constants.QUICK_AUTO_TILE_ENABLED_KEY]:Toggle()
        end
    }

    QuickAutoTileActionsDialog:Init()

    plugin:newCommand{
        id = constants.QUICK_AUTO_TILE_ACTIONS_DIALOG_ID,
        title = "Actions Dialog",
        group = constants.QUICK_AUTO_TILE_GROUP_ID,
        onenabled = function()
            return not QuickAutoTileActionsDialog.isOpen
        end,
        onclick = function()
            QuickAutoTileActionsDialog:Open()
        end
    }
end

return QuickAutoTileCommands