extends "res://Scripts/alternate_direction_body.gd"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$AnimatedSprite2D.play("walk")

func _physics_process(delta):
	super._physics_process(delta)
	handleMove(delta)

func handleMove(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	$AnimatedSprite2D.flip_h = not isMovingLeft
	move_and_slide()

func _on_hitbox_area_entered(area):
	if area.global_position.y + 10 < global_position.y:
		queue_free()
