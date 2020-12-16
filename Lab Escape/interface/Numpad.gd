extends Popup

signal combination_correct

onready var numpad_light : TextureRect = $VBoxContainer/CenterContainer/NumpadButtons/NumpadLight
onready var display_label : Label = $VBoxContainer/DisplayContainer/Password

var combination : Array = []
var guess : Array = []

var digit_click_sound = preload("res://sounds/input_digit.wav")
var enter_click_sound = preload("res://sounds/enter_password.wav")

func _ready() -> void:
	connect_buttons()

func connect_buttons() -> void:
	for child in $VBoxContainer/CenterContainer/NumpadButtons.get_children():
		if child is Button:
			child.connect("button_up", self, "_on_numpad_button_pressed", [child.text])

func _on_numpad_button_pressed(entered_value) -> void:
	if entered_value == "OK":
		$ButtonSound.stream = enter_click_sound
		$ButtonSound.play()
		enter_code()
	else:
		$ButtonSound.stream = digit_click_sound
		$ButtonSound.play()
		append_digit(entered_value)

func append_digit(value) -> void:
	if guess.size() != combination.size():
		guess.append(value)
		update_password_screen()

func check_guess_is_right() -> bool:
	var guess_pool = PoolStringArray(guess).join("")
	var combination_pool = PoolStringArray(combination).join("")

	if guess.size() == combination.size():
		if guess_pool == combination_pool:
			reset_password_screen()
			return true
		else:
			reset_password_screen()
			return false

	return false

func turn_light_green():
	$SuccessSound.play()
	$VBoxContainer/DisplayContainer/Password.text = "GRANTED!"
	$VBoxContainer/CenterContainer/NumpadButtons/NumpadLight.texture = load("res://graphics/interface/dotGreen.png")

func enter_code() -> void:
	# other functionality
	if check_guess_is_right():
		emit_signal("combination_correct")
	else:
		if guess.size() == combination.size():
			reset_password_screen()

func update_password_screen() -> void:
	$VBoxContainer/DisplayContainer/Password.text = PoolStringArray(guess).join("")

func reset_password_screen() -> void:
	guess.clear()
	update_password_screen()
