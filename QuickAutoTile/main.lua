local constants = dofile("./CopyOfBaseCode/constants.lua")
local QuickAutoTileCommands = dofile("./commands.lua")

local QuickAutoTilePreferences = dofile("./preferences.lua")

function init(plugin)
    if app.apiVersion == nil then
        -- First scripting API available
        app.alert("This is Aseprite v1.2.10-beta1 or v1.2.10-beta2")
    elseif app.apiVersion == 1 then
        -- Second revision of the scripting API
        app.alert("This is Aseprite v1.2.10-beta3")
    else

        QuickAutoTilePreferences:Init(plugin.preferences)

        local function setMenu()
            QuickAutoTileCommands:Init(plugin, plugin.preferences, constants.TOOL_SUITE_PARENT_GROUP_ID)
        end

        -- local function clearMenu()
        --     plugin:deleteMenuGroup{
        --         id = "rbgats"
        --     }
        -- end

        setMenu()
    end
end