extends "res://Scripts/alternate_direction_body.gd"
class_name BaseEnemy

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var pointsAchieved = preload("res://Components/points_achieved.tscn")

var raycast: RayCast2D

signal enemy_damaged(points: int)

@export var floor_detector_size = 20

func init_floor_detector():
	raycast = preload("res://Components/no_floor_identifier.tscn").instantiate()
	add_child(raycast)
	
	var direction = 1 if isMovingLeft else -1
	raycast.global_position = global_position
	raycast.target_position.y = floor_detector_size
	raycast.target_position.x = floor_detector_size * direction

func _physics_process(delta):
	var direction = -1 if isMovingLeft else 1
	raycast.target_position.x = floor_detector_size * direction
	
	if not raycast.is_colliding():
		isMovingLeft = !isMovingLeft
	super._physics_process(delta)
		
	if not is_on_floor():
		velocity.y += gravity * delta
	
func is_stomp(area: Area2D):
	return area.global_position.y + 10 < global_position.y

func _show_points(points: int):
	var newInstance = pointsAchieved.instantiate()
	add_child(newInstance)
	newInstance.get_node("Points").text = str(points)
	newInstance.get_node("AnimationPlayer").play("up")
	await get_tree().create_timer(1.5).timeout
	remove_child(newInstance)

func give_points(points):
	enemy_damaged.emit(points)
	_show_points(points)
