extends BaseEnemy

signal turtle_damaged

@onready var AnimatedSprite = $AnimatedSprite2D

func _ready():
	init_floor_detector()
	AnimatedSprite.play("walk")

func _physics_process(delta):
	super._physics_process(delta)
	handleMove(delta)

func handleMove(delta):
	AnimatedSprite.flip_h = not isMovingLeft
	move_and_slide()

func _on_hitbox_area_entered(area):
	if is_stomp(area):
		turtle_damaged.emit()
		give_points(600)
		AnimatedSprite.visible = false
		await get_tree().create_timer(0.4).timeout
		queue_free()
