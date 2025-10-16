extends Node2D

@export var entities: Dictionary[String, SpawnData]

func spawn(entity_name: String, spawn_position: Vector2, parent = null):
	if not entities.has(entity_name):
		return null
	
	var spawn_data = entities[entity_name]
	
	var entity = spawn_data.packed_scene.instantiate()
	entity.position = GameManager.snap_to_grid(spawn_position)
	
	if entity is GlitchCharacterController:
		entity.spawn(spawn_position)

	if parent:
		parent.add_child(entity)
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
	entity.position = GameManager.snap_to_grid(spawn_position)
	
	if entity is GlitchCharacterController:
		entity.spawn(spawn_position)

	if parent:
		parent.add_child(entity)
	else:
		SceneManager.current_scene.add_child(entity)
	return entity

func float_text(text: String, pos: Vector2, duration: float = 1.0, parent = null, color: Color = Color.WHITE):
	var label = Label.new()
	label.z_index = 1000
	label.text = text
	label.modulate = color
	label.position = pos
	label.add_theme_font_size_override("font_size", 16)
	if parent:
		parent.add_child(label)
	else:
		add_child(label)
	var tween = create_tween()
	tween.parallel().tween_property(label, "position", label.position + Vector2(0, -16), duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(label, "modulate:a", 0.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	label.queue_free()
