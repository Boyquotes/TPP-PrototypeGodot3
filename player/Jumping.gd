extends PlayerState

export(float) var jump_force: float = 16
export(float) var gravity: float = .98
export(float) var max_terminal_velocity: float = 50
export(int) var max_jumps: int = 1
export(float) var jump_cooldown: float = .2

var _is_jumping: bool = false
var _jump_count: int = 0
var _jump_cooldown_remaining: float = 0

func enter():
	_is_jumping = true

func _process(delta):
	_is_jumping = player._controls.is_jumping()

func _physics_process(delta):
	if !_is_jumping && player.is_on_floor():
		_jump_count = 0
		_jump_cooldown_remaining = 0
		state_machine.transition_to("Stopped")
		return
	
	
	_jump_cooldown_remaining -= delta
	player._y_velocity = clamp(player._y_velocity - gravity, -max_terminal_velocity, max_terminal_velocity)
	
	if _is_jumping && _jump_count < max_jumps && _jump_cooldown_remaining <= 0:
		_is_jumping = false
		player._y_velocity = jump_force
		_jump_count += 1
		_jump_cooldown_remaining = jump_cooldown
