extends Node

@onready var my_button = $"." # Path to your button node

func _ready():
	# Connect the signal to a local function
	my_button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/phone ui/UpgradeShop/UpgradeShop.tscn")
