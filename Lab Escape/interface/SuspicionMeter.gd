extends TextureProgress

signal player_discovered

export var suspicion_multiplier = 2

func _ready() -> void:
	value = 0

func _process(delta: float) -> void:
	value -= step

func player_seen() -> void:
	value += step * suspicion_multiplier

	if value == max_value:
		emit_signal("player_discovered")
