extends PlayerState

export(float) var dash_cooldown: float = 1

var _dash_cooldown_remaining: float = 0

func _process(delta):
	if player._controls.is_jumping():
		state_machine.transition_to("InAir/Jumping")
	elif player._controls.is_crouching():
		state_machine.transition_to("Crouching")
		print_debug("Crouching")
	elif player._controls.is_dashing() && can_dash():
		state_machine.transition_to("OnGround/Dashing")
		_dash_cooldown_remaining = dash_cooldown
	elif player.has_movement():
		state_machine.transition_to("OnGround/Running")
	elif !player.has_movement():
		state_machine.transition_to("OnGround/Stopped")

func can_dash():
	return _dash_cooldown_remaining <= 0
