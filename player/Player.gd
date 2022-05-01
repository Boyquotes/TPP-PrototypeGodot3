extends KinematicBody

export(float) var move_speed: float = 10
# add sprint speed here
export(float) var turn_speed: float = 10
export(float) var jump_force: float = 10
export(float) var acceleration: float = 50
export(float) var air_acceleration: float = 25
export(float) var normal_acceleration: float = 50
export(float) var gravity: float = .98
export(float) var max_terminal_velocity: float = 50
export(float) var max_slope_angle: float = 50
export(int) var max_jumps: int = 1
export(float) var jump_cooldown: float = .1
export(float) var cam_follow_speed: float = 8

onready var _skin: Spatial = $Skin
onready var _camera: ControllableCamera = $CamRoot/ControllableCamera
onready var _controls: Controls = $Controls

var _move_dir: Vector2 = Vector2.ZERO
var _is_jumping: bool = false
var _move_rot: float = 0
var snap_vector = Vector3.ZERO

var _velocity: Vector3 = Vector3.ZERO
var _y_velocity: float = 0
var _rotation: float = 0
var _jump_count: int = 0
var _jump_cooldown_remaining: float = 0

func _process(delta):
	# get the movement direction and jump status from the controls node
	_move_dir = _controls.get_movement_vector()
	_is_jumping = _controls.is_jumping()

func _physics_process(delta):
	# turn the 2D input movement direction into a Vector3 so it's easire to use later on
	var direction = Vector3(_move_dir.x, 0, _move_dir.y)
	
	# make the player towards where the camera is facing by lerrping the current movement rotation
	# towards the camera's horizontal rotation and rotating the raw movement direction with that angle
	_move_rot = lerp(_move_rot, deg2rad(_camera._rot_h), cam_follow_speed * delta)
	direction = direction.rotated(Vector3.UP, _move_rot)
	
	# lerps current velocity to the horizontal velocity by the input direction multiplied by move speed
	_velocity = _velocity.linear_interpolate(direction * move_speed, acceleration * delta)
	
	# insert sprint here
	
	# if the player is on the floor, reset the jump timer and counter, and then set the terminal velocity to a
	# miniscule negative value so the player can "snap" to the ground when calling move_and_slide
	if is_on_floor():
		_y_velocity = -0.01
		_jump_count = 0
		_jump_cooldown_remaining = 0
	else:
		# if not then the player is falling, so count down the jump time and decrease 
		# the vertical velocity by gravity, clamped to the max terminal velocity
		_jump_cooldown_remaining -= delta
		_y_velocity = clamp(_y_velocity - gravity, -max_terminal_velocity, max_terminal_velocity)
	
	if not is_on_floor():
		 acceleration = air_acceleration
	elif is_on_floor():
		acceleration = normal_acceleration
	else:
		acceleration = normal_acceleration
	
	# if the player wants to jump, jump count does not exceed to the max jump count
	# the remaining cooldown is 0 or less we have the player jump
	# therefore it needs to reset the jumping from true to false, set the vertical velocity to the jump force
	# increase the jump count by one, reset the jump timer to the jump cooldown time
	if _is_jumping && _jump_count < max_jumps && _jump_cooldown_remaining <= 0:
		_is_jumping = false
		_y_velocity = jump_force
		_jump_count += 1
		_jump_cooldown_remaining = jump_cooldown
		snap_vector = Vector3.ZERO
		
	
	# if the player has any amount of movement, lerp the player's model rotation towards the current
	# movement direction based on its angle towards the X+ axis on the XZ plane
	if _move_dir != Vector2.ZERO:
		_rotation = lerp_angle(_rotation, atan2(-direction.x, -direction.z), turn_speed * delta)
		_skin.rotation.y = _rotation
	
	# set the Y component of the velocity to the vertical velocity determind by the code above
	# and update it using move_and_slide_with_snap with the max slope angle we define earlier and to prevent player from sliding
	_velocity.y = _y_velocity
	_velocity = move_and_slide_with_snap(_velocity, snap_vector, Vector3.UP, true, 4, deg2rad(max_slope_angle), true)
	#_velocity = move_and_slide(_velocity, Vector3.UP, false, 4, deg2rad(max_slope_angle))

func update_snap_vector():
	snap_vector = -get_floor_normal() if is_on_floor() else Vector3.DOWN
