class_name GlitchControls extends Node

var movement_input: Vector2 = Vector2.ZERO
var input_just_pressed: bool = false

func get_movement_direction() -> Vector2:
	return movement_input

func has_movement_input() -> bool:
	var result = input_just_pressed
	input_just_pressed = false # Reset after reading
	return result