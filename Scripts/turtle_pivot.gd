extends Node2D

const SHELLED_TURTLE_SCENE = preload("res://Prefabs/shelled_turtle.tscn")

signal on_gen_new_turtle

func _on_turtle_turtle_damaged():
	var newInstance = SHELLED_TURTLE_SCENE.instantiate()
	add_child(newInstance)
	newInstance.global_position = $Turtle.get_node("shelled_marker").global_position
	newInstance.SPEED = 60
	on_gen_new_turtle.emit()
