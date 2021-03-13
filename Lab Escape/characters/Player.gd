extends "res://characters/TemplateCharacter.gd"

signal toggle_vision_mode
signal open_door
signal use_computer

export var box_speed_multiplier: float = 0.5

onready var sprite: Sprite = $Sprite

const normal_sprite = preload("res://graphics/characters/Robot 1/robot1_stand.png")
const aiming_sprite = preload("res://graphics/characters/Robot 1/robot1_silencer.png")

var motion: Vector2 = Vector2()
var is_aiming: bool = false
var regained_movement: bool = true
var can_perform_actions: bool = true
var is_hiding_in_box: bool = false
var curr_speed: float = 0

func _physics_process(_delta: float) -> void:
	if can_perform_actions:
		handle_aiming()
		handle_door_opening()
		handle_use_computer()

	handle_hiding_in_box()
	handle_movement()
	handle_vision_mode_toggle()

func handle_hiding_in_box() -> void:
	if Input.is_action_pressed("toggle_box") and not is_aiming:
		is_hiding_in_box = true

		if not $BoxSprite.visible and $BoxCollisionShape.disabled:
			$BoxSprite.visible = true
			$Sprite.visible = false
			$BoxCollisionShape.disabled = false
			$CollisionShape2D.disabled = true
			$PlayerHighlight.visible = false
			$BoxHighlight.visible = true
			$LightOccluder2D.occluder = load("res://characters/box_occluder.tres")
	else:
		is_hiding_in_box = false

		if not $Sprite.visible and $CollisionShape2D.disabled:
			$BoxSprite.visible = false
			$Sprite.visible = true
			$BoxCollisionShape.disabled = true
			$CollisionShape2D.disabled = false
			$PlayerHighlight.visible = true
			$BoxHighlight.visible = false
			$LightOccluder2D.occluder = load("res://characters/humanoid_occluder.tres")

func update_movement():
	var inputVector = Vector2.ZERO

	inputVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	inputVector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	if inputVector.x != 0 or inputVector.y != 0:
		curr_speed += SPEED
		regained_movement = true

		if is_hiding_in_box:
			motion = inputVector.normalized() * acceleration.interpolate(curr_speed / (MAX_SPEED)) * MAX_SPEED * box_speed_multiplier
		else:
			motion = inputVector.normalized() * acceleration.interpolate(curr_speed / MAX_SPEED) * MAX_SPEED
	else:
		motion.x = lerp(motion.x, 0, INTERPOLATE)
		motion.y = lerp(motion.y, 0, INTERPOLATE)
		regained_movement = false

func handle_movement():
	if not is_aiming:
		update_movement()
		motion = move_and_slide(motion)
		if (motion.x == 0 and motion.y == 0):
			regained_movement = false

		if regained_movement:
			rotation = lerp_angle(rotation, motion.angle(), 0.3)

func handle_aiming():
	if not is_hiding_in_box:
		if Input.is_action_pressed("aim"):
			if not is_aiming:
				is_aiming = true
				$Sprite.texture = aiming_sprite
				$PlayerAimHightlight.visible = true
				$PlayerHighlight.visible = false
				regained_movement = false
			motion = Vector2(0, 0)

			var mouse_difference = get_global_mouse_position() - position
			rotation = lerp_angle(rotation, mouse_difference.angle(), 0.4)
		if Input.is_action_just_released("aim"):
			is_aiming = false
			$Sprite.texture = normal_sprite
			$PlayerAimHightlight.visible = false
			$PlayerHighlight.visible = true

func handle_vision_mode_toggle() -> void:
	if Input.is_action_just_released("toggle_vision_mode"):
		emit_signal("toggle_vision_mode")

func handle_door_opening() -> void:
	if Input.is_action_just_pressed("perform_action") and not Input.is_action_pressed("aim"):
		var door = $Sprite/RayCast2D.get_collider()

		if door != null:
				emit_signal("open_door")

func handle_use_computer() -> void:
	if Input.is_action_just_pressed("perform_action") and not Input.is_action_pressed("aim"):
		var computer = $Sprite/RayCast2D.get_collider()
		emit_signal("use_computer")

func collect_access_card() -> void:
	var loot = Node.new()
	loot.set_name("AccessCard")
	add_child(loot)
	get_tree().call_group("ItemDisplay", "add_access_card")

func _on_try_unlock(can_perform) -> void:
	can_perform_actions = can_perform
	$ActionTimer.start()
