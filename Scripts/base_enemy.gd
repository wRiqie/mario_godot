extends "res://Scripts/alternate_direction_body.gd"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	super._physics_process(delta)
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
func is_stomp(area: Area2D):
	return area.global_position.y + 10 < global_position.y
