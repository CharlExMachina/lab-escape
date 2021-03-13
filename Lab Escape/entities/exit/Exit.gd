extends ColorRect

func _on_Area2D_body_entered(body: Node) -> void:
	if body.has_node("AccessCard"):
		get_tree().quit()
