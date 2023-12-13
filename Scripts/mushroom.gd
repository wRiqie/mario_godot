extends CharacterBody2D

@export var SPEED = 60.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var isMovingLeft = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var direction = get_which_wall_collided()
	
	if isMovingLeft:
		velocity.x = -1 * SPEED
	else:
		velocity.x = 1 * SPEED
		
	if(direction != null and direction == isMovingLeft):
		isMovingLeft = not isMovingLeft
	
	move_and_slide()

func get_which_wall_collided():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_normal().x > 0:
			return true
		elif collision.get_normal().x < 0:
			return false
