extends PlayerState

export(float) var dash_cooldown: float = 1
export(float) var jump_cooldown: float = .2
export(float) var gravity: float = .98
export(float) var max_terminal_velocity: float = 50
export(int) var max_jumps: int = 1

export(float) var air_speed: float = 18
export(float) var air_acceleration: float = 1
export(float) var cam_follow_speed: float = 8
export(float) var turn_speed: float = 10

var _dash_cooldown_remaining: float = 0

var _jump_count: int = 0
var _jump_cooldown_remaining: float = 0

var _move_rot: float = 0

func process(delta):
	_dash_cooldown_remaining = max(_dash_cooldown_remaining - delta, 0)
	_jump_cooldown_remaining = max(_jump_cooldown_remaining - delta, 0)
	
	if player._controls.is_jumping() && can_jump():
		state_machine.transition_to("InAir/Jumping")
		_jump_count += 1
		_jump_cooldown_remaining = jump_cooldown
	elif player._controls.is_dashing() && can_dash():
		state_machine.transition_to("InAir/Dashing")
		_dash_cooldown_remaining = dash_cooldown
	else:
		state_machine.transition_to("InAir/Falling")

func physics_process(delta):
	if player.is_on_floor():
		_jump_count = 0
		_jump_cooldown_remaining = 0
		state_machine.transition_to("OnGround")
		return
	
	var move_dir = player._controls.get_movement_vector()
	var direction = Vector3(move_dir.x, 0, move_dir.y)
	
	_move_rot = lerp(_move_rot, deg2rad(player._camera._rot_h), cam_follow_speed * delta)
	direction = direction.rotated(Vector3.UP, _move_rot)
	
	player._velocity = player._velocity.linear_interpolate(direction * air_speed, air_acceleration * delta)
	
	player._y_velocity = clamp(player._y_velocity - gravity, -max_terminal_velocity, max_terminal_velocity)

	if move_dir != Vector2.ZERO:
		player._skin.rotation.y = lerp_angle(player._skin.rotation.y, atan2(-direction.x, -direction.z), turn_speed * delta)


func can_jump():
	return player.is_on_floor() || (_jump_count < max_jumps && _jump_cooldown_remaining <= 0)

func can_dash():
	return _dash_cooldown_remaining <= 0
	
