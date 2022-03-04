Audio_Manager = {
  _bgm = nil,
  _bgmName = nil,
}

function Audio_Manager:playBGM(name)
  if name == self._bgmName then
    return
  end
  if self._bgm then
    self._bgm:stop()
  end
  self._bgmName = name
  self._bgm = Assets.audio.bgm[name]
  if self._bgm then
    self._bgm:play()
  end
end

function Audio_Manager:stopBGM()
  if not self._bgm then
    return
  end
  self._bgm:stop()
  self._bgm = nil
  self._bgmName = nil
end

function Audio_Manager:playSFX(name)
  local sfx = Assets.audio.sfx[name]
  if sfx then
    sfx:setLooping(false)
    sfx:stop()
    sfx:play()
  end
end
