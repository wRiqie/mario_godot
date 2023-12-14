extends Node2D

const TURTLE_SCENE = preload("res://Components/turtle_pivot.tscn")
const MUSHROOM_SCENE = preload("res://Prefabs/mushroom.tscn")

@onready var pointsLabel = $CanvasLayer/Points
@onready var lifesLabel = $CanvasLayer/Character/LifeAmount
@onready var coinsLabel = $CanvasLayer/CoinsAmount

var lifes = 5
var totalPoints = 0
var coins = 0

func _ready():
	pointsLabel.text = str(totalPoints)
	lifesLabel.text = str(lifes)
	coinsLabel.text = str(coins)
	
	connect_enemies_signals()
	connect_turtles()
	
func _on_mario_player_dead():
	$Background.stop()
	$DeathSound.play()

func _on_button_pressed():
	var instance = TURTLE_SCENE.instantiate()
	add_child(instance)
	instance.global_position = $Marker2D.global_position
	
func connect_turtles():
	for enemy in get_tree().get_nodes_in_group("turtle"):
		enemy.on_gen_new_turtle.connect(connect_enemies_signals)

func connect_enemies_signals():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if not enemy.enemy_damaged.is_connected(_on_attack_enemy):
			enemy.enemy_damaged.connect(_on_attack_enemy)
		
func _on_attack_enemy(points: int):
	totalPoints += points
	pointsLabel.text = str(totalPoints)
	print("Pontos recebidos: ", points, " Total de pontos: ", totalPoints)
