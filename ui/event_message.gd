extends MarginContainer


signal start_dialogue
signal close_notification


func set_string(text: String):
	$VBoxContainer/MessageMargins/Background/Label.text = text
