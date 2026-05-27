extends Node2D

@onready var balance_label = $BalanceLabel
@onready var profit_label = $ProfitLabel
@onready var orders_label = $OrdersLabel

func _ready() -> void:
	$BackButton.pressed.connect(_on_back_button_pressed)
	OrderManager.balance_changed.connect(_on_balance_changed)
	OrderManager.orders_changed.connect(update_view)
	update_view()

func update_view() -> void:
	balance_label.text = "Current Balance: $%s" % OrderManager.balance
	profit_label.text = "Pizza Profit: $%s/order" % OrderManager.get_delivery_profit()
	orders_label.text = "Active Orders: %s/%s" % [OrderManager.active_orders.size(), OrderManager.MAX_ACTIVE_ORDERS]

func _on_balance_changed(_balance: int) -> void:
	update_view()

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/phone ui/phone/phone ui.tscn")
