extends PlayerState

func _process(delta):
	interact()

func interact():
	if player.interacting() and player.clipcam.is_current():
		print("working!")
		# change camera
		player.clipcam.clear_current(true)
		# allow to rotate an object using the mouse
		player.controls._is_capturing = !player.controls._is_capturing
		
