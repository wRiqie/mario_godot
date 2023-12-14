extends "res://Scripts/base_enemy.gd"

var isDead = false

func _ready():
	$AnimatedSprite2D.play("walk")

func _physics_process(delta):
	if not isDead:
		super._physics_process(delta)
	
	$AnimatedSprite2D.flip_h = not isMovingLeft
	
	move_and_slide()

func _on_hit_box_area_entered(area):
	if is_stomp(area) and not isDead:
		isDead = true
		$AnimatedSprite2D.play("dead")
		velocity.x = 0
		await get_tree().create_timer(1).timeout
		queue_free()
