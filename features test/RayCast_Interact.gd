extends RayCast

onready var prompt = $Prompt
onready var chime = $DetectSound

func _ready():
	add_exception(Player)

func _physics_process(delta):
	if self.is_colliding():
		#chime.play()
		var collider = self.get_collider()
		prompt.text = "Interact using "
		print("detected")
