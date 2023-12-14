extends "res://Scripts/base_enemy.gd"

func _ready():
	$AnimatedSprite2D.play("walk")

func _physics_process(delta):
	super._physics_process(delta)
	handleMove(delta)

func handleMove(delta):
	$AnimatedSprite2D.flip_h = not isMovingLeft
	move_and_slide()

func _on_hitbox_area_entered(area):
	if is_stomp(area):
		queue_free()
