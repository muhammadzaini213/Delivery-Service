extends StaticBody2D

var player_near = false

@onready var delivery_text = $"../../UI/DeliveryText"
@onready var delivery_timer = $"../../UI/DeliveryTimer"
@onready var success_sound = $SuccessSound

func _process(delta):

	if player_near and Input.is_key_pressed(KEY_E):

		delivery_text.visible = true
		delivery_timer.start()
		success_sound.play()

		print("DELIVERED!")

func _on_interact_area_body_entered(body):

	if body.name == "Player":
		player_near = true
		print("PLAYER ENTERED")

func _on_interact_area_body_exited(body):

	if body.name == "Player":
		player_near = false
		print("PLAYER EXITED")
