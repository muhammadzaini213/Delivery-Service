extends Node

func _process(_delta):
	if Input.is_action_just_pressed("back_to_main"):
		get_tree().change_scene_to_file("res://Scenes/Game/main.tscn")

func _on_check_button_toggled(toggled_on):
	OrderManager.set_receiving_orders(toggled_on)
