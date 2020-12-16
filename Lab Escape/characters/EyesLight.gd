extends Light2D

var is_light_on = false
var light_energy = 1.17

func _process(_delta: float) -> void:
	if Input.is_action_just_released("toggle_light"):
		toggle_light()

func toggle_light():
	is_light_on = !is_light_on
	if is_light_on:
		energy = light_energy
	else:
		energy = 0
	$ToggleSound.play()
