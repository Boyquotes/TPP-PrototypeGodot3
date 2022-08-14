extends PlayerState

func process(delta):
	if player.controls.is_jumping():
		state_machine.transition_to("Jumping")
	elif player.has_movement():
		state_machine.transition_to("Running")
