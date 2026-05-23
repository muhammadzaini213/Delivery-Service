extends CanvasLayer

@onready var delivery_text = $DeliveryText

func _on_delivery_timer_timeout():

	delivery_text.visible = false
