extends Area

export(NodePath) var node_path
export(String) var enter_method
export(String) var exit_method

# on enter
func _on_AreaTrigger_body_entered(body):
	# find the enter method node when player node is entered e.g. sound
	if body is Player:
		if node_path:
			if get_node_or_null(node_path) != null:
				if get_node(node_path).has_method(enter_method):
					get_node(node_path).call(enter_method)
				else:
					printerr("Trigger node missing method")
			else:
				printerr("Trigger couldn't get node")
		else:
			printerr("Trigger node path empty")

# on exit
func _on_AreaTrigger_body_exited(body):
	# find the exit method node when player node is out
	if body is Player:
		if node_path:
			if get_node_or_null(node_path) != null:
				if get_node(node_path).has_method(exit_method):
					get_node(node_path).call(exit_method)
				else:
					printerr("Trigger node missing method")
			else:
				printerr("Trigger couldn't get node")
		else:
			printerr("Trigger node path empty")
