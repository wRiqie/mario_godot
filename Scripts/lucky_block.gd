extends StaticBody2D

@onready var animation_player = $Lucky/AnimationPlayer

@export var hasCoin = false

signal taked_coin

var MUSHROOM_SCENE = preload("res://Prefabs/mushroom.tscn")
var COIN_SCENE = preload("res://Prefabs/mushroom.tscn")
var POINTS_ACHIEVED_SCENE = preload("res://Components/points_achieved.tscn")
var is_opened = false


func _ready():
	animation_player.play("spinning")

func _on_hit_box_area_entered(area):
	if not is_opened:
		is_opened = true
		if hasCoin:
			taked_coin.emit()
			animation_player.play("open_coin")
			var newInstance = POINTS_ACHIEVED_SCENE.instantiate()
			add_child(newInstance)
			newInstance.get_node("Points").text = str(200)
			newInstance.get_node("AnimationPlayer").play("up")
			await get_tree().create_timer(1.5).timeout
			remove_child(newInstance)
		else:
			animation_player.play("open_mushroom")
			await get_tree().create_timer(1.5).timeout
			var newInstance = MUSHROOM_SCENE.instantiate()
			add_child(newInstance)
			newInstance.global_position = $MushroomMarker.global_position
		
