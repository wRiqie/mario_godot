extends BasePlayer

signal player_dead()
signal player_transforming_start()
signal player_transforming_finish()

func _ready():
	idleAnim = "idle"
	walkAnim = "walk"
	runAnim = "running"
	runJumpAnim = "running_jump"
	fallAnim = "falling"
	jumpAnim = "jumping"
	
	animSprite = $AnimatedSprite2D
	jumpSound = $JumpSound

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

func handle_damage():
	animSprite.play("death")
	isDead = true
	player_dead.emit()

func handle_transforming():
	isTransforming = true
	player_transforming_start.emit()
	$AnimationPlayer.play("growing")
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
				handle_damage()
		elif area.is_in_group("deathArea"):
			handle_damage()
		elif area.is_in_group("mushroom"):
			$MushroomPicked.play()
			handle_transforming()
