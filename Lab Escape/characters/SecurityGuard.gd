extends "res://characters/PlayerDetection.gd"

func _ready() -> void:
	pass # Replace with function body.


func _on_SecurityGuard_player_on_fov() -> void:
	$FovLight.color = Color(0.5, 0, 0)


func _on_SecurityGuard_player_out_of_fov() -> void:
	$FovLight.color = Color(1, 1, 1)
