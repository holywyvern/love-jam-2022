Scene_Save = Scene_File:extend("Scene_Save")

function Scene_Save.prototype:onSelect(index)
  Save_Manager:save(index)
  Scene_Manager:enter(Scene_Map())
end

function Scene_Save.prototype:helperText()
  return "Which File to save?"
end
