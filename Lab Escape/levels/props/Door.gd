extends Area2D

var is_open = false

func open() -> void:
	if not is_open:
		is_open = true
		$AnimationPlayer.play("open")

func close() -> void:
	if is_open:
		is_open = false
		$AnimationPlayer.play("close")

func check_for_bodies() -> void:
	var bodies_count = get_overlapping_bodies().size()
	if bodies_count < 2:
		$CloseTimer.start()

func play_door_sound(anim_name: String) -> void:
	$OpenSound.play()

func _on_Door_body_entered(body: Node) -> void:
	$CloseTimer.stop()

	if body.is_in_group("player"):
			body.connect("open_door", self, "open")
	else:
		open()

func _on_Door_body_exited(body: Node) -> void:
	check_for_bodies()
	if body.is_in_group("player"):
			body.disconnect("open_door", self, "open")

func _on_CloseTimer_timeout() -> void:
	close()
