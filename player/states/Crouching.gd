extends PlayerState

func enter():
	#set the current animation root state to Crouching
	# player.anim_tree.set("parameters/RootState/current", 2)
	pass

func process(delta):
	# if the player is not trying to crouch, transition back to the OnGround state
	if !player.controls.is_crouching():
		state_machine.transition_to("OnGround")
	elif player.has_movement():
		# if the player has some horizontal movement, transition to move
		state_machine.transition_to("Crouching/Moving")
	else:
		# if the player is not moving at all, transition to stop
		state_machine.transition_to("Crouching/Stoppped")

func _physics_process(delta):
	# set the courching blend position to player's horizontal... tbc
	pass
