extends CharacterBody2D

@export var walk_speed = 200
@export var sprint_speed = 350

func _physics_process(delta):

	var direction = Vector2.ZERO

	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	var current_speed = walk_speed

	if Input.is_key_pressed(KEY_SHIFT):
		current_speed = sprint_speed

	velocity = direction.normalized() * current_speed

	move_and_slide()
