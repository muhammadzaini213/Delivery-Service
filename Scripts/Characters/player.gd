extends CharacterBody2D

@export var walk_speed = 200
@export var sprint_speed = 350
@export var max_pizzas := 5
@export var pizzas_held := 5

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var is_sprinting = Input.is_key_pressed(KEY_SHIFT)
	var current_speed = sprint_speed if is_sprinting else walk_speed

	if not is_on_floor():
		velocity.y += gravity * delta

	velocity.x = direction * current_speed

	if direction < 0:
		$AnimatedSprite2D.flip_h = true
	elif direction > 0:
		$AnimatedSprite2D.flip_h = false

	var target_animation = "idle"
	if direction != 0:
		target_animation = "sprint" if is_sprinting else "walk"

	if $AnimatedSprite2D.animation != target_animation:
		$AnimatedSprite2D.play(target_animation)

	move_and_slide()

func deliver_pizza():
	if pizzas_held <= 0:
		return false

	pizzas_held -= 1
	return true

func collect_pizzas():
	if pizzas_held >= max_pizzas:
		return false

	pizzas_held = max_pizzas
	return true
