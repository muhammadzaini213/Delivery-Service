extends StaticBody2D

@export var flat_number := 101

var player_near = false
var player = null

@onready var success_sound: AudioStreamPlayer2D = $SuccessSound
@onready var fail_sound: AudioStreamPlayer2D = $FailSound

func _process(_delta):
	if get_tree().current_scene.current_floor == get_tree().current_scene.OUTSIDE_FLOOR:
		return

	if player_near and Input.is_action_just_pressed("interact"):
		if not OrderManager.has_order(flat_number):
			fail_sound.play()
			var message = "No active orders!"
			if not OrderManager.active_orders.is_empty():
				message = "Wrong flat! Deliver to Flat %s." % OrderManager.active_orders[0]

			get_tree().current_scene.show_message(message)
		elif player != null and player.deliver_pizza():
			var earned = OrderManager.complete_order(flat_number)
			get_tree().current_scene.show_message("Delivered to Flat %s! +$%s" % [flat_number, earned])
			get_tree().current_scene.update_pizza_text()
			success_sound.play()
		elif player != null:
			fail_sound.play()
			get_tree().current_scene.show_message("You have no pizzas!")

func set_floor_number(floor_number):
	flat_number = floor_number * 100 + get_index() + 1

func _on_interact_area_body_entered(body):
	if body.name == "Player":
		player_near = true
		player = body

func _on_interact_area_body_exited(body):
	if body.name == "Player":
		player_near = false
		player = null
