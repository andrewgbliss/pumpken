class_name PlayerSpawner extends Node2D

@export var player_key: String = "player"
@export var entity_container: Node2D

var player: GlitchCharacterController

func _ready():
	call_deferred("_after_ready")

func _after_ready():
	spawn()
	
func spawn():
	player = SpawnManager.spawn_player(player_key, global_position, entity_container)
	player.died.connect(_on_died)
	EventBus.player_spawned.emit(player)

func _on_died():
	player.spawn(global_position)
