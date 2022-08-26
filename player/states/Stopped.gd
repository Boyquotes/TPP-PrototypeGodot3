extends PlayerState

func _process(delta):
	if player._controls.is_jumping():
		state_machine.transition_to("Jumping")
	elif player.has_movement():
		state_machine.transition_to("Running")
