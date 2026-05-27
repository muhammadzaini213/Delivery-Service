extends Node2D

@onready var balance_label = $BalanceLabel
@onready var profit_label = $ProfitLabel
@onready var status_label = $StatusLabel
@onready var upgrade_buttons = [$Upgrade1, $Upgrade2, $Upgrade3]

func _ready() -> void:
	$BackButton.pressed.connect(_on_back_button_pressed)
	for upgrade_index in range(upgrade_buttons.size()):
		upgrade_buttons[upgrade_index].pressed.connect(_on_upgrade_pressed.bind(upgrade_index))

	OrderManager.balance_changed.connect(_on_balance_changed)
	OrderManager.upgrades_changed.connect(update_view)
	update_view()

func update_view() -> void:
	balance_label.text = "Balance: $%s" % OrderManager.balance
	profit_label.text = "Profit: $%s/order" % OrderManager.get_delivery_profit()
	status_label.text = "Good Pizzas"

	for upgrade_index in range(upgrade_buttons.size()):
		upgrade_buttons[upgrade_index].text = OrderManager.get_upgrade_text(upgrade_index)
		upgrade_buttons[upgrade_index].disabled = OrderManager.balance < OrderManager.PROFILE_UPGRADE_COSTS[upgrade_index]

func _on_upgrade_pressed(upgrade_index: int) -> void:
	if OrderManager.buy_profile_upgrade(upgrade_index):
		update_view()
		status_label.text = "Profile upgraded!"
	else:
		update_view()
		status_label.text = "Not enough money"

func _on_balance_changed(_balance: int) -> void:
	update_view()

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/phone ui/phone/phone ui.tscn")
