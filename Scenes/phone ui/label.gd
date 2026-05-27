extends Label

var flat = [101,102,103,201,202,203,301,302,303,401,402,403,501,502,503]
@export var deliver: int = 101
var receivingOrder: bool = false

@onready var my_button = $"../CheckButton"

func _ready() -> void:
	# Connect the signal manually
	my_button.toggled.connect(_on_check_button_toggled)
	# Set initial text
	text = "not receiving orders"

func _on_check_button_toggled(toggled_on: bool) -> void:
	receivingOrder = toggled_on
	
	if receivingOrder:
		start_order_cycle()
	else:
		text = "not receiving orders"

func start_order_cycle() -> void:
	# This loop runs as long as receivingOrder is true
	while receivingOrder:
		deliver = flat.pick_random()
		text = "Order Recieved from " + str(deliver)
		
		# Wait for 30 seconds before the next order
		await get_tree().create_timer(30.0).timeout
		
		# If the user toggled it OFF during the 30s wait, break the loop
		if not receivingOrder:
			break
