extends "res://characters/TemplateCharacter.gd"

const FOV_TOLERANCE = 15

export var vision_range : float = 360

signal player_on_fov
signal player_out_of_fov

var player
var direction_to_player : Vector2

func _ready() -> void:
	player = get_node("/root").find_node("Player", true, false)

func _process(_delta):
	if player_in_fov() and player_in_los():
		emit_signal("player_on_fov")
	else:
		emit_signal("player_out_of_fov")

func player_in_fov():
	var facing_direction = get_facing_direction()
	direction_to_player = (player.position - global_position).normalized()
	
	if abs(get_angle_to_player(facing_direction)) < deg2rad(FOV_TOLERANCE):
		return true
	else:
		return false

func player_in_los():
	var space = get_world_2d().direct_space_state
	var los_obstacle = space.intersect_ray(global_position, player.global_position, 
			[self], collision_mask)
	
	if not los_obstacle:
		return false
	
	var distance_to_player = player.global_position.distance_to(global_position)
	
	if los_obstacle.collider == player && distance_to_player < vision_range:
		return true
	else:
		return false

func get_facing_direction() -> Vector2:
	return Vector2.RIGHT.rotated(global_rotation)

func get_angle_to_player(facing_direction: Vector2) -> float:
	return direction_to_player.angle_to(facing_direction)
