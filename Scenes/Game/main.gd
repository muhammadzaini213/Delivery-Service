extends Node

const OUTSIDE_FLOOR := 0
const MIN_FLOOR := 1
const MAX_FLOOR := 5

var current_floor := 1
var transitioning := false

@onready var player = $Player
@onready var apartment = $Apartment
@onready var outside = $Outside
@onready var flats = $Apartment/Flats
@onready var up_staircase = $Apartment/UpStaircase
@onready var floor_text = $UI/FloorText
@onready var pizza_text = $UI/PizzaText
@onready var fade_rect = $UI/FadeRect
@onready var delivery_text = $UI/DeliveryText
@onready var delivery_timer = $UI/DeliveryTimer

func _ready():
	update_floor()
	update_pizza_text()
	fade_rect.color.a = 0.0

func _process(_delta):
	if Input.is_action_just_pressed("phone ui"):
		get_tree().change_scene_to_file("res://Scenes/phone ui/phone ui.tscn")

func use_staircase(direction):
	if transitioning:
		return

	if direction == "up" and current_floor < MAX_FLOOR:
		change_floor(current_floor + 1)
	elif direction == "down" and current_floor > OUTSIDE_FLOOR:
		change_floor(current_floor - 1)

func enter_apartment():
	if transitioning or current_floor != OUTSIDE_FLOOR:
		return

	change_floor(MIN_FLOOR)

func change_floor(next_floor):
	transitioning = true

	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 1.0, 0.35)
	await tween.finished

	current_floor = next_floor
	update_floor()
	delivery_text.visible = false

	tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, 0.35)
	await tween.finished

	transitioning = false

func update_floor():
	var is_outside = current_floor == OUTSIDE_FLOOR

	apartment.visible = not is_outside
	outside.visible = is_outside
	floor_text.text = "Outside" if is_outside else "Floor %s" % current_floor
	up_staircase.visible = current_floor < MAX_FLOOR

	for flat in flats.get_children():
		flat.set_floor_number(current_floor)

func update_pizza_text():
	pizza_text.text = "Pizzas: %s/%s" % [player.pizzas_held, player.max_pizzas]

func show_message(message):
	delivery_text.text = message
	delivery_text.visible = true
	delivery_timer.start()
