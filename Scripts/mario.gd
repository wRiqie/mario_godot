extends CharacterBody2D

signal player_dead()
signal player_transforming_start()
signal player_transforming_finish()

@export var SPEED = 300.0
@export var RUNFACTOR = 2.0
@export var JUMP_VELOCITY = -400.0

var isJumping = false
var isRunning = false
var isBig = false
var isDead = false

var isTransforming = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if isTransforming:
		pass
	elif not isDead:
		handle_move(delta)
	else:
		if is_on_floor() and not $CollisionShape2D.disabled:
			velocity.x = 0
			velocity.y = JUMP_VELOCITY
		else:
			$CollisionShape2D.disabled = true;
			$Hitbox/CollisionShape2D.disabled = true;
			velocity.y += (gravity - 350) * delta
		move_and_slide()
	
func handle_move(delta):
	isJumping = not is_on_floor()
	isRunning = Input.is_action_pressed("run")
	
	var speed = SPEED if not isRunning else SPEED * RUNFACTOR
	
	# Add the gravity.
	if isJumping:
		velocity.y += gravity * delta
		if isRunning and velocity.x != 0:
			$AnimatedSprite2D.play("running_jump" if isBig else "s_running_jump")
		elif(velocity.y < 0) :
			$AnimatedSprite2D.play("jumping" if isBig else "s_jumping")
		else:
			$AnimatedSprite2D.play("falling" if isBig else "s_falling")
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		$JumpSound.play()
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
		if not isJumping:
			var anim = ("walk" if isBig else "s_walk") if not isRunning else ("running" if isBig else "s_running")
			$AnimatedSprite2D.play(anim)
			$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.play("idle"  if isBig else "s_idle")

	move_and_slide()
	
func handle_damage(isHitKill: bool):
	if isBig and not isHitKill:
		handle_transforming(false)
	else:
		$AnimatedSprite2D.play("death")
		isDead = true
		player_dead.emit()
		
func handle_transforming(isGrowing: bool):
	isTransforming = true
	player_transforming_start.emit()
	isBig = isGrowing
	$AnimationPlayer.play("growing" if isGrowing else "decreasing")
	await get_tree().create_timer(.9).timeout
	isTransforming = false
	player_transforming_finish.emit()
	
func _on_hitbox_area_entered(area):
	if isTransforming:
		pass
	
	if not isDead:
		if area.is_in_group("enemyHitbox"):
			if (area.global_position.y > global_position.y + 10): 
				const BOUNCESPEED = -350
				velocity.y = BOUNCESPEED
				$Attack.play()
			else:
				handle_damage(false)
		elif area.is_in_group("deathArea"):
			handle_damage(true)
		elif area.is_in_group("mushroom"):
			$MushroomPicked.play()
			if not isBig:
				handle_transforming(true)
		
