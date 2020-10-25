extends "res://characters/TemplateCharacter.gd"

var motion = Vector2()
var is_aiming = false
var regained_movement = true
var curr_speed = 0

onready var sprite = $Sprite

func _physics_process(delta: float) -> void:
	handle_aiming()
	handle_movement()

func update_movement():
	var inputVector = Vector2.ZERO
	
	inputVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	inputVector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if inputVector.x != 0 or inputVector.y != 0:
		curr_speed += SPEED
		regained_movement = true
		motion = inputVector.normalized() * acceleration.interpolate(curr_speed / MAX_SPEED) * MAX_SPEED
	else:
		motion.x = lerp(motion.x, 0, INTERPOLATE)
		motion.y = lerp(motion.y, 0, INTERPOLATE)
		regained_movement = false

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
