extends StaticBody2D

@export_enum("up", "down") var direction := "up"

var player_near = false

func _process(_delta):
	if get_tree().current_scene.current_floor == get_tree().current_scene.OUTSIDE_FLOOR:
		return

	if visible and player_near and Input.is_action_just_pressed("interact"):
		get_tree().current_scene.use_staircase(direction)

func _on_interact_area_body_entered(body):
	if body.name == "Player":
		player_near = true

func _on_interact_area_body_exited(body):
	if body.name == "Player":
		player_near = false
