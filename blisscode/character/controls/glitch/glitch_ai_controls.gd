class_name GlitchAIControls extends GlitchControls

enum MoveDirection {LEFT, RIGHT, UP, DOWN}
enum MoveType {RANDOM, FOLLOW, STAY, PINGPONG}
enum PingpongDirection {LEFTRIGHT, UPDOWN}

@export var move_direction: MoveDirection = MoveDirection.RIGHT
@export var move_type: MoveType = MoveType.RANDOM
@export var pingpong_direction: PingpongDirection = PingpongDirection.LEFTRIGHT
@export var in_range_area: Area2D
@export var idle_until_aggro: bool = false

var parent: GlitchCharacterController
var player: GlitchCharacterController

var in_range = false

func _ready():
	parent = get_parent()
	parent.hit_wall.connect(_on_parent_hit_wall)
	EventBus.player_spawned.connect(_on_player_spawned)
	if in_range_area:
		in_range_area.body_entered.connect(_on_in_range_area_body_entered)
		in_range_area.body_exited.connect(_on_in_range_area_body_exited)

func _on_in_range_area_body_entered(_body: Node2D):
	in_range = true

func _on_in_range_area_body_exited(_body: Node2D):
	in_range = false

func _on_parent_hit_wall():
	match move_type:
		MoveType.PINGPONG:
			match pingpong_direction:
				PingpongDirection.LEFTRIGHT:
					if move_direction == MoveDirection.RIGHT:
						move_direction = MoveDirection.LEFT
						parent.flip_sprite()
					else:
						move_direction = MoveDirection.RIGHT
						parent.flip_sprite()
				PingpongDirection.UPDOWN:
					if move_direction == MoveDirection.UP:
						move_direction = MoveDirection.DOWN
					else:
						move_direction = MoveDirection.UP


func _on_player_spawned(p: GlitchCharacterController):
	player = p
	player.moved.connect(_on_player_moved)

func _on_player_moved(new_position: Vector2):
	if idle_until_aggro and not in_range:
		return

	var direction = MoveDirection.RIGHT
	match move_type:
		MoveType.RANDOM:
			direction = _get_random_movement()
		MoveType.FOLLOW:
			if in_range:
				direction = _get_follow_movement(new_position)
			else:
				direction = _get_random_movement()
		MoveType.STAY:
			return
		MoveType.PINGPONG:
			direction = _get_pingpong_movement()
	_move(direction)

func _get_random_movement() -> MoveDirection:
	var directions = [MoveDirection.LEFT, MoveDirection.RIGHT, MoveDirection.UP, MoveDirection.DOWN]
	return directions[randi() % directions.size()]

func _get_follow_movement(new_position: Vector2) -> MoveDirection:
	var delta = new_position - parent.position
	
	# Move in the direction with the larger distance
	if abs(delta.x) >= abs(delta.y):
		# Move horizontally
		if delta.x > 0:
			return MoveDirection.RIGHT
		else:
			return MoveDirection.LEFT
	else:
		# Move vertically
		if delta.y > 0:
			return MoveDirection.DOWN
		else:
			return MoveDirection.UP

func _get_pingpong_movement() -> MoveDirection:
	match pingpong_direction:
		PingpongDirection.LEFTRIGHT:
			if move_direction == MoveDirection.RIGHT:
				return MoveDirection.RIGHT
			else:
				return MoveDirection.LEFT
		PingpongDirection.UPDOWN:
			if move_direction == MoveDirection.UP:
				return MoveDirection.UP
			else:
				return MoveDirection.DOWN
		_:
			return MoveDirection.RIGHT

func _move(direction: MoveDirection):
	movement_input = Vector2.ZERO
	input_just_pressed = false
	if direction == MoveDirection.LEFT:
		movement_input = Vector2.LEFT
		input_just_pressed = true
	elif direction == MoveDirection.RIGHT:
		movement_input = Vector2.RIGHT
		input_just_pressed = true
	elif direction == MoveDirection.UP:
		movement_input = Vector2.UP
		input_just_pressed = true
	elif direction == MoveDirection.DOWN:
		movement_input = Vector2.DOWN
		input_just_pressed = true
