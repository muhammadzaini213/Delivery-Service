extends CharacterBody2D

@export var walk_speed = 200
@export var max_pizzas := 5
@export var pizzas_held := 5

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):

	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	if not is_on_floor():
		velocity.y += gravity * delta

	velocity.x = direction * walk_speed

	if direction < 0:
		$Sprite2D.flip_h = true
	elif direction > 0:
		$Sprite2D.flip_h = false

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
