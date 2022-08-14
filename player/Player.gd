extends KinematicBody

class_name Player

export(float) var max_slope_angle: float = 50

onready var _skin: Spatial = $Skin
onready var _camera: ControllableCamera = $CamRoot/ControllableCamera
onready var _controls: Controls = $Controls

var _velocity: Vector3 = Vector3.ZERO
var _y_velocity: float = 0
var snap_vector = Vector3.ZERO

var _real_velocity: Vector3 = Vector3.ZERO

func _physics_process(delta):
	_real_velocity = Vector3(_velocity.x, _y_velocity, _velocity.z )
	_real_velocity = move_and_slide_with_snap(_velocity, snap_vector, Vector3.UP, true, 4, deg2rad(max_slope_angle), true)

func has_movement():
	return _controls.get_movement_vector() != Vector2.ZERO || !_velocity.is_equal_approx(Vector3.ZERO)

func update_snap_vector():
	snap_vector = -get_floor_normal() if is_on_floor() else Vector3.DOWN
