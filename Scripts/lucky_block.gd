extends StaticBody2D

@onready var animation_player = $AnimatedSprite2D/AnimationPlayer

var MUSHROOM_SCENE = preload("res://Prefabs/mushroom.tscn")
var is_opened = false

func _ready():
	animation_player.play("spinning")

func _on_hit_box_area_entered(area):
	if not is_opened:
		is_opened = true
		animation_player.play("open")
		await get_tree().create_timer(1.5).timeout
		var newInstance = MUSHROOM_SCENE.instantiate()
		add_child(newInstance)
		newInstance.global_position = $MushroomMarker.global_position
		
