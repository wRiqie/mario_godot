extends CharacterBody2D

@export var SPEED = 400.0
var isMovingLeft = false

func _physics_process(delta):
	if isMovingLeft:
		velocity.x = -1 * SPEED
	else:
		velocity.x = 1 * SPEED
		
	var isLeft = get_which_wall_collided()
	if(isLeft != null and isLeft == isMovingLeft):
		isMovingLeft = not isMovingLeft

func get_which_wall_collided():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_normal().x > 0:
			return true
		elif collision.get_normal().x < 0:
			return false
