extends Spatial

onready var chime = $DetectSound
onready var outsound = $OutSound

func play_sound_when_enter():
	chime.play()

func play_sound_when_out():
	outsound.play()
