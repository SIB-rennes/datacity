extends MarginContainer


signal start_dialogue
signal close_notification


func set_string(text: String):
	$VBoxContainer/MessageMargins/Background/Label.text = text


func _on_Quit_pressed():
	emit_signal("close_notification")


func _on_StartDialog_pressed():
	emit_signal("start_dialogue")
