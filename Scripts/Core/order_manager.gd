extends Node

signal orders_changed
signal order_received(flat_number)
signal receiving_orders_changed(receiving)
signal balance_changed(balance)
signal upgrades_changed

const AVAILABLE_FLATS := [101, 102, 103, 201, 202, 203, 301, 302, 303, 401, 402, 403, 501, 502, 503]
const MAX_ACTIVE_ORDERS := 6
const MIN_ORDER_INTERVAL_SECONDS := 4.0
const MAX_ORDER_INTERVAL_SECONDS := 18.0
const BASE_DELIVERY_PROFIT := 1
const PROFILE_UPGRADE_COSTS := [5, 12, 25]
const PROFILE_UPGRADE_REWARDS := [1, 2, 3]

var current_floor := 1
var receiving_orders := false
var active_orders: Array[int] = []
var balance := 0
var profile_upgrade_levels := [0, 0, 0]
var _order_loop_running := false
var no_of_pizza = 5

func set_receiving_orders(enabled: bool) -> void:
	if receiving_orders == enabled:
		return

	receiving_orders = enabled
	receiving_orders_changed.emit(receiving_orders)

	if receiving_orders:
		_start_order_loop()

func has_order(flat_number: int) -> bool:
	return active_orders.has(flat_number)

func complete_order(flat_number: int) -> int:
	var order_index = active_orders.find(flat_number)
	if order_index == -1:
		return 0

	active_orders.remove_at(order_index)
	var earned = get_delivery_profit()
	balance += earned
	orders_changed.emit()
	balance_changed.emit(balance)
	return earned

func get_delivery_profit() -> int:
	var profit = BASE_DELIVERY_PROFIT
	for upgrade_index in range(profile_upgrade_levels.size()):
		profit += profile_upgrade_levels[upgrade_index] * PROFILE_UPGRADE_REWARDS[upgrade_index]

	return profit

func buy_profile_upgrade(upgrade_index: int) -> bool:
	if upgrade_index < 0 or upgrade_index >= PROFILE_UPGRADE_COSTS.size():
		return false

	var cost = PROFILE_UPGRADE_COSTS[upgrade_index]
	if balance < cost:
		return false

	balance -= cost
	profile_upgrade_levels[upgrade_index] += 1
	balance_changed.emit(balance)
	upgrades_changed.emit()
	return true

func get_upgrade_text(upgrade_index: int) -> String:
	return "Upgrade %s: +$%s/order - $%s (Lv %s)" % [
		upgrade_index + 1,
		PROFILE_UPGRADE_REWARDS[upgrade_index],
		PROFILE_UPGRADE_COSTS[upgrade_index],
		profile_upgrade_levels[upgrade_index]
	]

func get_orders_text() -> String:
	if not receiving_orders:
		return "Not receiving orders"

	if active_orders.is_empty():
		return "Waiting for orders"

	var order_lines: Array[String] = ["Orders:"]
	var current_line := ""
	for flat_number in active_orders:
		if current_line.is_empty():
			current_line = str(flat_number)
		else:
			current_line += ", " + str(flat_number)

		if current_line.length() >= 13:
			order_lines.append(current_line)
			current_line = ""

	if not current_line.is_empty():
		order_lines.append(current_line)

	return "\n".join(order_lines)

func _start_order_loop() -> void:
	if _order_loop_running:
		return

	_order_loop_running = true
	_order_loop()

func _order_loop() -> void:
	while receiving_orders:
		await get_tree().create_timer(randf_range(MIN_ORDER_INTERVAL_SECONDS, MAX_ORDER_INTERVAL_SECONDS)).timeout

		if not receiving_orders:
			break

		if active_orders.size() < MAX_ACTIVE_ORDERS:
			_add_random_order()

	_order_loop_running = false

func _add_random_order() -> void:
	var possible_flats: Array[int] = []
	for flat_number in AVAILABLE_FLATS:
		if not active_orders.has(flat_number):
			possible_flats.append(flat_number)

	if possible_flats.is_empty():
		return

	var flat_number = possible_flats.pick_random()
	active_orders.append(flat_number)
	order_received.emit(flat_number)
	orders_changed.emit()
