class_name GlitchCharacterController extends CharacterBody2D

enum CharacterType {PLAYER, NPC}
@export var character_type: CharacterType = CharacterType.NPC

@export var grid_spacing: int = 16
@export var move_speed: float = 320.0
@export var controls: GlitchControls
@export var sprite: Sprite2D
@export var hat_sprite: Sprite2D
@export var show_grave: bool = false
@export var garbage_time: float = 1.0
@export var spawn_on_ready: bool = false

var target_position: Vector2
var is_moving: bool = false
var is_alive = false
var facing_right: bool = true

var hp: int = 1
var skulls: int = 0
var has_hat: bool = false

signal collected_skulls
signal health_changed(new_hp: int)
signal died
signal moved(new_position: Vector2)
signal hit_wall

func _ready():
	if hat_sprite:
		hat_sprite.hide()
	target_position = GameManager.snap_to_grid(position)
	if spawn_on_ready:
		spawn(position)

func start_move(direction: Vector2):
	target_position = position + (direction * grid_spacing)
	is_moving = true

func _physics_process(_delta: float):
	if not is_alive:
		return
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
	move_and_slide()
	
	# Check for collisions after movement
	if get_slide_collision_count() > 0:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			
			if character_type == CharacterType.PLAYER:
				if collider is GlitchCharacterController:
					if has_hat:
						SpawnManager.float_text("Cast Vanish!", position, 1.0, get_parent(), Color.RED)
						collider.take_damage(1)
					else:
						take_damage(1)
					break
				if collider is StaticBody2D:
					SpawnManager.float_text("Break!", position, 1.0, get_parent(), Color.YELLOW)
					collider.queue_free()
					break
			elif character_type == CharacterType.NPC:
				if collider is GlitchCharacterController:
					if collider.has_hat:
						SpawnManager.float_text("Cast Vanish!", position, 1.0, get_parent(), Color.RED)
						take_damage(1)
					else:
						collider.take_damage(1)
					break

		hit_wall.emit()
	
		# Stop movement due to collision
		velocity = Vector2.ZERO
		is_moving = false
		position = GameManager.snap_to_grid(position)
		target_position = position
		return
	
	# Check if we've reached the target
	if position.distance_to(target_position) < 1.0:
		position = target_position
		velocity = Vector2.ZERO
		is_moving = false
		moved.emit(position)

func spawn(pos: Vector2):
	show()
	position = GameManager.snap_to_grid(pos)
	hp = 1
	is_alive = true
	health_changed.emit(hp)

func take_damage(amount: int):
	hp -= amount
	health_changed.emit(hp)
	if hp <= 0:
		die()

func die():
	if not is_alive:
		return
	hide()
	is_moving = false
	is_alive = false
	velocity = Vector2.ZERO
	target_position = Vector2.ZERO
	if show_grave:
		SpawnManager.spawn("gravestone", position, get_parent())
	if garbage_time > 0.0:
		await get_tree().create_timer(garbage_time).timeout
		queue_free()
	else:
		await SpawnManager.float_text("Died", position, 1.0, get_parent())
		died.emit()
	
	
func restore_health(amount: int):
	hp += amount
	health_changed.emit(hp)

func item_pickup(item: Item, _pos):
	match item.name:
		"skull":
			SpawnManager.float_text("+1 Skull", position, 1.0, get_parent())
			if character_type == CharacterType.PLAYER:
				skulls += 1
				if skulls >= 3:
					collected_skulls.emit()
		"purple magicians hat":
			if character_type == CharacterType.PLAYER:
				SpawnManager.float_text("+1 Hat", position, 1.0, get_parent())
				has_hat = true
				if hat_sprite:
					hat_sprite.show()
		"candle":
			if character_type == CharacterType.PLAYER:
				SpawnManager.float_text("+1 Health", position, 1.0, get_parent())
				restore_health(1)
		"cauldron":
			if character_type == CharacterType.PLAYER:
				SpawnManager.float_text("-1 Health", position, 1.0, get_parent(), Color.RED)
				take_damage(1)
		_:
			print("Unknown item: ", item.name)

func flip_sprite():
	sprite.flip_h = !sprite.flip_h
