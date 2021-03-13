extends "res://characters/PlayerDetection.gd"

export var min_arrival_distance = 5
export var move_speed_multiplier = 0.5 # moves at half speed by default

onready var navigation : Navigation2D = get_tree().get_root().find_node("Navigation2D",
		true, false)
onready var destinations : Node = navigation.get_node("Destinations")

var motion
var possible_destinations
var path

func _ready() -> void:
	randomize()
	possible_destinations = destinations.get_children()
	make_path()

func _physics_process(delta: float) -> void:
	navigate()

func make_path() -> void:
	var new_destination : Position2D = possible_destinations[randi() % possible_destinations.size() - 1]
	print(new_destination.position)
	path = navigation.get_simple_path(position, new_destination.position, false)

func navigate() -> void:
	var distance_to_destination = position.distance_to(path[0])
	if distance_to_destination > min_arrival_distance:
		move()
	else:
		update_path()

func move() -> void:
	look_at(path[0])
	motion = (path[0] - position).normalized() * MAX_SPEED * move_speed_multiplier

	if is_on_wall():
		make_path()

	motion = move_and_slide(motion)

func update_path() -> void:
	if path.size() == 1:
		if $Timer.is_stopped():
			$Timer.start()
	else:
		path.remove(0)

func _on_SecurityGuard_player_on_fov() -> void:
	$FovLight.color = Color(0.5, 0, 0) # red
	get_tree().call_group("suspicion", "player_seen")

func _on_SecurityGuard_player_out_of_fov() -> void:
	$FovLight.color = Color(1, 1, 1)


func _on_Timer_timeout() -> void:
	make_path()
