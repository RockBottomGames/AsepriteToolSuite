local EnableTogglePreference = dofile("./BaseCode/Utility/Preferences/enable_toggle.lua")
local constants = dofile("./BaseCode/constants.lua")

local ToolSuitePreferences = {}

function ToolSuitePreferences:Init(preferences)
    if preferences[constants.TOOL_SUITE_ENABLED_KEY] == nil or preferences[constants.TOOL_SUITE_ENABLED_KEY].value == nil then
        preferences[constants.TOOL_SUITE_ENABLED_KEY] = EnableTogglePreference.new("Tool Suite", true, false)
    else
        preferences[constants.TOOL_SUITE_ENABLED_KEY] = EnableTogglePreference.clone(preferences[constants.TOOL_SUITE_ENABLED_KEY])
    end
end

return ToolSuitePreferences