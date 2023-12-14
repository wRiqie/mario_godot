extends CharacterBody2D
	
@export var speed = 100
	
var isWalkingLeft = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	handleMove(delta)

func handleMove(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var direction = get_which_wall_collided()
	
	if isWalkingLeft:
		$AnimatedSprite2D.play("walk")
		velocity.x = -1 * speed
	else:
		$AnimatedSprite2D.play("walk")
		velocity.x = 1 * speed 
	
	if(direction != null and direction == isWalkingLeft):
		isWalkingLeft = not isWalkingLeft
	$AnimatedSprite2D.flip_h = not isWalkingLeft
	move_and_slide()

func get_which_wall_collided():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_normal().x > 0:
			return true
		elif collision.get_normal().x < 0:
			return false


func _on_hitbox_area_entered(area):
	if area.global_position.y + 10 < global_position.y:
		queue_free()
