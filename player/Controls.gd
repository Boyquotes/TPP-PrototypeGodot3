extends Node

class_name Controls

export(float) var min_pitch: float = -90
export(float) var max_pitch: float = 75
export(float) var zoom_step: float = .05
export(float) var sensitivity: float = 0.1
export(float) var controller_sensitivity: float = 0.1

#onready var _mobile_controls = $MobileControls

var _move_vec: Vector2 = Vector2.ZERO
var _cam_rot: Vector2 = Vector2.ZERO
var _zoom_scale: float = 0
var _is_jumping: bool = false
var _is_sprinting: bool = false
var _is_dashing: bool = false
var _is_crouching: bool = false
var _is_capturing: bool = false
var _is_interacting: bool = false
var _is_cancelling: bool = false
#var _is_touchscreen: bool = false

func _ready():
	# wait until the parent node is ready
	yield(get_parent(), "ready")

	_is_capturing = true
	
	if _is_capturing:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	# if the mouse cursor is being captured in the game window
	if _is_capturing:
		# determine the movement direction based on the input strengths of the four movement directions
		var dx := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		var dy := Input.get_action_strength("move_forward") - Input.get_action_strength("move_backwards")

		# and set the movement direction vector to the normalized vector so the player can't unintentionally
		# move faster when moving diagonally
		_move_vec = Vector2(dx, -dy).normalized()
	

	# in both desktop and touch screen devices the jump flag can be determined via the jump action
	# same goes for other actions
	_is_jumping = Input.is_action_just_pressed("jump")
	_is_sprinting = Input.is_action_pressed("sprint")
	_is_dashing = Input.is_action_pressed("dash")
	_is_crouching = Input.is_action_pressed("crouch")
	_is_interacting = Input.is_action_pressed("go_interact")
	_is_cancelling = Input.is_action_pressed("cancel_interact")
	apply_controller_rotation()

func _input(event):
	# on non-touchscreen devices toggle the mouse cursor's capture mode when the ui_cancel action is
	# pressed (e.g. the Esc key)
	if Input.is_action_just_pressed("ui_cancel"):
		_is_capturing = !_is_capturing
	
	if Input.is_action_just_pressed("ui_accept"):
		_is_capturing = true
	
	if _is_capturing:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# if the mouse cursor is being captured, update the camera rotation using the relative movement
	# and the sensitivity we defined earlier. also clamp the vertical camera rotation to the pitch
	# range we defined earlier so we don't end up in weird look angles
	if _is_capturing && event is InputEventMouseMotion:
		_cam_rot.x -= event.relative.x * sensitivity
		_cam_rot.y -= event.relative.y * sensitivity
		_cam_rot.y = clamp(_cam_rot.y, min_pitch, max_pitch)

	# if the mouse cursor is being captured, increse or decrease the zoom when the corresponding
	# action has just been pressed
	if _is_capturing:
		if Input.is_action_just_pressed("zoom_in"):
			_zoom_scale = clamp(_zoom_scale - zoom_step, 0, 1)
		if Input.is_action_just_pressed("zoom_out"):
			_zoom_scale = clamp(_zoom_scale + zoom_step, 0, 1)

#apply controller camera rotation
func apply_controller_rotation():
	# get axis vector by Vector2 from the joystick's x & y strength
	var axis_vector = Vector2.ZERO
	axis_vector.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	axis_vector.y = Input.get_action_strength("look_up") - Input.get_action_strength("look_down")
	
	# if controller joystick movement is detected
	if InputEventJoypadMotion:
		# rotate camera - might need optimisation by making this a separate function
		_cam_rot.x -= axis_vector.x * controller_sensitivity
		_cam_rot.y -= axis_vector.y * controller_sensitivity
		_cam_rot.y = clamp(_cam_rot.y, min_pitch, max_pitch)
	

func get_movement_vector():
	return _move_vec

func is_jumping():
	return _is_jumping

func is_sprinting():
	return _is_sprinting

func is_dashing():
	return _is_dashing

func is_crouching():
	return _is_crouching

func get_camera_rotation():
	return _cam_rot

func is_interacting():
	return _is_interacting

func is_cancelling():
	return _is_cancelling

func get_zoom_scale():
	return _zoom_scale

func set_zoom_scale(zoom_scale):
	_zoom_scale = zoom_scale
