extends "res://characters/TemplateCharacter.gd"

var motion = Vector2()
var is_aiming = false
var regained_movement = true

onready var sprite = $Sprite

func _physics_process(delta: float) -> void:
	handle_aiming()
	handle_movement()

func update_movement():
	if Input.is_action_pressed("move_up") and not Input.is_action_pressed("move_down"):
		motion.y = clamp(motion.y - SPEED, -MAX_SPEED, 0)
		regained_movement = true
	elif Input.is_action_pressed("move_down") and not Input.is_action_pressed("move_up"):
		motion.y = clamp(motion.y + SPEED, 0, MAX_SPEED)
		regained_movement = true
	else:
		motion.y = lerp(motion.y, 0, INTERPOLATE)
	
	if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		motion.x = clamp(motion.x - SPEED, -MAX_SPEED, 0)
		regained_movement = true
	elif Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
		motion.x = clamp(motion.x + SPEED, 0, MAX_SPEED)
		regained_movement = true
	else:
		motion.x = lerp(motion.x, 0, INTERPOLATE)
	
	# Reduces diagonal speed
	if Input.is_action_pressed("move_down") and Input.is_action_pressed("move_right") or Input.is_action_pressed("move_down") and Input.is_action_pressed("move_left"):
		motion.x = motion.x / 1.13 # It's hardcoded and it looks terrible but it works, so, whatever ¯\_(ツ)_/¯
		motion.y = motion.y / 1.13
	elif Input.is_action_pressed("move_up") and Input.is_action_pressed("move_right") or Input.is_action_pressed("move_up") and Input.is_action_pressed("move_left"):
		motion.x = motion.x / 1.13
		motion.y = motion.y / 1.13

func handle_movement():
	if not is_aiming:
		update_movement()
		motion = move_and_slide(motion)
		
		if regained_movement:
			rotation = lerp_angle(rotation, motion.angle(), 0.3) 

func handle_aiming():
	if Input.is_action_pressed("aim"):
		if not is_aiming:
			is_aiming = true
			regained_movement = false
		motion = Vector2(0, 0)
		#look_at(get_global_mouse_position())
		var mouse_difference = get_global_mouse_position() - position
		rotation = lerp_angle(rotation, mouse_difference.angle(), 0.4)
	if Input.is_action_just_released("aim"):
		is_aiming = false
