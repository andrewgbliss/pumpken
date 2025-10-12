class_name GlitchPlayerControls extends GlitchControls

func _input(_event):
	# Reset input state
	movement_input = Vector2.ZERO
	input_just_pressed = false
	
	# Check for movement inputs
	if Input.is_action_just_pressed("move_left"):
		movement_input = Vector2.LEFT
		input_just_pressed = true
	elif Input.is_action_just_pressed("move_right"):
		movement_input = Vector2.RIGHT
		input_just_pressed = true
	elif Input.is_action_just_pressed("move_up"):
		movement_input = Vector2.UP
		input_just_pressed = true
	elif Input.is_action_just_pressed("move_down"):
		movement_input = Vector2.DOWN
		input_just_pressed = true
