extends "res://levels/props/Door.gd"

signal try_unlock

var is_password_correct = false

func _ready() -> void:
	$Node2D/GroupName.rect_rotation = -rotation_degrees

func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		$CanvasLayer/Numpad.hide()
		close()

func _on_Door_body_entered(body: Node) -> void:
	$CloseTimer.stop()

	if body.is_in_group("player"):
			body.connect("open_door", self, "open")
			self.connect("try_unlock", body, "_on_try_unlock")
	else:
		open()

func _on_Door_body_exited(body: Node) -> void:
	check_for_bodies()
	if body.is_in_group("player"):
			$CanvasLayer/Numpad.hide()
			body.disconnect("open_door", self, "open")
			self.disconnect("try_unlock", body, "_on_try_unlock")

func open() -> void:
	if not is_open and not is_password_correct:
		$CanvasLayer/Numpad.popup_centered()
		emit_signal("try_unlock", false)
	elif not is_open and is_password_correct:
		$CanvasLayer/Numpad.hide()
		is_open = true
		$AnimationPlayer.play("open")

func _on_Numpad_popup_hide():
	emit_signal("try_unlock", true)

func _on_Numpad_combination_correct() -> void:
	is_password_correct = true
	$CanvasLayer/Numpad.turn_light_green()
	$OpenTimer.start()

func _on_OpenTimer_timeout() -> void:
	open()

func _on_Computer_combination_generated(combination: Array, lock_group: String) -> void:
	$CanvasLayer/Numpad.combination = combination
	$Node2D/GroupName.text = lock_group
