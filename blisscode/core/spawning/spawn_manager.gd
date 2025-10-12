extends Node2D

@export var entities: Dictionary[String, SpawnData]

func spawn(entity_name: String, spawn_position: Vector2, parent = null):
	if not entities.has(entity_name):
		return null
	
	var spawn_data = entities[entity_name]
	
	var entity = spawn_data.packed_scene.instantiate()
	entity.position = spawn_position
	
	if entity is GlitchCharacterController:
		entity.spawn(spawn_position)

	if parent:
		parent.add_child(entity)
	else:
		SceneManager.current_scene.add_child(entity)
	return entity

func spawn_paths(entity_name: String, spawn_position: Vector2, paths: Array[Path2D], parent = null):
	var entity = spawn(entity_name, spawn_position, parent)
	if entity:
		entity.paths = paths
	return entity

func spawn_player(entity_name: String, spawn_position: Vector2, parent = null):
	if not entities.has(entity_name):
		return null
	
	var spawn_data = entities[entity_name]
	
	var entity = spawn_data.packed_scene.instantiate()
	entity.position = spawn_position
	
	if entity is GlitchCharacterController:
		entity.spawn(spawn_position)

	if parent:
		parent.add_child(entity)
	else:
		SceneManager.current_scene.add_child(entity)
	return entity
