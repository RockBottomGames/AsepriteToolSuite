local ToolSuiteCommands = dofile("./commands.lua")
local QuickAutoTileCommands = dofile("./QuickAutoTile/commands.lua")

local ToolSuitePreferences = dofile("./preferences.lua")
local QuickAutoTilePreferences = dofile("./QuickAutoTile/preferences.lua")

local toolCommands = {
    QuickAutoTileCommands
}

local toolPreferencesList = {
    QuickAutoTilePreferences
}

function init(plugin)
    if app.apiVersion == nil then
        -- First scripting API available
        app.alert("This is Aseprite v1.2.10-beta1 or v1.2.10-beta2")
    elseif app.apiVersion == 1 then
        -- Second revision of the scripting API
        app.alert("This is Aseprite v1.2.10-beta3")
    else

        ToolSuitePreferences:Init(plugin.preferences)

        for _, toolPreferences in ipairs(toolPreferencesList) do
            toolPreferences:Init(plugin.preferences)
        end

        local function setMenu()
            ToolSuiteCommands:Init(plugin, plugin.preferences)

            for _, toolCommand in ipairs(toolCommands) do
                toolCommand:Init(plugin, plugin.preferences)
            end
        end

        -- local function clearMenu()
        --     plugin:deleteMenuGroup{
        --         id = "rbgats"
        --     }
        -- end

        setMenu()
    end
end