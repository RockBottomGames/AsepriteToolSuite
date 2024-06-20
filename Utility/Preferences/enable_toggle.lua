local EnableTogglePreference = {}

function EnableTogglePreference.new(
    name,
    defaultValue,
    dontShowAgain
)
    local NewEnableTogglePreferenceObject = {
        name = name,
        value = defaultValue ~= nil and defaultValue ~= false,
        dontShowAgain = dontShowAgain
    }

    function NewEnableTogglePreferenceObject:Toggle()
        self.value = not self.value
        if not self.dontShowAgain then
            local result = app.alert{ title="Rock Bottom Games Tool Suite",
                          text=self.name .. " is now " .. (self.value and "enabled" or "disabled"),
                          buttons={"OK", "Don't Show Again"}}
            if result == 2 then
                self.dontShowAgain = true
            end
        end
    end

    return NewEnableTogglePreferenceObject
end

function EnableTogglePreference.clone(
    other
)
    return EnableTogglePreference.new(other.name, other.value, other.dontShowAgain)
end

return EnableTogglePreference