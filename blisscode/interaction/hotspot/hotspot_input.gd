class_name HotspotInput extends Hotspot
	
func _ready():
	super()
	
func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("take"):
			var body = get_tree().get_first_node_in_group(body_group)
			if body:
				_interact_handler(body, global_position)
			else:
				print("No body found in group: ", body_group)
