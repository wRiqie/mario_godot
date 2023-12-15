extends "res://Scripts/base_enemy.gd"

@onready var RayCast = $RayCast

var isDead = false
var isSliding = false

func _ready():
	init_floor_detector()
	slide_in()

func _physics_process(delta):
	if not isDead and not isSliding:
		super._physics_process(delta)
	elif not is_on_floor():
		velocity.y += gravity * delta
		
	
	$AnimatedSprite2D.flip_h = not isMovingLeft
	
	move_and_slide()

func slide_in():
	$AnimatedSprite2D.play("slide")
	isMovingLeft = true
	isSliding = true
	velocity.x = -80
	move_and_slide()
	await get_tree().create_timer(1).timeout
	isSliding = false
	if not isDead: 
		$AnimatedSprite2D.play("walk")
	

func _on_hit_box_area_entered(area):
	if is_stomp(area) and not isDead:
		isDead = true
		$AnimatedSprite2D.play("dead")
		velocity.x = 0
		give_points(200)
		remove_child($HitBox)
		await get_tree().create_timer(1).timeout
		queue_free()
