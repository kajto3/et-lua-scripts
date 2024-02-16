function dolua(params)
	sound = "sound\\admins\\" .. params[1] .. ".wav"
	et.G_globalSound(sound)
end