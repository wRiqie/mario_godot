extends Node2D

@onready var pointsLabel = $HUD/Points
@onready var lifesLabel = $HUD/Character/LifeAmount
@onready var coinsLabel = $HUD/CoinsAmount

var lifes = 5
var totalPoints = 0
var coins = 0

var isPlayerDead = false

var isPaused = false

var isStageClear = false

func _ready():
	pointsLabel.text = str(totalPoints)
	lifesLabel.text = str(lifes)
	coinsLabel.text = str(coins)
	
	connect_enemies_signals()
	connect_lucky_blocks_signals()
	connect_turtles()
	
func _process(delta):
	if isStageClear:
		$Camera.global_position = $MarioClearStage.global_position
	elif not isPlayerDead:
		$Camera.global_position = $Mario.global_position
	
func connect_turtles():
	for enemy in get_tree().get_nodes_in_group("turtle"):
		enemy.on_gen_new_turtle.connect(connect_enemies_signals)

func connect_enemies_signals():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if not enemy.enemy_damaged.is_connected(_on_attack_enemy):
			enemy.enemy_damaged.connect(_on_attack_enemy)
			
func connect_lucky_blocks_signals():
	for block in get_tree().get_nodes_in_group("lucky_block"):
		if not block.taked_coin.is_connected(_on_taked_coin):
			block.taked_coin.connect(_on_taked_coin)
	
func _on_mario_player_dead():
	isPlayerDead = true
	$Background.stop()
	$DeathSound.play()
	await get_tree().create_timer(3).timeout
	remove_child($Mario)
	await get_tree().reload_current_scene()

func _on_attack_enemy(points: int):
	totalPoints += points
	pointsLabel.text = str(totalPoints)
	print("Pontos recebidos: ", points, " Total de pontos: ", totalPoints)

func _on_taked_coin():
	totalPoints += 200
	coins += 1
	pointsLabel.text = str(totalPoints)
	coinsLabel.text = str(coins)

func _on_mario_player_transforming_start():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.set_physics_process(false)

func _on_mario_player_transforming_finish():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.set_physics_process(true)


func _on_clear_trigger_area_entered(area):
	if area.is_in_group("player"):
		remove_child($Mario)
		isStageClear = true
		$Anim.play("clear_stage")


func _on_anim_animation_finished(anim_name):
	pass # Replace with function body.
