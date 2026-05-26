extends Node

func _process(delta):
	if Input.is_action_just_pressed("back_to_main"):
		get_tree().change_scene_to_file("res://Scenes/Game/main.tscn")
