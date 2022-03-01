Scene_Save = Scene_File:extend("Scene_Save")

function Scene_Save.prototype:onSelect(index)
  Save_Manager:save(index)
  Scene_Manager:enter(Scene_Map())
  Audio_Manager:playSFX("buff_up")
end

function Scene_Save.prototype:helperText()
  return "Which File to save?"
end
