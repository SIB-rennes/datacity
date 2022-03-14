extends MarginContainer

func update_message(block):
	var aff_message = $HBoxContainer/MarginContainer/background/MarginContainer/RichTextLabel
	print(block)
	aff_message.set_text(block)

func update_name(speaker_name):
	var speaker = $HBoxContainer/VBoxContainer/speaker
	speaker.set_text(speaker_name)
