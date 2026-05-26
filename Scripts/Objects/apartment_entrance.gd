extends StaticBody2D

var player_near = false

func _process(_delta):
	if get_tree().current_scene.current_floor != get_tree().current_scene.OUTSIDE_FLOOR:
		return

	if player_near and Input.is_action_just_pressed("interact"):
		get_tree().current_scene.enter_apartment()

func _on_interact_area_body_entered(body):
	if body.name == "Player":
		player_near = true

func _on_interact_area_body_exited(body):
	if body.name == "Player":
		player_near = false
