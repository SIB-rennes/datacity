extends MarginContainer


signal Im_sure

signal No_its_a_mistake


func _on_validate_pressed():
	emit_signal("Im_sure")


func _on_cancel_pressed():
	emit_signal("No_its_a_mistake")
