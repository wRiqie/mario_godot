extends CharacterBody2D

signal playerDead()

@export var SPEED = 300.0
@export var RUNFACTOR = 2.0
@export var JUMP_VELOCITY = -400.0

var isJumping = false
var isRunning = false
var isDead = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	handle_move(delta)
	for i in range(get_slide_collision_count() - 1):
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Turtle" and not isDead:
			playerDead.emit()
	
func handle_move(delta):
	isJumping = not is_on_floor()
	isRunning = Input.is_action_pressed("run")
	
	var speed = SPEED if not isRunning else SPEED * RUNFACTOR
	
	# Add the gravity.
	if isJumping:
		velocity.y += gravity * delta
		if isRunning and velocity.x != 0:
			$AnimatedSprite2D.play("running_jump")
		elif(velocity.y < 0) :
			$AnimatedSprite2D.play("jumping")
		else:
			$AnimatedSprite2D.play("falling")
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		$jumpSound.play()
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
		if not isJumping:
			$AnimatedSprite2D.play("walk" if not isRunning else "running")
			$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")

	move_and_slide()

