extends Area

export(NodePath) var node_path
export(String) var call_method
#export(String) var exit_method

# on enter
#func _on_body_entered(body):
	# find the enter method node when player node is entered e.g. sound
	#if body is Player:
	#	body.interactables.append(self)

#func _on_body_exited(body):
	#if body is Player:
	#	body.interactables.erase(self)

func _on_PlayerInteractArea_body_entered(body):
	if body is Player:
		body.interactables.append(self)

func _on_PlayerInteractArea_body_exited(body):
	if body is Player:
		body.interactables.erase(self)

func interact():
	if get_node_or_null(node_path) != null:
		if get_node(node_path).has_method(call_method):
			get_node(node_path).call(call_method)
