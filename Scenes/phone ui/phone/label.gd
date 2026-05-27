extends Label

@onready var my_button = $"../CheckButton"

func _ready() -> void:
	my_button.toggled.connect(_on_check_button_toggled)
	OrderManager.orders_changed.connect(update_order_text)
	OrderManager.order_received.connect(_on_order_received)
	OrderManager.receiving_orders_changed.connect(_on_receiving_orders_changed)

	my_button.set_pressed_no_signal(OrderManager.receiving_orders)
	update_order_text()

func _on_check_button_toggled(toggled_on: bool) -> void:
	OrderManager.set_receiving_orders(toggled_on)

func update_order_text() -> void:
	text = OrderManager.get_orders_text()

func _on_order_received(flat_number: int) -> void:
	text = "New: Flat " + str(flat_number) + "\n" + OrderManager.get_orders_text()

func _on_receiving_orders_changed(receiving_orders: bool) -> void:
	my_button.set_pressed_no_signal(receiving_orders)
	update_order_text()
