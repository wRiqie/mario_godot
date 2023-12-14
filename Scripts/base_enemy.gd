extends "res://Scripts/alternate_direction_body.gd"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var pointsAchieved = preload("res://Components/points_achieved.tscn")

signal enemy_damaged(points: int)

func _physics_process(delta):
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
	#await get_tree().create_timer(0.4).timeout
	#queue_free()
