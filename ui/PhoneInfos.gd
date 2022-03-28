extends MarginContainer

signal next_button_pressed


func _on_next_pressed():
	emit_signal("next_button_pressed")
