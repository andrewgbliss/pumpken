class_name GlitchCharacterController extends CharacterBody2D

@export var grid_spacing: int = 16
@export var move_speed: float = 320.0
@export var controls: GlitchControls

var target_position: Vector2
var is_moving: bool = false

func _ready():
	# Snap to grid on start
	position = Vector2(
		round(position.x / grid_spacing) * grid_spacing,
		round(position.y / grid_spacing) * grid_spacing
	)
	target_position = position

func start_move(direction: Vector2):
	target_position = position + (direction * grid_spacing)
	is_moving = true

func _physics_process(_delta: float):
	# Check for input from controls
	if not is_moving and controls and controls.has_movement_input():
		var input_direction = controls.get_movement_direction()
		start_move(input_direction)
	
	if not is_moving:
		velocity = Vector2.ZERO
		return
	
	var direction = (target_position - position).normalized()
	velocity = direction * move_speed
	
	# Check for collision using move_and_slide return value
	if move_and_slide():
		# Stop movement due to collision
		velocity = Vector2.ZERO
		is_moving = false
		# Snap to grid based on actual position after collision
		var grid_position = Vector2(
			round(position.x / grid_spacing) * grid_spacing,
			round(position.y / grid_spacing) * grid_spacing
		)
		position = grid_position
		target_position = position
		return
	
	# Check if we've reached the target
	if position.distance_to(target_position) < 1.0:
		position = target_position
		velocity = Vector2.ZERO
		is_moving = false
