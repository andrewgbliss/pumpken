class_name Hotspot extends Node2D

@export var interact_area: Area2D
@export var interact_audio: AudioStreamPlayer

var local_collision_pos: Vector2
var current_body
var has_interacted = false

signal interacted(body, pos: Vector2)

func _interact_handler(body, pos: Vector2):
	if has_interacted:
		return
	if interact_audio:
		interact_audio.play()
	has_interacted = true
	interacted.emit(body, pos)
		
func _integrate_forces(state):
	if (state.get_contact_count() >= 1):
		local_collision_pos = state.get_contact_local_pos(0)
