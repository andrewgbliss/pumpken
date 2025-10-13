class_name UserHealthLight extends PointLight2D

@export var character: GlitchCharacterController

func _ready():
	character.health_changed.connect(on_health_changed)
	on_health_changed(character.hp)

func on_health_changed(new_health: int):
	energy = new_health
	texture_scale = new_health
