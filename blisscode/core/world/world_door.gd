class_name WorldDoor extends Area2D

@export var door_id: String
@export var goto_door_id: String
@export var scene_path: String
@export var scene_transition_name: String = "Fade"

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	hide()
	EventBus.player_spawned.connect(_on_player_spawned)
	
func _on_body_entered(body):
	if visible:
		if body is GlitchCharacterController:
			EventBus.world_changed.emit(goto_door_id, door_id, scene_path, scene_transition_name)

func _on_player_spawned(player):
	player.collected_skulls.connect(_on_player_collected_skulls)

func _on_player_collected_skulls():
	show()
