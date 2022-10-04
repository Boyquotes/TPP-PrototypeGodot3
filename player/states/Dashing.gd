extends PlayerState

export(float) var dash_power: float = 200

var _will_dash: bool = false

func enter():
	_will_dash = true

func physics_process(delta):
	.physics_process(delta)
	
	if !_will_dash:
		state_machine.transiiton_to("OnGround")
		return
	
	_will_dash = false
	var move_dir = player._controls.get_movement_vector()
	var direction = Vector3.FORWARD.rotated(Vector3.UP, player._skin.rotation.y)
	player._velocity = player.move_and_slide_with_snap(direction * dash_power, player.snap_vector, Vector3.FORWARD, true, 4, deg2rad(player.max_slope_angle), true)
	state_machine.transition_to("OnGround")
