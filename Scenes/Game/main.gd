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
@onready var down_staircase = $Apartment/DownStaircase
@onready var up_staircase_collision = $Apartment/UpStaircase/CollisionShape2D
@onready var down_staircase_collision = $Apartment/DownStaircase/CollisionShape2D
@onready var floor_text = $UI/FloorText
@onready var pizza_text = $UI/PizzaText
@onready var fade_rect = $UI/FadeRect
@onready var delivery_text = $UI/DeliveryText
@onready var delivery_timer = $UI/DeliveryTimer

@onready var ambience: AudioStreamPlayer2D = $Ambience
@onready var part_1: AudioStreamPlayer2D = $Part1
@onready var part_2: AudioStreamPlayer2D = $Part2
@onready var part_3: AudioStreamPlayer2D = $Part3

func _ready():
	OrderManager.order_received.connect(_on_order_received)
	current_floor = OrderManager.current_floor
	update_floor()
	update_pizza_text()
	fade_rect.color.a = 0.0

func _process(_delta):
	if Input.is_action_just_pressed("open_phone"):
		OrderManager.current_floor = current_floor
		get_tree().change_scene_to_file("res://Scenes/phone ui/phone/phone ui.tscn")

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
	ambience.stop()
	part_1.play()
	part_3.stop()
	change_floor(MIN_FLOOR)

func change_floor(next_floor):
	transitioning = true

	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 1.0, 0.35)
	await tween.finished

	current_floor = next_floor
	OrderManager.current_floor = current_floor
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
	down_staircase.visible = not is_outside
	up_staircase_collision.disabled = is_outside or current_floor >= MAX_FLOOR
	down_staircase_collision.disabled = is_outside

	if is_outside:
		ambience.play()
		part_1.stop()
		part_3.play()
	
	for flat in flats.get_children():
		flat.set_floor_number(current_floor)

func update_pizza_text():
	pizza_text.text = "Pizzas: %s/%s" % [player.pizzas_held, player.max_pizzas]

func show_message(message):
	delivery_text.text = message
	delivery_text.visible = true
	delivery_timer.start()

func _on_order_received(flat_number):
	show_message("New order: Flat %s" % flat_number)
