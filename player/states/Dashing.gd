extends PlayerState

export(float) var dash_power: float = 250

var _will_dash: bool = false

func enter():
	_will_dash = true

#TTHERE IS SOMETHING WRONG WITH THIS CODE! - DASH WILL NOT WORK ONCE USED

func physics_process(delta):
	.physics_process(delta)
	
	if !_will_dash:
		state_machine.transition_to(parent.get_path())
		return
	
	_will_dash = false
	
	var move_dir = player._controls.get_movement_vector()
	var direction = Vector3.FORWARD.rotated(Vector3.UP, player._skin.rotation.y)
	
	player._velocity = player.move_and_slide_with_snap(direction * dash_power, player.snap_vector, Vector3.UP, true, 4, deg2rad(player.max_slope_angle), true)
		
	state_machine.transition_to(parent.get_path())
