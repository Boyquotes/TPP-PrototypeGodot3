extends PlayerState

export(float) var move_speed: float = 8
export(float) var sprint_speed: float = 14
export(float) var crouch_speed: float = 5
export(float) var turn_speed: float = 10
export(float) var acceleration: float = 50
export(float) var cam_follow_speed: float = 8

var _move_rot: float = 0

func _physics_process(delta):
	.physics_process(delta)
	
	var move_dir = player._controls.get_movement_vector()
	var direction = Vector3(move_dir.x, 0, move_dir.y)
	
	_move_rot = lerp(_move_rot, deg2rad(player._camera._rot_h), cam_follow_speed * delta)
	direction = direction.rotated(Vector3.UP, _move_rot)
	
	var speed = move_speed
	if player._controls.is_sprinting():
		speed = sprint_speed
	elif player._controls.is_crouching():
		speed = crouch_speed
	else:
		speed = move_speed
	
	player._velocity = player._velocity.linear_interpolate(direction * speed, acceleration * delta)
	
	if player.is_on_floor():
		player._y_velocity = -0.01
	else:
		state_machine.transition_to("InAir/Falling")

	if move_dir != Vector2.ZERO:
		player._skin.rotation.y = lerp_angle(player._skin.rotation.y, atan2(-direction.x, -direction.z), turn_speed * delta)
