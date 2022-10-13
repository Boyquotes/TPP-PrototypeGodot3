extends PlayerState

export(float) var jump_force: float = 16

var _will_jump: bool = false

func enter():
	_will_jump = true

func _process(delta):
	_will_jump = player._controls.is_jumping()

func _physics_process(delta):
	.physics_process(delta)
	
	if !_will_jump:
		state_machine.transition_to("InAir/Falling")
		return
	
	_will_jump = false
	
	player._y_velocity = jump_force
	state_machine.transition_to("InAir/Falling")
