extends PlayerState

export(float) var dash_cooldown: float = 1

var _dash_cooldown_remaining: float = 0

func enter():
	# set the current animation root state to Crouching
	#player.anim_tree.set("parameters/RootState/current", 0)
	pass

