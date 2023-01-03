extends PlayerState

export(float) var dash_cooldown: float = 1

var _dash_cooldown_remaining: float = 0

var closest_interactable

func process(delta):
	_dash_cooldown_remaining = max(_dash_cooldown_remaining - delta, 0)

	# if the jump button is pressed, transition into the InAir/Jumping state immediately
	if player.controls.is_jumping():
		state_machine.transition_to("InAir/Jumping")
	elif player.controls.is_crouching():
		# if the player is crouching, transition to the Crouching state, which will determine actual
		# sub state (e.g. stopped or moving) on its own
		state_machine.transition_to("Crouching")
	elif player.controls.is_dashing() && can_dash():
		# if the player is trying to dash and if they CAN dash, transition to the OnGround/Dashing state
		state_machine.transition_to("OnGround/Dashing")
		_dash_cooldown_remaining = dash_cooldown
	elif player.has_movement():
		# if the player has any kind of horizontal movement, transition to the OnGround/Running state
		state_machine.transition_to("OnGround/Running")
	elif !player.has_movement():
		# if the player has no horizontal movement, transition to the OnGround/Running state
		state_machine.transition_to("OnGround/Stopped")
	
	closest_interactable = find_closest_interactable()
	if player.controls.is_interacting() and closest_interactable != null:
		closest_interactable.interact()


func find_closest_interactable():
	if player.interactables.size() < 1:
		return null
	elif player.interactables.size() > 1:
		var distance = INF
		var closest = player.interactables[0]
		for n in player.interactables:
			var global_translation = Vector3(0, 0, 0)
			var new_distance = n.global_translation.distance_to(global_translation)
			if new_distance < distance:
				distance = new_distance
				closest = n
		return closest
	else:
		return player.interactables[0]

func can_dash():
	# if the dash cooldown timer is 0 or less the player can jump
	return _dash_cooldown_remaining <= 0
