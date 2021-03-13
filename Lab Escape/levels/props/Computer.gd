extends Node2D

signal combination_generated

export var combination_length = 4
export var lock_group = "unset"

var combination: Array

func _ready() -> void:
	$Control/GroupName.rect_rotation = -rotation_degrees
	$Control/GroupName.text = lock_group
	generate_combination()
	emit_signal("combination_generated", combination, lock_group)

func generate_combination() -> void:
	combination = CombinationGenerator.generate_combination(combination_length)
	$CanvasLayer/ComputerMenu.set_combination(combination)

func open_menu() -> void:
	$CanvasLayer/ComputerMenu.popup_centered()

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
			body.connect("use_computer", self, "open_menu")

func _on_Area2D_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
			body.disconnect("use_computer", self, "open_menu")
			$CanvasLayer/ComputerMenu.hide()
