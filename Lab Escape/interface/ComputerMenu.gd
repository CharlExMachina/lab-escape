extends Popup

export(String, MULTILINE) var computer_text: String

func set_combination(combination: Array) -> void:
	var combination_string: String = PoolStringArray(combination).join("")
	var sanitized_text = computer_text.replace("$PASSWORD", combination_string)
	$ScreenEdges/Screen/ScreenText.text = sanitized_text
