extends RayCast

onready var prompt = $Prompt

#func _ready():
	#add_exception(owner)

func _physics_process(_delta):
	if self.is_colliding():
		prompt.text("Detected")
