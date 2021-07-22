extends MarginContainer


func _on_Button_pressed():
	# Removes the CLUF scene from the Tree
	queue_free()
