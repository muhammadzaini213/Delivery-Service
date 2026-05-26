extends StaticBody2D

var player_near = false
var player = null

func _process(_delta):
	if get_tree().current_scene.current_floor != get_tree().current_scene.OUTSIDE_FLOOR:
		return

	if player_near and Input.is_action_just_pressed("interact"):
		if player != null and player.collect_pizzas():
			get_tree().current_scene.show_message("Picked up pizzas!")
			get_tree().current_scene.update_pizza_text()
		elif player != null:
			get_tree().current_scene.show_message("You can't hold more pizzas!")

func _on_interact_area_body_entered(body):
	if body.name == "Player":
		player_near = true
		player = body

func _on_interact_area_body_exited(body):
	if body.name == "Player":
		player_near = false
		player = null
