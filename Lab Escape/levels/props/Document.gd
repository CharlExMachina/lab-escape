extends Area2D

func _on_Document_body_entered(body: Node) -> void:
	body.collect_document()
	queue_free()
