extends CanvasLayer

@onready var phone_ui: ColorRect = $Phone_UI

func ready():
	phone_ui.visible = false
	
func _on_Order1_toggled() -> void:
	print("oh Boy")

func _on_pressed() -> void:
	print("bro Why")


func _on_button_down() -> void:
	print("Oh mmm nah")
