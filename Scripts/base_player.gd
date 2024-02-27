extends CharacterBody2D
class_name BasePlayer

@export var SPEED = 130.0
@export var RUNFACTOR = 1.8
@export var JUMP_VELOCITY = -400.0

var isDead = false
var isTransforming = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var animSprite: AnimatedSprite2D = null
var jumpSound = null

var isJumping = false
var isRunning = false

var idleAnim = null
var walkAnim = null
var jumpAnim = null
var runAnim = null
var runJumpAnim = null
var fallAnim = null

func handle_move(delta):
	isJumping = not is_on_floor()
	isRunning = Input.is_action_pressed("run")
	
	var speed = SPEED if not isRunning else SPEED * RUNFACTOR
	
	# Add the gravity.
	if isJumping:
		velocity.y += gravity * delta
		if isRunning and velocity.x != 0:
			animSprite.play(runJumpAnim)
		elif(velocity.y < 0) :
			animSprite.play(jumpAnim)
		else:
			animSprite.play(fallAnim)
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jumpSound.play()
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
		if not isJumping:
			var anim = (walkAnim) if not isRunning else (runAnim)
			animSprite.play(anim)
			animSprite.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if velocity == Vector2.ZERO:
		animSprite.play(idleAnim)

#func move(delta) -> Vector2 :
	#var vel = Vector2.ZERO
	#
	#if Input.is_action_pressed("move_right"):
		#vel.x += 1
	#if Input.is_action_pressed("move_left"):
		#vel.x -= 1
	#if Input.is_action_pressed("move_down"):
		#vel.y += 1
	#if Input.is_action_pressed("move_up"):
		#vel.y -= 1
		#
	#
	#if vel.length() > 0:
		#vel = vel.normalized() * SPEED
		#animSprite.play()
	#else:
		#animSprite.stop()
	#
	#position += vel * delta
		#
	#return vel

#func animate(vel):
	#if vel.x != 0:
		#lastDir = DirectionEnum.left if vel.x < 0 else DirectionEnum.right
		#animSprite.animation = walk
		#animSprite.flip_h = lastDir == DirectionEnum.left
	#elif vel.y != 0:
		#lastDir = DirectionEnum.up if vel.y < 0 else DirectionEnum.down
		#animSprite.animation = walk_up if lastDir == DirectionEnum.up else walk_down
	#else :
		#if lastDir == DirectionEnum.left or lastDir == DirectionEnum.right:
			#animSprite.animation = idle
		#elif lastDir == DirectionEnum.up:
			#animSprite.animation = idle_up
		#elif lastDir == DirectionEnum.down:
			#animSprite.animation = idle_down
