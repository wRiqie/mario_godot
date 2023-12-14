extends "res://Scripts/alternate_direction_body.gd"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	super._physics_process(delta)
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()

func _on_area_2d_body_entered(body):
	queue_free()
