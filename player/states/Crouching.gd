extends PlayerState

func enter():
	#set the current animation root state to Crouching
	# player.anim_tree.set("parameters/RootState/current", 2)
	pass

func process(delta):
	# if the player is not trying to crouch, transition back to the OnGround state
	if !player.controls.is_crouching():
		state_machine.transition_to("OnGround")
