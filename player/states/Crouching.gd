extends PlayerState

func process(delta):
	if !player._controls.is_crouching():
		state_machine.transition_to("OnGround")
		print_debug("Not Crouching")
	elif player.has_movement():
		state_machine.transition_to("Crouching/Moving")
	else:
		state_machine.transition_to("Crouching/Stopped")
