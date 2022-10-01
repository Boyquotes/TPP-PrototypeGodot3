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
	#commit first before writing more code in
