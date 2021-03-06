Scene_Load = Scene_File:extend("Scene_Load")

function Scene_Load.prototype:onSelect(index)
  if Save_Manager:exists(index) then
    Save_Manager:load(index)
    Scene_Manager:enter(Scene_Map())
    Audio_Manager:playSFX("buff_up")
  else
    Audio_Manager:playSFX("error1")
  end
end

function Scene_Load.prototype:helperText()
  return "Which File to load?"
end
