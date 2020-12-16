extends Node

func generate_combination(length: int) -> Array:
	var combination : Array = []
	for number in range(length):
		randomize()
		combination.append(randi() % 10)
	return combination
