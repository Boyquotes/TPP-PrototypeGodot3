extends RigidBody

onready var chime = $DetectSound
onready var outsound = $OutSound

var rotating = false

var prev_mouse_position
var next_mouse_position

onready var state_machine = get_node("../Player/Movement")

func _process(delta):
	inspect_object()
	
	if (rotating):
		next_mouse_position = get_viewport().get_mouse_position()
		rotate_y((next_mouse_position.x - prev_mouse_position.x) * .25 * delta)
		rotate_x((next_mouse_position.y - prev_mouse_position.y) * .25 * delta)
		prev_mouse_position = next_mouse_position

func inspect_object():
	if (Input.is_action_just_pressed("rotate")):
		rotating = true
		prev_mouse_position = get_viewport().get_mouse_position()
	if (Input.is_action_just_released("rotate")):
		rotating = false

func reset_object():
	state_machine.transition_to("OnGround")

func play_sound_when_enter():
	chime.play()

func play_sound_when_out():
	outsound.play()
