local EnableTogglePreference = dofile("../Utility/Preferences/enable_toggle.lua")
local constants = dofile("../constants.lua")

local ToolSuitePreferences = {}

function ToolSuitePreferences:Init(preferences)
    if preferences[constants.QUICK_AUTO_TILE_ENABLED_KEY] == nil or preferences[constants.QUICK_AUTO_TILE_ENABLED_KEY].value == nil then
        preferences[constants.QUICK_AUTO_TILE_ENABLED_KEY] = EnableTogglePreference.new("Quick Auto Tile", true, false)
    else
        preferences[constants.QUICK_AUTO_TILE_ENABLED_KEY] = EnableTogglePreference.clone(preferences[constants.QUICK_AUTO_TILE_ENABLED_KEY])
    end
end

return ToolSuitePreferences