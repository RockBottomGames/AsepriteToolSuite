local constants = dofile("./BaseCode/constants.lua")

local ToolSuiteCommands = {}

function ToolSuiteCommands:Init(plugin, preferences, parent_id)
    parent_id = parent_id == nil and constants.TOOL_SUITE_PARENT_GROUP_ID or parent_id
    plugin:newMenuGroup{
        id = constants.TOOL_SUITE_GROUP_ID,
        title = "Rock Bottom Games Tool Suite",
        group = parent_id
    }
    plugin:newCommand{
        id = constants.TOOL_SUITE_ENABLED_ID,
        title = "Toggle Tool Suite Enabled/Disabled",
        group = constants.TOOL_SUITE_GROUP_ID,
        onenabled = function()
            return true
        end,
        onclick = function()
            preferences[constants.TOOL_SUITE_ENABLED_KEY]:Toggle()
        end
    }
end

return ToolSuiteCommands