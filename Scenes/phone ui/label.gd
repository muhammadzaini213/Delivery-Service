extends Label
var flat = [101,102,103,201,202,203,301,302,303,401,402,403,501,502,503]
@export var deliver: int = 101


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deliver = flat.pick_random()
	$".".text = "Order Recieved from "+str(deliver)
	while true:
		await get_tree().create_timer(30.0).timeout
		deliver = flat.pick_random()
		$".".text = "Order Recieved from "+str(deliver)
