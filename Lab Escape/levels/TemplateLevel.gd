extends Node2D

func _ready() -> void:
	connect_with_detection_meter()

func connect_with_detection_meter() -> void:
	var suspicion_meter : TextureProgress = get_tree().get_nodes_in_group("suspicion").front()
	suspicion_meter.connect("player_discovered", self, "_on_player_detected")

func _on_player_detected() -> void:
	get_tree().quit()
