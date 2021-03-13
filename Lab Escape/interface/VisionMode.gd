extends CanvasModulate

const DARK_COLOR = Color(0.12, 0.12, 0.12)
const NIGHT_VISION = Color(0.22, 0.68, 0.4)

var is_vision_mode_enabled = false
var can_activate_night_vision = true

func _ready() -> void:
	color = DARK_COLOR

func toggle_vision_mode() -> void:
	if can_activate_night_vision:
		can_activate_night_vision = false
		is_vision_mode_enabled = not is_vision_mode_enabled

		if (is_vision_mode_enabled):
			color = NIGHT_VISION
			$NightVisionAudio.play()
			get_tree().set_group("labels", "visible", true)
			get_tree().call_group("lights", "hide")
		else:
			color = DARK_COLOR
			get_tree().set_group("labels", "visible", false)
			get_tree().call_group("lights", "show")

		$NightVisionTimer.start()

func _on_NightVisionTimer_timeout() -> void:
	can_activate_night_vision = true
