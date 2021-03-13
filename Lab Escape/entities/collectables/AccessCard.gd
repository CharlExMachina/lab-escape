extends Area2D

func _on_AccessCard_body_entered(body: Node) -> void:
	body.collect_access_card()
	queue_free()
