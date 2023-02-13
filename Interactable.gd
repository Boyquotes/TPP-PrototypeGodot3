extends Spatial

onready var chime = $DetectSound
onready var outsound = $OutSound
onready var interactanim = $InteractAnimation	

func play_sound_when_enter():
	chime.play()

func play_sound_when_out():
	outsound.play()

func play_animation_when_enter():
	interactanim.play("Rotate")

func reset_animation_when_out():
	interactanim.play_backwards("Rotate")

func rotate_me():
	# manipulate the interactable object
	pass
