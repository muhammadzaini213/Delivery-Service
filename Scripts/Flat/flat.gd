extends StaticBody2D

@export var flat_number := 101

var player_near = false
var player = null

@onready var delivery_text = $"../../../UI/DeliveryText"
@onready var delivery_timer = $"../../../UI/DeliveryTimer"
@onready var success_sound = $SuccessSound

func _process(_delta):
	if get_tree().current_scene.current_floor == get_tree().current_scene.OUTSIDE_FLOOR:
		return

	if player_near and Input.is_action_just_pressed("interact"):
		if player != null and player.deliver_pizza():
			get_tree().current_scene.show_message("Delivered to Flat %s!" % flat_number)
			get_tree().current_scene.update_pizza_text()
			success_sound.play()
			print("DELIVERED TO FLAT %s" % flat_number)
		elif player != null:
			get_tree().current_scene.show_message("You have no pizzas!")

func set_floor_number(floor_number):
	flat_number = floor_number * 100 + get_index() + 1

func _on_interact_area_body_entered(body):
	if body.name == "Player":
		player_near = true
		player = body
		print("PLAYER NEAR FLAT %s" % flat_number)

func _on_interact_area_body_exited(body):
	if body.name == "Player":
		player_near = false
		player = null
		print("PLAYER LEFT FLAT %s" % flat_number)
