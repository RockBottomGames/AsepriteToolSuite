local constants = {
    TILESET_UPDATE_STEP_ID_PREFIX = "tileset_update_step_",
    TILESET_UPDATE_OK_BUTTON_ID = "tileset_update_ok_button"
}

local PauseForMirrorStepDialog = {
    constants = constants,
    dialog = nil,
    onclose = nil,
    layerName = "Drawing"
}


function PauseForMirrorStepDialog:Init()
    self.dialog = Dialog {
        title = "Update Tileset Properties Now",
        onclose = function()
            if self.onclose ~= nil then
                self.onclose()
            end
        end
    }

    self.dialog:label{
        id=constants.TILESET_UPDATE_STEP_ID_PREFIX .. "1",
        label="1.",
        text="Right click on the new " .. self.layerName .. " layer and select Properties. "
    }

    self.dialog:label{
        id=constants.TILESET_UPDATE_STEP_ID_PREFIX .. "2",
        label="2.",
        text="Left click the tileset icon to the right of the Mode Dropdown box. "
    }

    self.dialog:label{
        id=constants.TILESET_UPDATE_STEP_ID_PREFIX .. "3",
        label="3.",
        text="Update \"Allowed Flips\" however you'd like. "
    }

    self.dialog:label{
        id=constants.TILESET_UPDATE_STEP_ID_PREFIX .. "4",
        label="4.",
        text="When you are happy with the settings click \"OK\" to continue."
    }

    self.dialog:button{
        id=constants.TILESET_UPDATE_OK_BUTTON_ID,
        text = "OK",
        selected = false,
        focus = true,
        onclick = function()
            self.dialog:close()
        end
    }
end

function PauseForMirrorStepDialog:Open(onclose, layerName)
    self.onclose = onclose
    self.layerName = layerName
    self.dialog:modify{
        id=constants.TILESET_UPDATE_STEP_ID_PREFIX .. "1",
        text="Right click on the new " .. self.layerName .. " layer and select Properties. "
    }
    self.dialog:show{ wait = false }
end

return PauseForMirrorStepDialog