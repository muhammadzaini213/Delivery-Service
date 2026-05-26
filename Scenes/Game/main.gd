extends Node

func _process(delta):
	if Input.is_action_just_pressed("phone ui"):
		get_tree().change_scene_to_file("res://Scenes/phone ui/phone ui.tscn")
