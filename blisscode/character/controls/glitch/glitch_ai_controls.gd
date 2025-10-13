class_name GlitchAIControls extends GlitchControls

enum MoveDirection {LEFT, RIGHT, UP, DOWN}
enum MoveType {RANDOM, FOLLOW, STAY, PINGPONG}
enum PingpongDirection {LEFTRIGHT, UPDOWN}

@export var move_direction: MoveDirection = MoveDirection.RIGHT
@export var move_type: MoveType = MoveType.RANDOM
@export var pingpong_direction: PingpongDirection = PingpongDirection.LEFTRIGHT

var parent: GlitchCharacterController
var player: GlitchCharacterController

func _ready():
	parent = get_parent()
	parent.hit_wall.connect(_on_parent_hit_wall)
	EventBus.player_spawned.connect(_on_player_spawned)

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
	var direction = MoveDirection.RIGHT
	match move_type:
		MoveType.RANDOM:
			direction = _get_random_movement()
		MoveType.FOLLOW:
			direction = _get_follow_movement(new_position)
		MoveType.STAY:
			direction = _get_stay_movement()
		MoveType.PINGPONG:
			direction = _get_pingpong_movement()
	_move(direction)

func _get_random_movement() -> MoveDirection:
	return MoveDirection.RIGHT

func _get_follow_movement(new_position: Vector2) -> MoveDirection:
	print("following player to ", new_position)
	return MoveDirection.RIGHT

func _get_stay_movement() -> MoveDirection:
	return MoveDirection.RIGHT

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
