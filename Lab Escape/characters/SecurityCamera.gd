extends Node2D

const RED = Color(1, 0.25, 0.25)
const YELLOW = Color(0.9, 0.8, 0)
const WHITE = Color(1, 1, 10)

export var following_speed : float = 25

var direction_to_player : Vector2
var player : KinematicBody2D
var is_player_detected : bool = false

func _ready() -> void:
	player = get_node("/root").find_node("Player", true, false)
	$CameraBody/FovLight.color = WHITE

func _process(_delta: float) -> void:
	direction_to_player = (player.position - global_position).normalized()
	if is_player_detected:
		stop_tween_and_timers()
		follow_player()
		$CameraBody/FovLight.color = RED
	else:
		if not $CameraBody/CameraAnimation.is_playing():
			if not $CameraBody/RegainPatrolTimer.time_left > 0:
				$CameraBody/RegainPatrolTimer.start()

func _on_CameraBody_player_on_fov() -> void:
	if not is_player_detected:
		is_player_detected = true

func _on_CameraBody_player_out_of_fov() -> void:
	if is_player_detected:
		is_player_detected = false

func _on_RegainPatrolTimer_timeout() -> void:
	$CameraBody/CameraTween.interpolate_property($CameraBody, "rotation",
			$CameraBody.rotation, 0, 1.8, Tween.TRANS_LINEAR)
	$CameraBody/CameraTween.start()
	$CameraBody/FovLight.color = YELLOW
	pass

func _on_CameraTween_tween_all_completed():
	$CameraBody/FovLight.color = WHITE
	$CameraBody/RegainPatrolTimer.stop()
	$CameraBody/CameraAnimation.play("CameraRotation")

func stop_tween_and_timers() -> void:
	$CameraBody/RegainPatrolTimer.stop()
	$CameraBody/CameraTween.stop_all()
	$CameraBody/CameraAnimation.stop()

func follow_player() -> void:
	var facing_direction : Vector2 = get_camera_body_direction()
	$CameraBody.rotate(-get_angle_to_player(facing_direction) * get_process_delta_time()
			* following_speed)

func get_camera_body_direction() -> Vector2:
	return Vector2.RIGHT.rotated($CameraBody.global_rotation)

func get_angle_to_player(facing_direction: Vector2) -> float:
	return direction_to_player.angle_to(facing_direction)
